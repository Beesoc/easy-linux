#!/bin/sh
# Version 0.0.2
clear
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
source ${scripts_dir}/support/support-Banner_func.sh

pringf "${OG}Restarting ${WT}all Pwnagotchi services${OG}, then ${WT}tailing ${OG}the logs."
sudo touch /root/.pwnagotchi-auto && sudo systemctl restart pwnagotchi && \
sudo systemctl restart bettercap.service && sudo systemctl restart pwnagotchi.service && \

if [[ $(command -v pwnlog>/dev/null ) ]]; then
	sudo pwnlog
 elif [[ ! $(command -v pwnlog>/dev/null ) ]]; then
    tail -f /var/log/pwnagotchi.log
 fi
