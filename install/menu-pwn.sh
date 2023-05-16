#!/bin/bash
# Pwnagotchi backup and restore script

#set -euo pipefail

# Version: 0.0.3
scripts_dir=/opt/easy-linux

# Load environment variables
source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/.whoami.sh"

# Function to handle Pwnagotchi connection
pwn_connect_func() {
	printf "${CY}Would you like to connect to ${WT}${pwnagotchi}?${CY}\\n"
	read -r -p "? [Y/n] " connect_pwn
	connect_pwn=${connect_pwn:-Y}
	if [[ "$connect_pwn" =~ ^[Yy]$ ]]; then
		ssh -p 22 pi@10.0.0.2
		source "${scripts_dir}/menu-master.sh"
		pwn_installed=1
		sed -i 's/^pwn_installed=.*/$pwn_installed/' .envrc
	elif [[ "$connect_pwn" =~ ^[Nn]$ ]]; then
		printf "${WT}$USER ${RED}selected not to connect to ${WT}${pwnagotchi}. Exiting.${CY}\\n"
		exit 0
	else
		printf "${RED}Invalid selection.${CY}\\n"
	fi
}

# Function to set up udev rule
udev_func() {
	if [[ ! -f /etc/udev/rules.d/20-easy-udev.rules ]]; then
		sudo cp /opt/easy-linux/support/20-easy-udev.rules /etc/udev/rules.d/
		sudo udevadm control --reload-rules
		sudo udevadm trigger
	else
		printf "${WT}It looks like the udev rule is already in place. Skipping this step.${CY}\n"
	fi
	pwn_connect_func
}

# Function to control SSH options
ssh_func() {
	# Check for SSH key and generate if not found
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	ssh-keygen -f "$HOME/.ssh/known_hosts" -R "10.0.0.2"
	if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
		printf "${CY}SSH key was found. Proceeding.${CY}\\n"
	else
		printf "${CY}No personal SSH key was found. Checking for key for root user.${CY}\\n"
		if [ ! -f /root/.ssh/id_rsa.pub ]; then
			printf "${CY}SSH key was not found. Press any key to generate keys.${CY}\\n"
			read -r -n 1 -s -t 300
			printf "If there was a .ssh folder in your HOME directory, it has been backed up to .ssh2.${CY}\\n"
		fi
		sudo cp -fr "$HOME/.ssh" .ssh2
		ssh-keygen
		sudo ssh-keygen
	fi

	printf "${CY}  Now I will copy the SSH key to $pwnagotchi. If this Pwnagotchi is new, the password is ${WT}[raspberry]${CY}.${CY}\\n"
	printf "${GN}  You may be prompted to accept the fingerprint next and will be asked for ${WT}${pwnagotchi}${GN} password.${OG}\\n"
	printf "  ${CY}Press ${WT}any ${CY}key to continue"
	read -n 1 -r -t 300
    ssh-keygen -f "/root/.ssh/known_hosts" -R "10.0.0.2"  
	ssh-copy-id -p 22 -i ~/.ssh/id_rsa.pub pi@10.0.0.2
	sudo ssh-copy-id -p 22 -i /root/.ssh/id_rsa.pub pi@10.0.0.2
	ssh -p 22 pi@10.0.0.2
	pwn_installed=1
	sed -i 's/^pwn_installed=.*/$pwn_installed/' .envrc
	udev_func
	pwn_connect_func
}

cust_func() {
	printf "  ${CY}You've selected to Customize ${WT}$pwnagotchi!${BK}\n"
	printf "  ${OG}Unfortunately, none of the customizations are ready yet.${PL}\n"
	printf "  ${PL}Press ${WT}any ${PL}key to continue${BK}"
	read -n 1 -r
	# Return to Main Menu
}

whoami_func() {
    cwb_username=$cwb_username
    cwb_computername=$cwb_computername
    ldb_username=$ldb_username
    ldb_computername=$ldb_computername
	if [[ $username -eq $cwb_username && $computername -eq $cwb_computername ]]; then
		pwnagotchi=Gotcha
	fi
	if [[ $username -eq $ldb_username && $computername -eq $ldb_computername ]]; then
		pwnagotchi=Sniffer
    fi

  	printf "Your Pwnagotchi is $pwnagotchi.\\n"
    
    
    if [[ $pwnagotchi -ne "Gotcha" && $pwnagotchi -ne "Sniffer" ]]; then
	printf "${OG}Pwnagotchi name couldn't be automagically obtained.${GN}\n"
    fi
    
	read -n 1 -r -p "Would you like to overide and supply your own name? [Y/n] " overide
	overide=${overide:-Y}
	echo
	if [[ "$overide" =~ ^[nN]$ ]]; then
		printf "  ${WT}$USER ${RED}selected to not override Pwnagotchi's name. Exiting\n"
		exit 0
	elif [[ "$overide" =~ ^[yY]$ ]]; then
		printf "  ${CY}Override confirmed. This script will not setup new Pwnagotchi's ${WT}yet${CY}.\n"
		printf "\\n  ${Gn}Enter name of Pwnagotchi that has ${WT}already been backed up ${GN}using this script.${CY}\\n\\n   "
		read -r -p "What is your Pwnagotchi's name? ----> " pwnagotchi
		printf " ${GN} Username: ${WT}$USER    ${GN}Hostname: ${WT}$computername     ${GN}Pwnagotchi: ${WT}${pwnagotchi} \\n"
		printf "Continuing with these settings:${OG}\n"
		sleep 3
	fi
}

main_menu_func() {
	source ${scripts_dir}/menu-master.sh
}

# Function to handle menu selection
main_menu() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
    echo 
    printf " ${GN} Username: ${WT}$USER    ${GN}Hostname: ${WT}$computername     ${GN}Pwnagotchi: ${WT}${pwnagotchi} \\n"
	whoami_func
	printf "${OG}      $username               Pwnagotchi Hub             $pwnagotchi ${CY}\n"
	echo
	printf "${GN}Select an option:${CY}\n"
	echo
	printf "${WT}1)${CY} SSH key setup: Complete first. Only required 1 time.${CY}\n"
	printf "${WT}2)${CY} Connect to Pwnagotchi${CY}\n"
	printf "${WT}3)${CY} Customize your Pwnagotchi${CY}\n"
	printf "${WT}4)${CY} Backup Pwnagotchi${CY}\n"
	printf "${WT}5)${CY} Restore Pwnagotchi${CY}\n"
	printf "${WT}6)${CY} Return to Main Menu${CY}\n"
	printf "${WT}7)${CY} Quit${CY}\n"
	echo
	printf "${WT}Selection: ${CY}\n"
	read -n 1 -r main_menu_sel
	case "$main_menu_sel" in
	1) ssh_func ;;
	2) pwn_connect_func ;;
	3) cust_func ;;
	4) backup_func ;;
	5) restore_func ;;
	6) main_menu_func ;;
	7) exit 0 ;;
	*) printf "${RED}Invalid selection.${CY}\n" ;;
	esac
}

# Function to perform backup
backup_func() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${WT}Please provide a location to save the backup.${CY}\n"
	printf "${WT}Backup Location: ${CY}"
	read -r backup_location
	printf "${WT}Backing up Pwnagotchi to ${backup_location}...${CY}\n"
	sudo rsync -avh --progress /opt/pwnagotchi/ "$backup_location"
	printf "${GN}Backup completed successfully.${CY}\n"
}

# Function to perform restore
restore_func() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${WT}Please provide the location of the backup.${CY}\n"
	printf "${WT}Backup Location: ${CY}"
	read -r restore_location
	printf "${WT}Restoring Pwnagotchi from ${restore_location}...${CY}\n"
	sudo rsync -avh --progress "$restore_location" /opt/pwnagotchi/
	printf "${GN}Restore completed successfully.${CY}\n"
}

# Main script logic
while true; do
	main_menu
	printf "${WT}Press any key to return to the main menu.${CY}\n"
	read -n 1 -r
done
