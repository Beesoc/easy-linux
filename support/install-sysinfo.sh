#!/bin/bash
#set -e
# shellcheck source=.envrc
clear
source ${scripts_dir}/support/Banner_func.sh
source ${scripts_dir}/.envrc
# shellcheck source=./Banner_func.sh

# Display hostname and username
printf "${CY}TZ: ${WT}$(timedatectl | grep "Time zone:" | awk '{print $3}')            ${CY}Time: ${WT}$(date +%I:%M:%S\ ${GN}%p)        ${CY}Username: ${GN}$(whoami)""${WT}@""${GN}$(hostname)${NC}\\n"

printf "\\n${CY}System information for computer, ${WT}$(hostname) ${CY} on Date: ${WT}$(timedatectl | grep "Local time" | awk '{print $3", " $4}')\\n"

battery="$(acpi -b | awk '/Battery 0/ {print $3 $4 $5}')"
batt_per="$(acpi -b | awk '/Battery 0/ {print $4}')"
battery_state="$(acpi -b | awk '/Battery 0/ {print $3}')"
# Display Battery info
printf "\\n${CY}Your battery state is currently${WT} ${battery_state}${CY} and your machine has${WT} ${batt_per}% battery remaining.\\n"
printf "\\n"

# Display disk usage
disk_usage="$(df -h | awk '{if($NF=="/") print $5}')"
# Display CPU temperature in Fahrenheit
cpu_temp=$(sensors | awk '/^Package/{printf("%.0f°F\n", $4*1.8+32)}')
# Display IP address
ip_address=$(hostname -I | awk '{print $1}')
# Display CPU load
cpu_load=$(uptime | awk '{print $10,$11,$12}')
printf "${CY}Disk Usage: ${WT}${disk_usage}%   ${CY}IP:${WT} ${ip_address}    ${CY}CPU Load: ${WT}$cpu_load      ${CY}CPU Temp: ${WT}${cpu_temp} \\n"


# Display total number of updates and security updates available
updates=$(apt list --upgradable 2>/dev/null | wc -l)
security_updates=$(apt list --upgradable 2>/dev/null | grep -i security | wc -l)
printf "${CY}# Updates Available: ${WT}$updates     |    ${CY}# Security Updates Available: ${RED}$security_updates"

	lsb_dist=""
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
echo "$lsb_dist"

printf "\\n\\n    ${CY}Press ${WT}any ${CY}key to return to the Main Easy Linux menu."
  read -r -n1 -s -t 90
bash install-master.sh
