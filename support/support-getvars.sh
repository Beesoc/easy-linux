#!/bin/bash
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
source .envrc
clear
source ${scripts_dir}/support/support-Banner_func.sh
#################################################  Begin User Options  #########

###################################################  End User Options  #########

reg-user_func() {
	# Get the username associated with UID 1000
	reg_user=$(getent passwd 1000 | cut -d ':' -f 1)

	# Print the username
	printf "\\n${CY}The user with ${WT}UID 1000 ${CY}is: \\n"
	printf "${GN}  Username: ${WT}$reg_user \\n"

	if [[ $reg_user = $USER && $USER = $username ]]; then
		printf "${CY}  Usernames ${WT}${USER}${CY}, ${WT}${username}${CY}, and ${WT}${reg_user} ${CY}all match.\\n  "
	elif [[ $reg_user != $USER || $USER != $username || $reg_user != $username ]]; then
		printf "${RED}  Usernames ${WT}${USER}${RED}, ${WT}${username}${RED}, and ${WT}${reg_user} ${RED}don't match.\\n\\n  "
		printf "${RED}  Username mismatch! Press ${WT}any ${RED}"
		read -n 1 -p "key to continue."
	fi

	printf "\\n${CY}  Press ${WT}any ${CY}"
	read -n 1 -p "key to continue."
}

main() {
	reg-user_func
}
main
source ${scripts_dir}/menu-master.sh
exit 0
