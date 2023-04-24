#!/bin/bash

set -e

cd ..
source .envrc

source support/Banner_func.sh

# get a list of wireless network interfaces
interfaces=$(iwconfig 2>/dev/null | grep -o "^[^ ]*")

# iterate over the interfaces and check their mode
for iface in $interfaces; do
  mode=$(iwconfig $iface 2>/dev/null | grep -o "Mode:[^ ]*" | cut -f2 -d:)

  if [ "$mode" = "Monitor" ]; then
    # switch the interface to managed mode
    sudo iwconfig $iface mode managed

    # restart wpa_supplicant and Network Manager services
    sudo systemctl restart wpa_supplicant.service NetworkManager.service

    echo "Interface $iface switched to managed mode"
  fi
done

