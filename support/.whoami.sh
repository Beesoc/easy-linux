#!/bin/bash
# Version: 0.0.3
# Capture user's username and computer name
# shellcheck source .envrc
set -e
scripts_dir=/opt/easy-linux
cd ${scripts_dir}
direnv allow && sudo direnv allow
source ${scripts_dir}/.envrc

get_vars_func() {
computername=$(cat /etc/hostname)
OS=""
VER""
user=$USER
username=$USER
pwnagotchi="Unknown"

if [[ $pwnagotchi != "Gotcha" ]] && [[ $pwnagotchi != "Sniffer" ]]; then 
    pwnagotchi="Unknown"

    if [[ "$USER" == "$cwb_username" && "$HOST" == "$cwb_computername" ]]; then
        pwnagotchi="Gotcha"
        sed -i 's/^pwnagotchi=.*/pwnagotchi=Gotcha/' ${scripts_dir}/.envrc
    elif [[ "$USER" == "$ldb_username" && "$HOST" == "$ldb_computername" ]]; then
        pwnagotchi="Sniffer"
        sed -i 's/^pwnagotchi=.*/pwnagotchi=Sniffer/' ${scripts_dir}/.envrc
    fi
sed -i 's/^pwnagotchi=.*/pwnagotchi=Unknown/' ${scripts_dir}/.envrc
fi

FLAG_FILE=/opt/easy-linux/.envrc_populated

if [ ! -e "$FLAG_FILE" ]; then

  # Function to populate .envrc file
  function populate_envrc() {
#sudo chown 1000:0 /opt/easy-linux/.envrc
    # Add more environment variables as needed
#    echo "export MY_VAR=my_value" | /opt/easy-linux/.envrc
echo "export docker_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export fatrat_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export hacktool_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export hcxdump_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export nano_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export webmin_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export wifite_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export stand_install=0" | sudo tee -a ${scripts_dir}/.envrc 
echo "export airc_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export airc_deps_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export airg_deps_inst=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export airg_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export user=$USER" | sudo tee -a ${scripts_dir}/.envrc
echo "export username=$(whoami)" | sudo tee -a ${scripts_dir}/.envrc
echo "export useraccount=$(getent passwd 1000 | cut -d ":" -f 1)" | sudo tee -a ${scripts_dir}/.envrc
echo "export computername=$(cat /etc/hostname)" | sudo tee -a ${scripts_dir}/.envrc
echo "export hostname=$(cat /etc/hostname)" | sudo tee -a ${scripts_dir}/.envrc
echo "export computername=$(cat /etc/hostname)" | sudo tee -a ${scripts_dir}/.envrc
echo "export arch=$(uname -m)" | sudo tee -a ${scripts_dir}/.envrc
echo "export wordlist=/usr/share/wordlists/Top304Thousand-probable-v2.txt" | sudo tee -a ${scripts_dir}/.envrc
echo "export amiPwn=$(if [ -f "/etc/pwnagotchi/config.toml" ]; then echo 1; else echo 0; fi)" | sudo tee -a ${scripts_dir}/.envrc
echo "export pwnagotchi=Unknown" | sudo tee -a ${scripts_dir}/.envrc
echo "export pwn_installed=0" | sudo tee -a ${scripts_dir}/.envrc
echo "export OS=$OS" | sudo tee -a ${scripts_dir}/.envrc
echo "export VER=$VER" | sudo tee -a ${scripts_dir}/.envrc
echo "export KERN=$(uname -r)" | sudo tee -a ${scripts_dir}/.envrc
}

# Populate the envrc table
populate_envrc
clear
# Update flag to indicate function has ran.
touch "$FLAG_FILE"
fi
}

pkg_info_func() {

sudo dpkg --get-selections > ${scripts_dir}/support/my_installed_apps.list
cat ${scripts_dir}/support/my_installed_apps.list | grep "install" -c

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

        KERN=$(uname -r)

        sed -i 's/^OS=.*/OS=$OS/' ${scripts_dir}/.envrc
        sed -i 's/^VER=.*/VER=$VER/' ${scripts_dir}/.envrc
        sed -i 's/^KERN=.*/KERN=$KERN/' ${scripts_dir}/.envrc

}
function coloredEcho(){
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

main() {
get_vars_func
coloredEcho
pkg_info_func
}

main
cd /opt/easy-linux
direnv allow
sudo direnv allow

cd /opt/easy-linux/support
direnv allow
sudo direnv allow
