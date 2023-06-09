#!/bin/bash
# determine various user/pc characteristics
set -e

# Version: 0.0.3

# Paths
flag_file=/opt/easy-linux/.envrc_populated
envrc_file=/opt/easy-linux/.envrc

# Capture user's username and computer name
computername=$(cat /etc/hostname)
user=$USER

# Update pwnagotchi value
pwnagotchi="Unknown"

# Function to update pwnagotchi value in .envrc
update_pwnagotchi() {
    local value=$1
    sed -i "s/^pwnagotchi=.*/pwnagotchi=${value}/" "$envrc_file"
}

if [[ $pwnagotchi != "Gotcha" && $pwnagotchi != "Sniffer" ]]; then
    pwnagotchi="Unknown"
    if [[ "$user" == "$cwb_username" && "$(cat /etc/hostname)" == "$cwb_computername" ]]; then
        pwnagotchi="Gotcha"
        update_pwnagotchi "Gotcha"
    elif [[ "$user" == "$ldb_username" && "$(cat /etc/hostname)" == "$ldb_computername" ]]; then
        pwnagotchi="Sniffer"
        update_pwnagotchi "Sniffer"
    else
        update_pwnagotchi "Unknown"
    fi
fi

# Function to populate .envrc file if not already populated
populate_envrc() {
    if [ ! -e "$flag_file" ]; then
        # Add more environment variables as needed
        echo "export docker_installed=0" | sudo tee -a "$envrc_file"
        echo "export fatrat_installed=$(if command -v fatrat >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export hacktool_installed=$(if command -v hackingtool >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export glances_install=$(if command -v glances >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export hcxdump_installed=$(if command -v hcxdumptool >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export menu_apps_deps=0" | sudo tee -a "$envrc_file"
        echo "export nano_installed=0" | sudo tee -a "$envrc_file"
        echo "export ncdu_installed=$(if command -v ncdu >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"        
        echo "export webmin_installed=$(if command -v webmin >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export wifite_installed=$(if command -v wifite >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export stand_install=0" | sudo tee -a "$envrc_file"
        echo "export airc_installed=$(if command -v aircrack-ng >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export airc_deps_installed=$(if command -v aircrack-ng >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export airg_deps_inst=$(if command -v airgeddon >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export airg_installed=$(if command -v airgeddon >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file"
        echo "export autoj_install=$(if command -v autojump >/dev/null 2>&1; then echo 1; else echo 0; fi)" | sudo tee -a "$envrc_file" 
        echo "export pid=$(id -u)" | sudo tee -a "$envrc_file"    
        echo "export gid=$(id -g)" | sudo tee -a "$envrc_file"    
        echo "export appd_dir=/opt/appdata" | sudo tee -a "$envrc_file"    
        echo "export defnet=lsio" | sudo tee -a "$envrc_file"    
        echo "export dockeronce=" | sudo tee -a "$envrc_file"
        echo "export username=$(id | awk -F'[=()]' '{print $3}')"  | sudo tee -a "$envrc_file"
        echo "export userid=$(id | awk -F'[=()]' '{print $2}')"  | sudo tee -a "$envrc_file"
        echo "export computername=$(cat /etc/hostname)" | sudo tee -a "$envrc_file"
        echo "export hostname=$(cat /etc/hostname)" | sudo tee -a "$envrc_file"
        echo "export arch=$(uname -m)" | sudo tee -a "$envrc_file"
        echo "export wordlist=/usr/share/wordlists/Top304Thousand-probable-v2.txt" | sudo tee -a "$envrc_file"
        echo "export amiPwn=$(if [ -f '/etc/pwnagotchi/config.toml' ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "$envrc_file"
        echo "export pwnagotchi=$(if [[ "$USER" == "$cwb_username" && "$(cat /etc/hostname)" == "$cwb_computername" ]]; then echo "Gotcha"; fi)" | sudo tee -a "$envrc_file"
        echo "export pwn_installed=" | sudo tee -a "$envrc_file"
        echo "export OS=$(uname -s)" | sudo tee -a "$envrc_file"
            if [[ -z $DESKTOP_SESSION || $DESKTOP_SESSION == "ubuntu-on-wayland" || $DESKTOP_SESSION == "ubuntu" || $DESKTOP_SESSION == "lxqt" || $DESKTOP_SESSION == "lxde" || $DESKTOP_SESSION == "openbox" ]]; then
              echo "Running in a minimized Linux environment."
            else
              echo "export all_users=\"$(getent passwd | grep /home | cut -d ':' -f 1)\"" | sudo tee -a "$envrc_file"
              echo "export all_user_ct=\"$(getent passwd | grep /home -c)\"" | sudo tee -a "$envrc_file"
            echo "export user=$USER" | sudo tee -a "$envrc_file"
              echo "export useraccount=$(getent passwd $USER | cut -d ':' -f 1)" | sudo tee -a "$envrc_file"
            fi
        # Update flag to indicate the function has run
        touch "$flag_file"
    fi
}

#pkg_info_func() {
#    sudo dpkg --get-selections > "$installed_apps_file"
#}

main() {
    populate_envrc
}

if [[ $pwnagotchi != "Gotcha" && $pwnagotchi != "Sniffer" ]]; then
    pwnagotchi="Unknown"
    if [[ "$user" == "$cwb_username" && "$computername" == "$cwb_computername" ]]; then
        pwnagotchi="Gotcha"
        update_pwnagotchi "Gotcha"
    elif [[ "$user" == "$ldb_username" && "$computername" == "$ldb_computername" ]]; then
        pwnagotchi="Sniffer"
        update_pwnagotchi "Sniffer"
    fi
    update_pwnagotchi "Unknown"
fi

if [ -x "$(command -v direnv)" ]; then
   cd /opt/easy-linux
   direnv allow && sudo direnv allow

   cd /opt/easy-linux/support
   direnv allow && sudo direnv allow
fi

main
