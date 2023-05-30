#!/bin/bash
# script to switch wifi adapter between MONITOR and managed mode.
set -e
# Version: 0.0.4
#
clear
scripts_dir=/opt/easy-linux

source "${scripts_dir}/.envrc"

services_func() {

  sudo rfkill block wifi &
  sudo systemctl start NetworkManager &
  sudo systemctl start wpa_supplicant &
  sudo rfkill unblock wifi

}

# Trap function for abnormal script exit (ERR signal)
err_trap_func() {
  printf "\\n${RED}Script exited abnormally.${OG}\\n"
  services_func
  exit 1
}

# Trap function for Ctrl+C interruption (SIGINT signal)
int_trap_func() {
  printf "\\n${RED}Script interrupted.${OG}\\n"
  services_func
  exit 1
}

# Set traps for abnormal exit and interruption
trap err_trap_func ERR
trap int_trap_func SIGINT

change_net_func() {
  sudo ifconfig $adapter down
  sudo airmon-ng check kill
  
  if [[ $mode == "monitor" ]]; then
    sudo airmon-ng stop ${adapter}
    sudo ifconfig ${adapter} up
    mode="managed"
    sleep 1; printf "\\n3..."; sleep 1; printf "2..."; sleep 1; printf "1...\\n"
    sudo systemctl start NetworkManager &
    sudo systemctl start wpa_supplicant &
    return 0
  elif [[ $mode == "managed" ]]; then
    sudo airmon-ng start $adapter
    sudo ifconfig ${adapter} up
    mode="monitor"
    sleep 1; printf "\\n3..."; sleep 1; printf "2..."; sleep 1; printf "1...\\n"
    sudo systemctl start NetworkManager &
    sudo systemctl start wpa_supplicant &
    return 0
  fi

  printf "\\n${OG}Starting NetworkManager and wpa_supplicant${OG}.\\n"
}

choice_func() {
  if [[ $mode == "monitor" ]]; then
    printf "${GN}  You are currently in ${WT}$mode Mode${GN} on ${WT}${adapter}${GN}.\\n"
    printf "This mode is for hacking. ${WT}Wifi won't work ${GN}while it's enabled.\\n"
    read -n 1 -r -p "Do you want to change to the default mode, managed? [y/N] ----> " choice
    choice=${choice:-n}
    printf "\\n"
    if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
      # Code to change adapter back to managed mode
      change_net_func
      sudo systemctl start NetworkManager &
      sudo systemctl start wpa_supplicant &
      printf "Adapter $adapter changed to $mode mode.\\n"
      return 0
    elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then
      printf "  ${WT}$USER ${OG}has selected to ${WT}keep their wifi in hacking mode (monitor mode)${OG}.\\n"
      return 0
    else
        printf "  ${RED}Invalid Selection. Options are Y or N." 
    fi
  elif [[ $mode == "managed" ]]; then
    printf "${GN}  You are currently in ${WT}$mode mode${GN} on ${WT}$adapter${GN}.\\n"
    printf "This mode is for accessing the internet. ${WT}Hacking won't work ${GN}while it's enabled.\\n"
    read -n 1 -r -p "Do you want to change it to monitor mode (for hacking only)? [Y/n] ----> " choice2
    choice2=${choice2:-y}
    printf "\\n"
    if [[ $choice2 == "y" ]] || [[ $choice2 == "Y" ]]; then
      # Code to change adapter to monitor mode

      change_net_func
      sudo systemctl restart NetworkManager &
      sudo systemctl start wpa_supplicant
      #sudo systemctl start wpa_supplicant
      printf "Adapter $adapter changed to $mode mode.\\n"
      return 0
    elif [[ $choice2 == "n" ]] || [[ $choice2 == "N" ]]; then
      printf "  ${WT}$USER ${OG}has selected to ${WT}keep their wifi in managed mode${OG}.\\n"
      sudo systemctl start NetworkManager &
      sudo systemctl start wpa_supplicant &
      return 0
    else
      printf "  ${RED}Invalid Selection. Valid options are Y or N."
      sudo systemctl start NetworkManager &
      sudo systemctl start wpa_supplicant &
    fi
  fi
}

main() {
  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"

  available_adapters=$(find /sys/class/net -type l -name 'wlan*')
  adapter_count=$(echo "$available_adapters" | wc -l)

  if [[ $adapter_count -eq 0 ]]; then
    printf "  No wifi adapters detected\\n"
    printf "${RED}  ERROR:${WT} No wifi adapters ${RED}can be seen on your PC at this time.\\n"
    printf "  ${OG}NOTE: At this time, wifi adapters must use the wlan? naming convention.\\n"
    adapter=""
  elif [[ $adapter_count -eq 1 ]]; then
    adapter=wlan0
    printf "  Only 1 wifi adapter detected. Selecting $adapter\\n"
    sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
    choice_func
  else
    printf "\\n${CY}You have ${WT}$adapter_count${CY} wireless network adapters.\\n"
    printf "${CY}  Please select one:\\n${OG}"

    sudo airmon-ng | awk '/wl/ {print $2 " - " $4 " " $5}' 2>/dev/null | grep "wl" | nl -nln
    printf "\\n${WT}"
    # Disable interrupt handling
    # disable_interrupts
    read -n 1 -r -p "Enter the number of the interface you want to use in monitor mode: " selection
    # Enable interrupt handling
    # enable_interrupts
    printf "\\n"
    adapter=$(sudo airmon-ng | awk '/wl/ {print $2}' | cut -d' ' -f1 | sed -n "${selection}p")
    sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
  fi

  mode="$(iw dev $adapter info | awk '/type/ {print $2}')"
  choice_func
}

main
