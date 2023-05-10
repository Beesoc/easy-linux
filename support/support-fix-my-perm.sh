#!/bin/bash
set -e
# Version: 0.0.2
source .envrc

#################################################  Begin User Options  #########

###################################################  End User Options  #########

source support-Banner_func.sh
printf "\\n "
# Get the username associated with UID 1000
reg_user=$(getent passwd 1000 | cut -d ':' -f 1)

# Print the username
printf "The user with UID 1000 is: \\n"
printf "${GN}  Username: ${WT}$reg_user \\n    "

read -n 1 -p "Is the above username correct? [Y/n] " userid
  userid=${userid:-Y}
  if [[ ${userid} =~ ^[Nn]$ ]]; then
       printf "\\n ${RED}  FATAL ERROR: Exiting."
       exit 1
  elif [[ ${userid} =~ ^[Yy]$ ]]; then

        if [ -d /home/pi ]; then
           sudo chown -vR pi:pi /home/pi/
        fi

        if [ -d /opt/backup ]; then
           sudo chown -vR $reg_user:$reg_user /opt/backup/
        fi
        
        sudo chown -vR $reg_user:$reg_user /home/$reg_user

        if [ -d /opt/easy-linux ]; then
           sudo chown -vR $reg_user:$reg_user /opt/easy-linux
        fi
  else
     printf "${RED}  Invalid selection"
  fi

source ${scripts_dir}/menu-master.sh
