#!/bin/bash
set -e
# Version: 0.0.2
source ${scripts_dir}/.envrc

#################################################  Begin User Options  #########
#set -e
gotcha_mac="12:B3:F4:47:58:B7"
sniffer_mac="22:22:22:22:22:22"
FuckThatSh1t_mac="33:33:33:33:33:33"
larry_host=potato
cory_host=updates
mike_host=TODO
backup_dir=/opt/backup

###################################################  End User Options  #########

source support-Banner_func.sh

sudo su
if [ -d /home/pi ]; then
   sudo chown -vR pi:pi /home/pi/*
fi

if [ -d /opt/backup ]; then
   sudo chown -vR 1000:1000 /opt/backup/*
   sudo chown -vR 1000:1000 /home/1000
#   cd /opt/backup/root
#   sudo chown -vR beesoc:beesoc /opt/backup/root/*.*
#   sudo chown -vR beesoc:beesoc ./.*
fi

if [ -d /home/beesoc ]; then
   sudo chown -vR beesoc:beesoc *
fi
