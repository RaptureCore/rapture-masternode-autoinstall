#!/bin/bash

if [[ $USER != "root" ]]; then 
		echo "This script must be run as root!" 
		exit 1
fi

usage="./rap-control.sh [arguments]"
VERBOSE=true
counter="0"

while getopts 'abcdefghikl?' option
do
  case "$option" in
  a) systemctl start RAPTURE
     systemctl is-active RAPTURE
     ((counter+=1))
     ;;
  b) systemctl stop RAPTURE
     systemctl is-active RAPTURE
     ((counter+=1))
     ;;
  c) systemctl status RAPTURE
     ((counter+=1))
     ;;
  d) systemctl is-enabled RAPTURE
     ((counter+=1))
     ;;
  e) /root/rapturecore-1.1.1/bin/rapture-cli mnsync status
     ((counter+=1))
     ;;
  f) /root/rapturecore-1.1.1/bin/rapture-cli masternode status
     ((counter+=1))
     ;;
  g) cat /root/sentinel/sentinel.log
     ((counter+=1))
     ;;
  h) $usage
     ((counter+=1))
     ;; 
  i) grep CRON /var/log/syslog
     ((counter+=1))
     ;;
  k) ufw status
     ((counter+=1))
     ;;
  l) cat .rapturecore/rapture.conf
     ((counter+=1))
     ;;
  ?) $usage
     exit 0
     ;;
  esac
done

if [ $counter -eq 1 ];then
  exit 0
else
  echo $usage
  exit 1
fi
