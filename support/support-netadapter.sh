#!/bin/bash
# Network Adapter chooser
# Version: 0.0.4
set -e
scripts_dir=/opt/easy-linux

source "${scripts_dir}/.envrc"
trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT

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
        echo
    else
        adapter="wlan0"
    fi
sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc" 
}

aircrack_func() {
    if ! command -v aircrack-ng >/dev/null 2>&1; then
        while true; do
            printf "  ${WT}[?] Aircrack-NG ${OG}is required to use this script.${WT}\\n"
            read -n 1 -r -p "Would you like to install Aircrack-NG now? [Y/n] ---->" aircrack
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
}

main() {
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    adapter=""
        sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
    
if [[ -e /sys/class/net/wlan1 ]]; then
	    # Run the command for wlan1
  	    printf "${OG}  Multiple Wifi adapters detected."
	    wlan_sel_func
else
    printf "${CY}  Only 1 Wifi adapter detected. Selecting wlan0"
    adapter=wlan0
    sudo sed -i "s/adapter=.*/adapter=$adapter/g" "${scripts_dir}/.envrc"
fi

aircrack_func

}

# Run the main script
main
