#!/bin/bash
# determine various user/pc characteristics
set -e

# Version: 0.0.3

# Paths
scripts_dir="/opt/easy-linux"
envrc_file="${scripts_dir}/.envrc"

flag_file="${scripts_dir}/.envrc_populated"

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
    if [[ "$user" == "\\$cwb_username" && "$(cat /etc/hostname)" == "\\$cwb_computername" ]]; then
        pwnagotchi="Gotcha"
        update_pwnagotchi "Gotcha"
    elif [[ "$user" == "\\$ldb_username" && "$(cat /etc/hostname)" == "\\$ldb_computername" ]]; then
        pwnagotchi="Sniffer"
        update_pwnagotchi "Sniffer"
    fi
    update_pwnagotchi "Unknown"
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
        echo "export all_users="$(getent passwd | grep "/home" | cut -d ':' -f 1)"" | sudo tee -a "$envrc_file"
        echo "export all_user_ct=$(getent passwd | grep "/home" -c)" | sudo tee -a "$envrc_file"       
        echo "export user=$USER" | sudo tee -a "$envrc_file"
        echo "export username=$(id | awk -F'[=()]' '{print $3}')"  | sudo tee -a "$envrc_file"
        echo "export userid=$(id | awk -F'[=()]' '{print $2}')"  | sudo tee -a "$envrc_file"
        echo "export useraccount=$(getent passwd 1000 | cut -d ':' -f 1)" | sudo tee -a "$envrc_file"
        echo "export computername=$(cat /etc/hostname)" | sudo tee -a "$envrc_file"
        echo "export hostname=$(cat /etc/hostname)" | sudo tee -a "$envrc_file"
        echo "export arch=$(uname -m)" | sudo tee -a "$envrc_file"
        echo "export wordlist=/usr/share/wordlists/Top304Thousand-probable-v2.txt" | sudo tee -a "$envrc_file"
        echo "export amiPwn=$(if [ -f '/etc/pwnagotchi/config.toml' ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "$envrc_file"
        echo "export pwnagotchi=$(if [[ "$USER" == "$cwb_username" && "$(cat /etc/hostname)" == "$cwb_computername" ]]; then echo "Gotcha"; else echo "Unknown"; fi)" | sudo tee -a "$envrc_file"
        echo "export pwn_installed=" | sudo tee -a "$envrc_file"
        echo "export OS=$(uname -s)" | sudo tee -a "$envrc_file"

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
   cd "$scripts_dir"
   direnv allow && sudo direnv allow

   cd "$scripts_dir/support"
   direnv allow && sudo direnv allow
fi

main
