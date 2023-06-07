#!/bin/bash
#
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
clear
source "${scripts_dir}/support/support-Banner_func.sh"
trap ${scripts_dir}/support/support-trap-wifi.sh EXIT

printf "  ${CY}This script will either ${WT}kill or restart ${CY}your ${WT}Network Manager and wpa_supplicant services${CY}.\\n"
printf "  ${CT}These 2 services frequently cause issues with Monitor (hacking) mode so this script \\n" 
printf "  power cycles the processes. This is a normal activity before and after hacking.\\n"

read -n 1 -r -p "  Do you want to continue? [Y/n] ----> " status
status=${status:-y}
if [ "${status}" =~ ^[Y/y]$ ]; then
sudo ifconfig ${adapter} down
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant

sudo ifconfig ${adapter} up
elif [ "${status}" =~ ^[n/N]$ ]; then
sudo ifconfig ${adapter} down
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant

sudo ifconfig ${adapter} up
else
  printf "${RED}  Invalid Selection. Valid options are U or D.\\n"
fi
