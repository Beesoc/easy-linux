#!/bin/bash
# script to switch wifi adapter between MONITOR and managed mode.
set -e
# Version: 0.0.4
#
clear
scripts_dir=/opt/easy-linux

trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
source "${scripts_dir}/.envrc"

change_net_func() {
    sudo systemctl stop NetworkManager && sudo systemctl stop wpa_supplicant

        if [[ $mode == "monitor" ]]; then
           sudo ifconfig $adapter down
           sudo iw $adapter set type $mode
           sudo iwconfig $adapter power on 
           sudo ifconfig $adapter up
           sleep 1; printf "\\n3..."; sleep 1; printf "2..."; sleep 1; printf "1...\\n"
           sudo systemctl start NetworkManager && sudo systemctl start wpa_supplicant
           return 0
        elif [[ $mode == "managed" ]]; then
            sudo ifconfig $adapter down
            sudo iw $adapter set type $mode
            sudo iwconfig $adapter power off
            sudo ifconfig $adapter up
            sleep 1; printf "\\n3..."; sleep 1; printf "2..."; sleep 1; printf "1...\\n"
            sudo systemctl start NetworkManager && sudo systemctl start wpa_supplicant
            return 0

        fi

    printf "\\n${OG}Starting NetworkManager and wpa_supplicant${OG}.\\n"

}

main() {
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    adapter=""
    sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"

    available_adapters=$(find /sys/class/net -type l -name 'wlan*')
    adapter_count=$(echo "$available_adapters" | wc -l)

    if [[ $adapter_count -eq 0 ]]; then
        printf "  No wifi adapters detected\\n"; sleep 3
        printf "${RED}  ERROR:${WT} No wifi adapters ${RED}can be seen on your PC at this time.\\n"
        printf "  ${OG}NOTE: At this time, wifi adapters must use the wlan? naming convention.\\n"
        adapter="\\n"
    elif [[ $adapter_count -eq 1 ]]; then
        adapter=wlan0
        printf "  Only 1 wifi adapter detected. Selecting $adapter\\n"
        sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc" 
    else
        printf "\\n${CY}You have ${WT}$adapter_count${CY} wireless network adapters.\\n"
        printf "${CY}  Please select one:\\n${OG}"

        sudo airmon-ng | awk '/wl/ {print $2 " - " $4 " " $5}' 2>/dev/null | grep "wl" | nl -nln

        printf "\\n${WT}"
        read -n 1 -r -p "Enter the number of the interface you want to use in monitor mode: " selection
        printf "\\n"
        adapter=$(sudo airmon-ng | awk '/wl/ {print $2}' | cut -d' ' -f1 | sed -n "${selection}p")     
        sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc" 
    fi

    mode="$(iw dev $adapter info | awk '/type/ {print $2}')"

    if [[ $mode == "monitor" ]]; then
        printf "${GN}  You are currently in ${WT}$mode Mode${GN} on ${WT}${adapter}${GN}.\\n"
        printf "This mode is for hacking. ${WT}Wifi won't work ${GN}while it's enabled.\\n"
        read -n 1 -r -p "Do you want to change to the default mode? [Y/n] ----> " choice
        choice=${choice:-Y}
        printf "\\n"
        if [[ $choice == "y" ]] || [[ $choice == "Y" ]]; then
            # Code to change adapter back to managed mode
            mode="managed"
            change_net_func
            sudo systemctl restart NetworkManager
            sudo systemctl restart wpa_supplicant
            printf "Adapter $adapter changed to $mode mode.\n"
        elif [[ $choice == "n" ]] || [[ $choice == "N" ]]; then
            printf "  ${WT}$USER ${OG}has selected to ${WT}keep their wifi mode the same.${OG}.\n"
        fi
    elif [[ $mode == "managed" ]]; then
        printf "${GN}  You are currently in ${WT}$mode mode${GN} on ${WT}$adapter${GN}.\\n"
        printf "This mode is for accessing the internet. ${WT}Hacking won't work ${GN}while it's enabled.\\n"
        read -n 1 -r -p "Do you want to change it to monitor mode? [y/N] ----> " choice2
        choice2=${choice2:-N}
        printf "\\n"
        if [[ $choice2 == "y" ]] || [[ $choice2 == "Y" ]]; then
            # Code to change adapter to monitor mode
            mode="monitor"
            change_net_func
            sudo systemctl restart NetworkManager
            sudo systemctl restart wpa_supplicant
            printf "Adapter $adapter changed to $mode mode.\n"
        elif [[ $choice2 == "n" ]] || [[ $choice2 == "N" ]]; then
            printf "  ${WT}$USER ${OG}has selected to ${WT}keep their wifi mode the same.${OG}.\n"
        else
            printf "  ${RED}Invalid Selection. Valid options are Y or N."
        fi
    fi

}

main
