#!/bin/bash
# Network Adapter chooser
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
trap "source ${scripts_dir}/support/support-trap-wifi.sh" EXIT

wlan_sel_func() {
    adapter_count=$(sudo airmon-ng | awk '/wl/ {print}' | wc -l)

    if [ "$adapter_count" -gt 1 ]; then
        # If there are multiple wireless interfaces, prompt the user to select one
        printf "\\n${CY}You have ${WT}$adapter_count${CY} wireless network adapters.\\n"
        printf "\\n${OG}Multiple wireless interfaces available.${WT}\\n"
        printf "${CY}Please select one:\\n${OG}"

        sudo airmon-ng | awk '/wl/ {print $2 " - " $4 " " $5}' 2>/dev/null | grep "wl" | nl -nln

        printf "\\n${WT}"
        read -n 1 -r -p "Enter the number of the interface you want to use in monitor mode: " selection
        selection=${selection:-1}
        adapter=$(sudo airmon-ng | awk '/wl/ {print $2}' | cut -d' ' -f1 | sed -n "${selection}p")

    else
        adapter="wlan0"
    fi

    sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
    printf "\\n${OG}You have selected wireless adapter: $adapter.${NC}\\n"
    sleep 3
}


how_many_func() {
    if command -v airmon-ng >/dev/null 2>&1 || command -v aircrack-ng >/dev/null; then
        adapter_count=$(sudo airmon-ng | awk '/wl/ {print $2}' | grep -c "wl")
        adapter=0
        
        if [ "$adapter_count" == 1 ]; then
            adapter=$(sudo airmon-ng | awk '/wl/ {print $2}')
            printf "\\n${CY}You have ${WT}$adapter_count${CY} wireless network adapter, $adapter.\\n"
            sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
            sleep 3
            return 0
        elif [ "$adapter_count" -gt 1 ]; then
            adapter_choice=""
            wlan_sel_func
        elif [ "$adapter_count" -eq 0 ]; then
            printf "\\n${RED}No wireless adapters found. Cannot proceed.${NC}\\n"
            return
        fi
    else
      
        while true; do
            printf "  ${WT}Aircrack-NG ${OG}is required to use this script.${WT}\\n"
            read -n -r -p "Would you like to install Aircrack-NG now? [Y/n] " aircrack
            aircrack=${aircrack:-Y}

            if [[ "$aircrack" =~ ^[yY]$ ]]; then
                "${scripts_dir}/support/support-aircrack2.sh"
                exit_code=$?

                if [ "$exit_code" -eq 0 ]; then
                    break
                else
                    printf "\\n${OG}We have encountered an error or need to restart.${NC}\\n"
                    printf "${OG}Restarting this script...${NC}\\n"
                    echo
                fi
            elif [[ "$aircrack" =~ ^[nN]$ ]]; then
                printf "\\n${WT}$USER ${RED}has selected to NOT install Aircrack-NG. Exiting.${NC}\\n"
                exit 0
            else
                printf "\\n${RED}Invalid selection. Options are Y or N only.${NC}\\n"
            fi
        done
    fi

#        return
#    fi
}


#        while true; do
#            printf "  ${WT}Aircrack-NG ${OG}is required to use this script.${WT}\\n"
#            read -n -r -p "Would you like to install Aircrack-NG now? [Y/n] " aircrack
#            aircrack=${aircrack:-Y}

#            if [[ "$aircrack" =~ ^[yY]$ ]]; then
#                "${scripts_dir}/support/support-aircrack2.sh"
#                exit_code=$?

#                if [ "$exit_code" -eq 0 ]; then
#                    break
#                else
#                    printf "\\n${OG}We have encountered an error or need to restart.${NC}\\n"
#                    printf "${OG}Restarting this script...${NC}\\n"
#                    echo
#                fi
#            elif [[ "$aircrack" =~ ^[nN]$ ]]; then
#                printf "\\n${WT}$USER ${RED}has selected to NOT install Aircrack-NG. Exiting.${NC}\\n"
#                exit 0
#            else
#                printf "\\n${RED}Invalid selection. Options are Y or N only.${NC}\\n"
#            fi
#        done
#    fi
#}

main() {
    while true; do
        how_many_func

        if [ "$adapter_count" -eq 1 ] && [ -n "$adapter" ] && command -v aircrack-ng >/dev/null 2>&1; then
            break  # Exit the loop
        elif [ "$adapter_count" -gt 1 ] && [ ! -n "$adapter" ] && command -v aircrack-ng >/dev/null 2>&1; then
            wlan_sel_func
        elif [ "$adapter_count" -gt 1 ] && [ -n "$adapter" ] && command -v aircrack-ng >/dev/null 2>&1; then
            break            
        else
            printf "\\n${OG}  I have encountered an error or need to be restarted.${NC}\\n"
            printf "    ${OG}Restarting this script...${NC}\\n"
            echo
        fi
    done
}


main

