#!/bin/bash
# Version: 0.0.2
source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/support-Banner_func.sh"
#
trap ${scripts_dir}/support/support-trap-wifi.sh
printf "${CY}Starting NetworkManager and wpa_supplicant services ${WHITE}"
sudo ifconfig $adapter down
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo macchanger -r $adapter
sudo ifconfig $adapter up
