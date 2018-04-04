#!/bin/bash

usage="usage message..."
VERBOSE=true
counter="0"
while getopts 'edrsm?' option
do
  case "$option" in
  e) systemctl start RAPTURE.service
     systemctl status RAPTURE.service
     ((counter+=1))
     ;;
  d) systemctl stop RAPTURE.service
     systemctl status RAPTURE.service
     ((counter+=1))
     ;;
  r) systemctl is-active RAPTURE.service
     systemctl is-enabled RAPTURE.service
     ((counter+=1))
     ;;
  s) /root/rapturecore-1.1.1/bin/rapture-cli mnsync status
     ((counter+=1))
     ;;
  m) /root/rapturecore-1.1.1/bin/rapture-cli masternode status
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
