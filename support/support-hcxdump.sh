#!/bin/bash
#
set -e
#
trap ${scripts_dir}/support/support-trap-wifi.sh EXIT
source ${scripts_dir}/.envrc
# Version: 0.0.2
#
# Set the path to the wordlist

clear
#

Test_func() {
clear
source ${scripts_dir}/support/support-Banner_func.sh
printf "${OG}             What test do you want to run?\\n"
printf "  \\n"
printf "   ${OG}1] ${CY}Injection Test - Test your network adapters packet injection abilities.\\n"
printf "   ${OG}2] ${CY}Driver Test - Runs several tests to determine if the driver supports all IOCTL calls. \\n"
printf "   \\n"
printf "   ${OG}99] ${CY}Return to the main menu.                       ${RED} [✘] Exit tool [✘]\"${CY}\" \\n "
source ${scripts_dir}/support/support-Prompt_func.sh
read -r -p "Which test?" test
if [[ ${test} = 1 ]]; then
    clear
    source ${scripts_dir}/support/support-Banner_func.sh
    sudo systemctl stop NetworkManager
    sudo systemctl stop wpa_supplicant
    sudo hcxdumptool --check_injection -i "${adapter}"
elif [[ ${test} = 2 ]]; then
    clear
    source ${scripts_dir}/support/support-Banner_func.sh
    sudo systemctl stop NetworkManager
    sudo systemctl stop wpa_supplicant
    sudo hcxdumptool --check_driver -i "${adapter}"
elif [[ ${test} = 99 ]]; then
   clear
   bash ${scripts_dir}/menu-master.sh
elif [[ ${test} = "x" ]] || [[ ${test} = "X" ]]; then  
    clear
    printf "    ${RED}0. [✘] Exit tool [✘]${NC} \\n      "
    exit
else
    printf "${RED}  Invalid Selection${NC}\\n"
fi
}
 netadaptercount_func() {
 adapter_count=$(sudo airmon-ng | awk '  /phy/ {print $2 " - " $4 " " $5}' | grep -c "phy")
#
source ${scripts_dir}/support/support-Banner_func.sh
if [ "${adapter_count}" -eq 1 ]; then
    adapter=$(sudo airmon-ng | awk '  /phy/ {print $2 " - " $4, " " $5}')
else
    # If there are multiple wireless interfaces, prompt the user to select one
    printf "   \\n" 
    printf "${OG}    Multiple wireless interfaces available.${WT} \\n" 
    printf "${CY}    Please select one: \\n${OG}"
    sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' 2> /dev/null | grep "wl" | nl -nln
    printf "   \\n  ${WT}" 
source ${scripts_dir}/support/support-Prompt_func.sh
    read -r -p "  Enter the number of the interface you want to use in monitor mode: " selection
    adapter=$(sudo airmon-ng | awk '  /wl/ {print $2 " - " $4 " " $5}' | cut -d' ' -f1 | sed -n "${selection}p")
fi
}
#
printf "${OG}   \\n"
source ${scripts_dir}/support/support-Banner_func.sh
#
#  These 2 commands are repeated twice!!!
printf "  Starting...Please wait...${WT} \\n " 
printf " \\n "
sudo systemctl restart NetworkManager
sudo systemctl restart wpa_supplicant
printf "   \\n"
printf "  Continuing in${WT}"
sleep 1
printf " 3..${YW}"; sleep 1; printf " 2..${GN}"
sleep 1
printf " 1..${CY}  \\n    "
sleep 1
printf "Stopping problem processes. Please wait...  \\n "; sleep 1; printf "  \\n" 
sleep 1; printf "  Continuing in ${WT}3..${YW}"; sleep 1; printf " 2..${GN}"
sleep 1; printf " 1..${CY}"; sleep 1
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
#  These 2 commands are repeated twice!!!
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
clear
    printf " \\n ${WT}"
netadapterchoice_func

printf " \\n ${WT}  "
printf "  Press S to continue scan...Please ${RED}do not interupt for 30 sec ${OG}scan...${WT}\\n" 
printf " \\n"
printf "     Scan will stop automatically when complete...\\n${WT}   " 
printf " \\n   "
printf "  Press ${CY}(T)est to test adapters or ${WT}(S)can to scan AP's.${WT} \\n      "
source ${scripts_dir}/support/support-Prompt_func.sh
read -r -p "Test or Scan" torscan

  if [[ "${torscan}" = "T" ]] || [[ "${torscan}" = "t" ]]; then
  Test_func
  elif [[ "${torscan}" = "S" ]] || [[ "${torscan}" = "s" ]]; then
    printf "   \\n" 
    printf " \\n "
    timeout -v 35s sudo hcxdumptool -i "${adapter}" --do_rcascan --enable-status --disable_client_attacks
  else
    printf "${RED}  Invalid Selection   ${NC}\\n"
  fi
#The --filterlist and --filtermode options are used to apply a whitelist filter to only capture traffic from the desired access point. The --disable_client_attacks option is used to avoid sending deauthentication packets to connected clients.
#sudo hcxdumptool -i ${adapter} -o /opt/backup/root/handshakes/hcxdumptool.pcapng -f 0 -f 1 -f 2 -f 4 -f 32 -f 64 --enable_status=1

#hcxdumptool -o hashes.16800 -i wlan0 --enable_status=1 --filterlist=whitelist.txt --filtermode=2 --disable_client_attacks
#hcxdumptool -o /opt/backup/root/handshakes/hashes.22000 -i ${adapter} --enable_status=1 --filterlist=whitelist.txt --filtermode=2 --disable_client_attacks

# Prompt the user to choose between John the Ripper and Hashcat
printf "Choose a tool for cracking the hash:"
printf "${OG}1] ${CY}John the Ripper"
printf "${OG}2] ${CY}Hashcat"
read -r ripperchoice

	# Capture the hashes with hcxdumptool
sudo hcxdumptool -i "${adapter}" --do_rcascan --enable_status=5 -tot=40 --filterlist=whitelist.txt --filtermode=2 --disable_client_attacks

sudo /usr/bin/hcxpcapngtool -o /opt/backup/root/handshakes/DanielsFam.pcapng /home/beesoc/security/handshakes/DanielsFamily_e8d2ffcaf196.pcap

if [[ ${ripperchoice} -eq 1 ]]; then
  # Crack the hash with John the Ripper using the OneRuleToRuleThemAll.rule
  john --wordlist=${WORDLIST} --rules="${RULES}" --stdout | aircrack-ng -w - -e SSID /opt/backup/root/handshakes/hashes.22000 -J /opt/backup/root/handshakes/cracked.txt
elif [[ "${ripperchoice}" -eq 2 ]]; then
  # Crack the hash with hashcat
#  hashcat -m 22000 -a 1 -w 4 -o /opt/backup/root/handshakes/cracked.txt --force --opencl-device-types=1,2 ${WORDLIST} ?d?d?d?d?d?d?d?d?d --increment-min=8 --rule-file=OneRuleToRuleThemAll.rule /opt/backup/root/handshakes/hashes.22000
hashcat -m 22000 -a 3 -w 4 -o /opt/backup/root/handshakes/cracked.txt --force --opencl-device-types=1,2 ${WORDLIST} /opt/backup/root/handshakes/hashes.22000 --increment --increment-min=8 --increment-max=13

else
  # Invalid choice
  printf "${RED}  Invalid choice. Exiting..."
  exit 1
fi

#First, capture the hashes with hcxdumptool and save them to a file
#hcxdumptool -o /opt/backup/root/handshakes/hashes.pcapng -i ${adapter} --enable_status=1

# Convert the pcapng file to a format that hashcat or john the ripper can use
#sudo /usr/bin/hcxpcapngtool -E essidlist -I identitylist -U usernamelist -z hashfile hashes.pcapng

# Now you can use hashcat or john the ripper to crack the captured hashes
# The example below shows how to use hashcat with a wordlist attack
#hashcat -m 22000 -a 0 -o cracked.txt --force --opencl-device-types=1,2 --remove --rule-file=OneRuleToRuleThemAll.rule --pw-min=8 --pw-max=13 hashfile ${WORDLIST}
#hashcat -m 22000 -a 1 -w 4 -o /opt/backup/root/handshakes/cracked.txt --force --opencl-device-types=1,2 $WORDLIST ?d?d?d?d?d?d?d?d?d --increment-min=8 /opt/backup/root/handshakes/hashes.22000

# Clean up the hash file
rm /opt/backup/root/handshakes/hashes.22000

sleep 1
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
