#!/bin/sh
# Version: 0.0.2
# Restart all Pwnagotchi services
set -e 
scripts_dir=/opt/easy-linux

source ${scripts_dir}/support/support-Banner_func.sh
sudo touch /root/.pwnagotchi-auto && sudo systemctl restart pwnagotchi && \
sudo systemctl restart bettercap.service 
sudo systemctl restart pwngrid.service
sudo systemctl restart pwnagotchi.service && pwnlog
# tail -f /var/log/pwnagotchi.log
