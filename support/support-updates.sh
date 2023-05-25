#!/bin/bash
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.3
source "${scripts_dir}/.envrc"
clear
source "${scripts_dir}/support/support-Banner_func.sh"
if [[ $USER != "beesoc" ]] || [[ $HOST != "updates" ]]; then
	exit 0
elif [[ $USER = "beesoc" ]] && [[ $HOST = "updates" ]]; then
	#####  Personal  #######
	printf "${CY}  Install Storm-Breaker"
	sudo apt install -y python3-requests python3-colorama python3-psutil >/dev/null
	cd /opt || exit
	sudo git clone https://github.com/ultrasecurity/Storm-Breaker.git
	cd Storm-Breaker || exit
	sudo bash ./install.sh
	cd storm-web
	sudo su
	rm config.php
	touch ./config.php
	echo "<?php

\$CONFIG = array (
    \"hidden\" => [
        \"fullname\" => \"$StormBreakerUser\",
        \"password\" => \"$StormBreakerPass\",
    ],

);

?>" >config.php

	printf "Install ngrok"
	cd $HOME/Downloads
	wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
	sudo tar xvzf $HOME/Downloads/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
	printf "Go signup for an ngrok account.  That's how you get the key below"
	ngrok config add-authtoken $ngrok_token

fi

printf "${CY}  All apps in this script have been successfully installed. This includes all apps listed here: ${PL}\\n"
printf "$packages\\n"
printf "${OG}  Press ${WT}any ${OG}key to continue."
read -n 1 -s -t 300
source ${scripts_dir}/install/menu-apps.sh
