#!/bin/bash
#
set -e
# Version: 0.0.2
source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/support-Banner_func.sh"
trap ${scripts_dir}/support/support-trap-wifi.sh EXIT

sudo ifconfig ${adapter} down
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
sudo macchanger -p ${adapter}
sudo ifconfig ${adapter} up
