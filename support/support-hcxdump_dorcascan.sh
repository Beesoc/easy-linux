#!/bin/bash
#install and use hcxtools w hashcat and jack
#
set -e
#
trap /opt/easy-linux/support/support-hcxdump.sh EXIT
# Version: 0.0.4
#	timeout -v 32s ${scripts_dir}/support/support-hcxdump2.sh
do_rcascan=0
timeout -v 40s sudo hcxdumptool -i "${adapter}" --do_rcascan &
timeout -v 38s echo "export do_rcascan=1"
sleep 1
source /opt/easy-linux/support/support-hcxdump.sh
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant