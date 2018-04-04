# RAPTURE
Shell script to install a [RAPTURE Masternode](https://our-rapture.com/) on a Linux server running Ubuntu 16.04. Use it on your own risk.

## Installation
```
wget https://github.com/smai2018/RAPTURE-masternode-autoinstall/raw/master/rapture-setup.sh
bash rapture-setup.sh
```
## Usage control script:

```
rap-control.sh 

-a start the RAPTURE service
-b stop the RAPTURE service
-c status of the RAPTURE service
-d checks the autostart of the RAPTURE service when the server is starting
-e staus of masternode sync (mnsync status)
-f status of the masternode (masternode status)
-g check of the sentinel logfile
-h help - usage for this script
-i check the cronjob logfile

```
If you want to check/start/stop **RAPTURE**, run one of the following commands as **root**:

```
systemctl status RAP #To check if RAPTURE service is running
systemctl start RAP #To start RAPTURE service
systemctl stop RAP #To stop RAPTURE service
systemctl is-enabled RAP #To check if RAPTURE service is enabled on boot
```

## Donations

Any donation is highly appreciated

**RAP**: RT3p6q5xG8vCcfCNjQERGZfgRRcoWqU6LW 
