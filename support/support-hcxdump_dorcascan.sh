#!/bin/bash
#install and use hcxtools w hashcat and jack
#
set -e
#
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
trap /opt/easy-linux/support/support-hcxdump_full.sh EXIT
# Version: 0.0.4
#	timeout -v 32s ${scripts_dir}/support/support-hcxdump2.sh
printf "${OG}The next scan is ${WT}timed for 60 secs ${OG}and helps ID targets.\\n"
printf "${CY}You are currently set to use $adapter for this scan.\\n"
read -n 1 -r -p "  Is that the correct wifi adapter to use? [Y/n] ----> " whatad
whatad=${whatad:-Y}
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
#timeout -v 38s echo "export do_rcascan=1" &
if [[ "$whatad" =~ ^[yY]$ ]]; then
  sudo ifconfig $adapter down
  sudo ifconfig $adapter up
  sleep 2
  timeout -v 60s sudo hcxdumptool -i ${adapter} -o ${scripts_dir}/support/misc/hcxdumptool.pcapng --do_rcascan
  sleep 1
elif [[ "$whatad" =~ ^[nN]$ ]]; then
  ${scripts_dir}/support/support-netadapter.sh
  sudo ifconfig $adapter down
  sudo ifconfig $adapter up
  sleep 2
  timeout -v 60s sudo hcxdumptool -i ${adapter} -o ${scripts_dir}/support/misc/hcxdumptool.pcapng --do_rcascan
  
  sleep 1
else
    printf "${RED}  Invalid selection.  Valid options are Y or N. \\n" 
fi
read -n 1 -r -p "Press any key to continue" anykey
#source /opt/easy-linux/support/support-hcxdump.sh
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant...\\n"
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
