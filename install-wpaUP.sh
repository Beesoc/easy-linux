#!/bin/bash
#
sudo ifconfig wlan0 down
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
sudo macchanger -p wlan0
sudo ifconfig wlan0 up
