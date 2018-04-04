#!/bin/bash

CONFIG_FILE='rapture.conf'
CONFIGFOLDER='/root/.rapturecore'
COIN_DAEMON='rapturecore-1.1.1/bin/raptured'
COIN_CLI='rapturecore-1.1.1/bin/rapture-cli'
COIN_PATH='/usr/local/bin'
COIN_TGZ='https://github.com/RaptureCore/Rapture/releases/download/v1.1.1.0/rapturecore-1.1.1-linux64.tar.gz'
COIN_ZIP='rapturecore-1.1.1'
SENTINEL_REPO='https://github.com/RaptureCore/sentinel.git'
COIN_NAME='RAPTURE'
COIN_PORT='14777'

NODEIP=$(curl -s4 icanhazip.com)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function install_sentinel() {
  echo -e "------------------------------------------------------------------"
  echo -e "${GREEN}Install sentinel...${NC}"
  echo -e "Please be patient and wait a moment..."
  echo -e "------------------------------------------------------------------"
  apt-get -y install python-virtualenv virtualenv >/dev/null 2>&1
  git clone $SENTINEL_REPO >/dev/null 2>&1
  cd sentinel
  virtualenv ./venv >/dev/null 2>&1
  ./venv/bin/pip install -r requirements.txt >/dev/null 2>&1
  echo  "* * * * * cd root/sentinel && ./venv/bin/python bin/sentinel.py >> sentinel.log 2>&1" > $COIN_NAME.cron
  crontab $COIN_NAME.cron
  rm $COIN_NAME.cron >/dev/null 2>&1
}

function download_node() {
  echo -e "------------------------------------------------------------------"
  echo -e "${GREEN}Prepare to download $COIN_NAME${NC}"
  echo -e "Please be patient and wait a moment..."
  echo -e "------------------------------------------------------------------"
  #wget $COIN_TGZ
  clear
  #tar -xvf $COIN_ZIP
  #chmod +x $COIN_DAEMON
  #chmod +x $COIN_CLI
  cp $COIN_DAEMON $COIN_CLI $COIN_PATH
  cd - >/dev/null 2>&1
  #rm rapturecore-1.1.1-linux64.tar.gz >/dev/null 2>&1
  clear
}

function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking

ExecStart=/root/$COIN_DAEMON
ExecStop=/root/$COIN_CLI stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "------------------------------------------------------------------------------------------------------------------------"
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog"
    echo -e "------------------------------------------------------------------------------------------------------------------------"
    exit 1
  fi
}

function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w15 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w25 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
EOF
}

function create_key() {
  echo -e "Enter your ${RED}$COIN_NAME Masternode Private Key${NC} and press Enter:"
  read -e COINKEY
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
daemon=1
masternode=1
externalip=$NODEIP
masternodeprivkey=$COINKEY
maxconnections=50
EOF
}

function enable_firewall() {
  echo -e "------------------------------------------------------------------"
  echo -e "${GREEN}Installing and setting up firewall${NC}"
  echo -e "------------------------------------------------------------------"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}

function get_ip() {
  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
  do
    NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ]
    then
      echo -e "-----------------------------------------------------------------------------------------------"
      echo -e "${RED}More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
      INDEX=0
      for ip in "${NODE_IPS[@]}"
      do
        echo ${INDEX} $ip
      echo -e "-----------------------------------------------------------------------------------------------"  
        let INDEX=${INDEX}+1
      done
      read -e choose_ip
      NODEIP=${NODE_IPS[$choose_ip]}
  else
    NODEIP=${NODE_IPS[0]}
  fi
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "------------------------------------------------------------------"
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  echo -e "------------------------------------------------------------------"
  exit 1
fi
}

function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "------------------------------------------------------------------------------"
  echo -e "${RED}You are not running Ubuntu 16.04. Why? Installation is cancelled.${NC}"
  echo -e "------------------------------------------------------------------------------"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "------------------------------------------------------------------"
   echo -e "${RED}$0 must be run as root.${NC}"
   echo -e "------------------------------------------------------------------"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "-----------------------------------------------------------------------------------"
  echo -e "${RED}$COIN_NAME masternode is already installed! Installation is cancelled.${NC}"
  echo -e "-----------------------------------------------------------------------------------"
  exit 1
fi
}

function prepare_system() {
echo -e "-----------------------------------------------------------------------"
echo -e "Prepare the system to install ${GREEN}$COIN_NAME${NC} master node."
echo -e "Please be patient and wait a moment..."
echo -e "-----------------------------------------------------------------------"
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" sudo git wget curl ufw fail2ban nano >/dev/null 2>&1
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
wget https://github.com/smai2018/RAPTURE-masternode-autoinstall/raw/master/rap-control.sh && chmod +x rap-control.sh
if [ "$?" -gt "0" ];
  then
    echo -e "----------------------------------------------------------------------------------------------------------------------------------"
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install sudo git wget curl ufw fail2ban nano"
    echo -e "wget https://github.com/smai2018/RAPTURE-masternode-autoinstall/raw/master/rap-control.sh"
    echo -e "----------------------------------------------------------------------------------------------------------------------------------"
 exit 1
fi
clear
}

function important_information() {
 echo -e "================================================================================================================================"
 echo -e "${GREEN}$COIN_NAME Masternode is up and running${NC}."
 echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "Start manuell: systemctl start $COIN_NAME.service"
 echo -e "Stop manuell: systemctl stop $COIN_NAME.service"
 echo -e "VPS_IP:PORT $NODEIP:$COIN_PORT"
 echo -e "MASTERNODE PRIVATEKEY is: $COINKEY"
 echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "Use ${RED}$COIN_CLI masternode status${NC} to check your Masternode status."
 echo -e "${GREEN}Sentinel is installed in /root/sentinel/sentinel${NC}"
 echo -e "Sentinel logs: root/sentinel.log"
 echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config
  create_key
  update_config
  enable_firewall
  install_sentinel
  important_information
  configure_systemd
}

##### Main #####
clear
checks
prepare_system
download_node
setup_node
