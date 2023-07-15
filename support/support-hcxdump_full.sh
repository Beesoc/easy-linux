#!/bin/bash
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
#install and use hcxtools w hashcat and jack
# Version: 0.0.4
set -e
#
trap ${scripts_dir}/support/support-hcxdump.sh EXIT

main() {
printf "\\n${CY}You are currently set to use ${WT}$adapter ${CY}for this scan.\\n${GN}"
read -n 1 -r -p "  Is that the correct wifi adapter to use? [Y/n] ----> " whatad
sudo systemctl stop wpa_supplicant
sudo systemctl stop NetworkManager

whatad=${whatad:-Y}
if [[ "$whatad" =~ ^[yY]$ ]]; then
sudo ifconfig $adapter down
sudo ifconfig $adapter up 
   timeout -v 60s sudo hcxdumptool -i "${adapter}" -f 0 -f 1 -f 2 -f 4 -f 32 --stop_ap_attacks=600 --resume_ap_attacks=864000d --enable_status=31 --weakcandidate=12345678 --flood_beacon -o ${scripts_dir}/support/hcxdump_full.pcapng
elif [[ "$whatad" =~ ^[nN]$ ]]; then
   ${scripts_dir}/support/support-netadapter.sh
sudo ifconfig $adapter down
sudo ifconfig $adapter up 
   timeout -v 60s sudo hcxdumptool -i "${adapter}" -f 0 -f 1 -f 2 -f 4 -f 32 --stop_ap_attacks=600 --resume_ap_attacks=864000d --enable_status=31 --weakcandidate=12345678 --flood_beacon -o ${scripts_dir}/support/hcxdump_full.pcapng
else
  printf "${RED}    Invalid Selection.  Valid options are Y or N only."
fi
# this seemed to work
# sudo hcxdumptool -i wlan0 -o /opt/easy-linux/support/hcxdumptool.pcapng -f 0 -f 1 -f 2 -f 4 -f 32 -f 64 --enable_status=1
}

main
sleep 1
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
