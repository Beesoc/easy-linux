#!/bin/bash
set -e
# shellcheck source=.envrc
clear
cd ..
source ./.envrc
# shellcheck source="support/Banner_func.sh"
source "support/Banner_func.sh"
# Display hostname and username
printf "\\n${CY}System information for computer, ${WT}$(hostname) ${CY} on Date: ${WT} $(timedatectl | grep "Local time" | awk '{print $3", " $4}')"
#mytime=$(timedatectl | grep "Local time" | awk '{print $3", " $4}') 

printf "\\n${CY}Username: ${GN}$(whoami)""${WT}@""${GN}$(hostname)${NC}        ${CY}TZ: ${WT}$(timedatectl | grep "Time zone:" | awk '{print $3}')     ${CY}Time: ${WT}$(date +%I:%M:%S\ %p)\\n\\n"

# Display CPU temperature in Fahrenheit
#echo "CPU Temperature: ${cpu_temp_f}°F"
cpu_temp=$(sensors | awk '/^Package/{printf\("%.0f°F\n", $4*1.8+32)}') 
printf "   CPU Temp: ${WT}${cpu_temp}\\n"
# Display CPU load
cpu_load=$(uptime | awk '{print $10,$11,$12}')
printf "CPU Load: $cpu_load\\n"

# Display Battery info
acpi -b | awk '/Battery 0/ {print $3" -" $4 " Time remaining:"$5}'


# Display IP address
ip_address=$(hostname -I | awk '{print $1}')
echo "IP Address: $ip_address"

# Display disk usage
disk_usage=$(df -h | awk '{if($NF=="/") print $5}')
echo "Disk Usage: $disk_usage"

# Display total number of updates and security updates available
updates=$(apt list --upgradable 2>/dev/null | wc -l)
security_updates=$(apt list --upgradable 2>/dev/null | grep -i security | wc -l)
echo "Total Number of Updates Available: $updates"
echo "Total Number of Security Updates Available: $security_updates"
