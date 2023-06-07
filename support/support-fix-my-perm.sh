#!/bin/bash
# fix permissions issues
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

#################################################  Begin User Options  #########

###################################################  End User Options  #########
clear
source ${scripts_dir}/support/support-Banner_func.sh
printf "\\n "
# Get the username associated with UID 1000
trap "${scripts_dir}/support/trap-master.sh" EXIT

perms_func() {
	if [ -d /home/pi ]; then
		sudo chown -vR pi:pi /home/pi/
	fi

	if [ -d /opt/backup ]; then
		sudo chown -vR $userid:0 /opt/backup/
	fi

	sudo chown -vR $chosen_user:$chosen_user /home/$chosen_user

	if [ -d /opt/easy-linux ]; then
		sudo chown -vR $chosen_user:$0 /opt/easy-linux
	fi

}

user_sel_func() {
# find out how many users are on the system
num_users=$(getent passwd | grep "/home/" -c)  

# Get a list of all users on the system
user_list=$(cut -d: -f1 /etc/passwd)

printf "${OG}  It looks like you are ${WT}$USER."
	read -p "Is that your correct Linux login account? [Y/n] " userdec
	userdec=${userdec:-Y}
    if [[ "$userdec" =~ ^[yY]$ ]]; then
           printf "User $USER confirmed"
           chosen_user=$USER
           perms_func
    elif [[ "$userdec" =~ ^[nN]$ ]]; then
# Present the list of users to the user
printf "${OG}List of users:\\n"
printf "${CY}$user_list\\n"
echo
     else
        printf "${RED}Invalid Selection. Choose Y or N."
    fi
# Prompt the user to choose a user
read -p "Enter the username of the user you want to use: " chosen_user

# Validate the chosen user
		if [ grep -q "^${chosen_user}:" /etc/passwd ]; then
   			 printf "${GN}You selected user: ${WT}$chosen_user\\n"
		else
			    printf "${RED}FATAL error. Invalid username: $chosen_user\\n"
		fi

		read -n 1 -p "Is the above username correct? [Y/n] " userid
userid=${userid:-Y}
		if [[ ${userid} =~ ^[Nn]$ ]]; then
			printf "\\n ${RED}  FATAL ERROR: Exiting.\\n"
		exit 1
		elif [[ ${userid} =~ ^[Yy]$ ]]; then
			printf "User $chosen_user confirmed."
			perms_func
	      else
	           printf "${RED}Invalid Selection. Choose Y or N."
	      fi

}

main() { 

user_sel_func

}

main

