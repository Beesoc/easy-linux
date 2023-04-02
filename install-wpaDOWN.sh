#!/bin/bash
#
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
LIGHTBLUE='\e[0;34m'
NC='\e[0m'
#
printf "${ORANGE}Starting NetworkManager and wpa_supplicant services ${WHITE}"
sudo ifconfig wlan0 down
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
sudo macchanger -r wlan0
sudo ifconfig wlan0 up
