#!/bin/bash

# Pwnagotchi backup and restore script

#set -euo pipefail
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
backup_dir=/opt/backup
trap ${scripts_dir}/support/trap-master.sh EXIT
# Load environment variables
source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/.whoami.sh"
if [[ -f /etc/pwnagotchi/config.toml ]]; then
	amiPwn=1
	sudo sed -r -i 's/amiPwn=.*/amiPwn=amiPwn=1/g' "${scripts_dir}/.envrc"
elif [[ ! -f /etc/pwnagotchi/config.toml ]]; then
	amiPwn=0
	sudo sed -r -i 's/amiPwn=.*/amiPwn=amiPwn=0/g' "${scripts_dir}/.envrc"
fi

# Function to handle Pwnagotchi connection
pwn_connect_func() {
	pwn_installed=0
	printf "\\n${CY}Would you like to connect to ${WT}${pwnagotchi}${CY}"
	read -r -p "? [Y/n] " connect_pwn
	echo
	connect_pwn=${connect_pwn:-Y}
	if [[ "$connect_pwn" =~ ^[Yy]$ ]]; then
		ssh -p 22 pi@10.0.0.2
		source "${scripts_dir}/menu-master.sh"
		pwn_installed=1
		sudo sed -i 's/pwn_installed=.*/pwn_installed=1/g' "${scripts_dir}/.envrc"
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
		sudo 'echo "ACTION==\"add\", SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0525\", ATTR{idProduct}==\"a4a2\", RUN+=\"/opt/easy-linux/menu-master.sh"' >> ${scripts_dir}/support/misc/20-easy-udev.rules
        sudo cp ${scripts_dir}/support/misc/20-easy-udev.rules /etc/udev/rules.d/
		sudo udevadm control --reload-rules
		sudo udevadm trigger
		sudo systemctl reload udev
	else
		printf "${WT}It looks like the udev rule is already in place. Skipping this step.${CY}\n"
	fi
	pwn_connect_func
}

whoami_func() {
	cwb_username=$cwb_username
	cwb_computername=$cwb_computername
	ldb_username=$ldb_username
	ldb_computername=$ldb_computername
	if [[ $USER == $cwb_username && $computername == $cwb_computername ]]; then
		pwnagotchi=Gotcha
	fi
	if [[ $USER == $ldb_username && $computername == $ldb_computername ]]; then
		pwnagotchi=Sniffer
	fi
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	echo
	printf "  ${CY}Your Pwnagotchi is ${WT}$pwnagotchi.\\n"

	if [[ $pwnagotchi != "Gotcha" || $pwnagotchi != "Sniffer" ]]; then
		printf "${OG}Pwnagotchi name couldn't be automagically obtained.${GN}\n  "
	fi

	read -n 1 -r -p "Would you like to overide and supply your own name? [y/N] " overide
	overide=${overide:-N}
	echo
	if [[ "$overide" =~ ^[nN]$ ]]; then
		printf "  ${WT}$USER ${OG}selected to not override Pwnagotchi's name. Continuing.\n"
	elif [[ "$overide" =~ ^[yY]$ ]]; then
		printf "  ${CY}Override confirmed. This script will not setup new Pwnagotchi's ${WT}yet${CY}.\n"
		printf "\\n  ${GN}Enter name of Pwnagotchi that has ${WT}already been backed up ${GN}using this script.${CY}\\n\\n    "
		read -r -p "What is your Pwnagotchi's name? ----> " pwnagotchi
		sudo sed -i "s/pwnagotchi=.*/pwnagotchi=$pwnagotchi/g" "${scripts_dir}/.envrc"
		printf " ${GN} Username: ${WT}$USER    ${GN}Hostname: ${WT}$computername     ${GN}Pwnagotchi: ${WT}${pwnagotchi} \\n"
		printf "Continuing with these settings:${OG}\n"
		sleep 3
	fi
}

upload_func() {
	source ${scripts_dir}/menu-upload-hashes.sh
}

main_menu_func() {
source ${scripts_dir}/menu-master.sh
}

# Function to control SSH options
ssh_func() {
	# Check for SSH key and generate if not found
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
    if [[ -f $HOME/.ssh/known_hosts ]]; then
	ssh-keygen -f "$HOME/.ssh/known_hosts" -R "10.0.0.2"
    fi
	if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
		printf "${CY}SSH key was found. Proceeding.${CY}\\n"
	else
		printf "${CY}No personal SSH key was found. Checking for key for root user.${CY}\\n"
		if [ ! -f /root/.ssh/id_rsa.pub ]; then
			printf "${CY}SSH key was not found. Press any key to generate keys.${CY}\\n"
			read -r -n 1 -s -t 300
			printf "If there was a .ssh folder in your HOME directory, it has been backed up to .ssh2.${CY}\\n"
		fi
        if [[ -d $HOME/.ssh ]]; then
		  sudo cp -fr "$HOME/.ssh" .ssh2
        fi
        if [[ ! -d $HOME/.ssh ]]; then
          mkdir $HOME/.ssh
        fi
       	ssh-keygen
		sudo ssh-keygen
	fi

	printf "${CY}  Now I will copy the SSH key to ${WT}$pwnagotchi${CY}. If this Pwnagotchi is new, the password is ${WT}[raspberry]${CY}.${CY}\\n"
	printf "${GN}  You may be prompted to accept the fingerprint next and will be asked for ${WT}${pwnagotchi}${GN} password.${OG}\\n"
	printf "  ${CY}Press ${WT}any ${CY}key to continue\\n${NC}"
	read -n 1 -r -t 300
    if [[ -f $HOME/.ssh/known_hosts ]]; then
	   ssh-keygen -f $HOME/.ssh/known_hosts -R "10.0.0.2"
    fi
    if [[ -f /root/.ssh/known_hosts ]]; then 
       sudo ssh-keygen -f /root/.ssh/known_hosts -R "10.0.0.2"
    fi
    if [[ -f $HOME/.ssh/id_rsa.pub ]]; then
    	ssh-copy-id -p 22 -i $HOME/.ssh/id_rsa.pub pi@10.0.0.2
    if [[ -f /root/.ssh/id_rsa.pub ]]; then
    	sudo ssh-copy-id -p 22 -i /root/.ssh/id_rsa.pub pi@10.0.0.2
    fi
	pwn_installed=1
	sudo sed -r -i "s/pwn_installed=.*/pwn_installed=1/g" "${scripts_dir}/.envrc"
	read -r -p "Do you want to [c]onnect to $pwnagotchi now, or [r]eturn to the menu? [C/r] " conreturn
	conreturn=${conreturn:-C}
	printf "\\n ${OG}"
	ssh -p 22 pi@10.0.0.2 "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
	ssh -p 22 pi@10.0.0.2 "echo \"$(cat ~/.ssh/id_rsa.pub)\" >> ~/.ssh/authorized_keys"

	# Test SSH connection to Pwnagotchi
	ssh -p 22 pi@10.0.0.2 "echo 'Connection successful. SSH is properly configured.'"
	printf "${GN}If you see 'Connection successful. SSH is properly configured.', then SSH is working properly.${CY}\\n"
	printf "${GN}If you do not see this message, you may need to troubleshoot your SSH connection.${CY}\\n"
	sleep 5

	if [[ "$conreturn" =~ ^[cC]$ ]]; then
		ssh -p 22 pi@10.0.0.2
	elif [[ "$conreturn" =~ ^[rR]$ ]]; then
		return
	fi
	if [[ -f /etc/udev/rules.d/20-easy-udev.rules ]]; then
	    	printf "\\n ${OG}  Udev rule already present. Skipping.\\n${CY}"
	elif [[ ! -f /etc/udev/rules.d/20-easy-udev.rules ]]; then
	udev_func
	fi
	pwn_connect_func
fi
}

main_menu() {
	clear
	pwn_installed=$(echo ${scripts_dir}/.envrc | grep "pwn_installed" | awk '{print $2}')
	sshmenu=0
	if [[ $pwn_installed = 1 ]]; then
		sshmenu=$(echo "    ${WT}1)${OG}  SSH key setup: This step has been COMPLETED.${CY}\n")
	elif [[ $pwn_installed = 0 ]]; then
		sshmenu=$(echo "    ${WT}1)${CY}  SSH key setup: Complete first. Only required 1 time.${CY}\n")
	fi

	source ${scripts_dir}/support/support-Banner_func.sh
	echo
	printf "${OG}          $USER               Pwnagotchi Hub                 $pwnagotchi ${CY}\n"
	echo
	printf "    ${GN}Select an option:${CY}\n"
	echo
	printf "$sshmenu"
	printf "    ${WT}2)${CY}  Connect to Pwnagotchi${CY}\n"
	printf "    ${WT}3)${CY}  Customize your Pwnagotchi${CY}\n"
	printf "    ${WT}4)${CY}  Backup Pwnagotchi${CY}\n"
	printf "    ${WT}5)${CY}  Restore Pwnagotchi${CY}\n"
	printf "    ${WT}6)${CY}  Upload Hashes and Handshakes to cracking sites${CY}\n"
	printf "    ${WT}7)${CY}  Return to Main Menu${CY}\n"
	printf "    ${WT}8)${CY}  Quit${CY}\n"
	echo
	printf "    ${GN}Selection: ${CY}\n"
	read -n 1 -r main_menu_sel
	case "$main_menu_sel" in
	1) ssh_func ;;
	2) pwn_connect_func ;;
	3) cust_func ;;
	4) backup_func ;;
	5) restore_func ;;
	6) upload_func ;;
	7) main_menu_func ;;
	8) exit 0 ;;
	*) printf "${RED}Invalid selection.${CY}\n" ;;
	esac
}

# Function to perform backup
backup_func() {
	clear
	if [[ ! -d "${backup_dir}" ]]; then
		sudo mkdir "${backup_dir}"
		sudo chown -vR $USER:0 ${backup_dir}
	fi

	if [[ ! -d "${backup_dir}/${pwnagotchi}" ]]; then
		sudo mkdir "${backup_dir}/${pwnagotchi}"
		sudo chown -vR $USER:0 ${backup_dir}/${pwnagotchi}
	fi

	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${WT}Your attached Pwnagotchi will be backed up to \\n ${backup_dir}/$pwnagotchi${CY}\n"
	rsync -avzh --relative --super --progress --human-readable --no-o --no-g --files-from="${scripts_dir}/support/misc/backup-list.list" --rsync-path="sudo rsync" pi@10.0.0.2:/ "${backup_dir}/${pwnagotchi}"

	sudo chown -vR $USER:0 ${backup_dir}/$pwnagotchi
	printf "${GN}Backup completed successfully.${CY}\n"
}

# Function to perform restore
restore_func() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "${WT}Your attached Pwnagotchi will be restored from \\n ${backup_dir}/$pwnagotchi${CY}\n"
	if [[ ! -d ${backup_dir} ]]; then
		printf "  ${RED}ERROR: Backup folder ${WT}$backup_dir ${RED}does not exist or you do not have permissions to access it.\\n"
		printf "  You must make a backup before you can restore from one.\\n"
	fi
	if [[ ! -d ${backup_dir}/$pwnagotchi ]]; then
		printf "  ${RED}ERROR: Backup folder ${WT}$backup_dir/$pwnagotchi ${RED}does not exist or you do not have permissions to access it.\\n"
		printf "  You must make a backup before you can restore from one.\\n"
	fi
	sudo chown -vR $USER:0 ${backup_dir}/${pwnagotchi}
	rsync -avzh --relative --no-o --no-g --super --progress --human-readable --files-from="${scripts_dir}/support/misc/backup-list.list" --rsync-path="sudo rsync" "${backup_dir}/${pwnagotchi}" pi@10.0.0.2:/

	printf "${GN}Restore completed successfully.${CY}\n"

}

main() {
	# Main script logic
	whoami_func

	while true; do
		main_menu
		printf "${WT}Press any key to return to the main menu.${CY}\n"
		read -n 1 -r
	done
}

main
