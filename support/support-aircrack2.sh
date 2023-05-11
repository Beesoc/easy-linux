#!/bin/bash
# Aircrack-ng installer/executor
# Version: 0.0.2

scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
set -e

deps_install_func() {
# Install dependencies and Aircrack-ng
# function 3
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils
deps_installed=1
app_install_func
}

app_install_func() {
wget https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz -P "$HOME/Downloads"
cd $HOME/Downloads
sudo tar -xvf $HOME/Downloads/aircrack-ng-1.7.tar.gz

cd $HOME/Downloads/aircrack-ng-1.7

sudo ./autogen.sh
sudo make
sudo make install
air_installed=1
aircrack_run_func
envrc_func

}

# function 4
aircrack_check_func() {
if [[ $air_installed -eq 0 && $deps_installed -eq 0 ]]; then
deps_install_func
fi
if [[ $air_installed -eq 1 && $deps_installed -eq 1 ]]; then
aircrack_run_func
fi
if [[ $air_installed -eq 0 && $deps_installed -eq 1 ]]; then
app_install_func
fi
if [[ $air_installed -eq 1 && $deps_installed -eq 0 ]]; then
deps_install_func
fi
}

aircrack_run_func() {
# Check if Aircrack-ng is already installed
# Function 1
if [[ $air_installed -eq 1 && $deps_installed -eq 1 ]]; then
    printf "\\n${GN}  Aircrack-ng is already installed.${CY}\\n"
    sudo aircrack-ng --help
    sudo aircrack-ng -u
    read -n 1 -s -r -p "Press any key to continue" 
    clear
    envrc_func
    source ${scripts_dir}/menu-master.sh
    exit 0
else
    printf "\\n${GN} Checking dependencies...\\n"
    deps_installed=0
    for package in build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            deps_installed=0
            printf "${CY}  $package is not installed.\\n"
            printf "${WT}  Installing $package...\\n"
            sudo apt-get update
            sudo apt-get install -y "$package"
        else
            printf "${GN} $package is installed.\\n"
            deps_installed=1
        fi
    done
fi
envrc_func

}

main() {
# Prompt the user to install dependencies and Aircrack-ng
clear
source ${scripts_dir}/support/support-Banner_func.sh
printf "\\n "
printf "\\n  ${GN}  Welcome to the Aircrack-ng installer.\\n"
printf "${WT}  Please note that this script requires an active internet connection.\\n"
printf "\\n${CY}  This script will install Aircrack-ng and its dependencies.\\n"
printf "${GN}    Do you want to continue?${WT} [Y/n] "
read -n 1 -s -r -p confirm
confirm=${confirm:-Y}
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    printf "${GN}  Aborting installation.\\n"
    exit 0
fi
if [[ "$confirm} =~ Yy ]]; then
printf "${WT}\\n    This script requires ${WT}superuser privileges.\\n"
printf "${WT}    Please enter your password if prompted.\\n"

aircrack_check_func

}

envrc_func() {
# Update the .envrc file with the new values
sudo sed -i "s/air_installed=.*/air_installed=$air_installed/g" "${scripts_dir}/.envrc"
sudo sed -i "s/deps_installed=.*/deps_installed=$deps_installed/g" "${scripts_dir}/.envrc"

cd "${scripts_dir}/support" && direnv allow

if [[ $air_installed = 1 && $deps_installed = 1 ]]; then 
    printf "\\n${GN}  ${WT}Aircrack-ng ${CY}has been installed successfully.\\n"
elif [[ $air_installed = 0 && $deps_installed = 1 ]]; then 
    printf "\\n${GN}  ${WT}Aircrack-ng ${CY}is not reporting a successful install.\\n"
elif [[ $air_installed = 1 && $deps_installed = 0 ]]; then 
    printf "\\n${GN}  ${WT}Dependancies ${CY}are not reporting a successful install.\\n"
else
    printf "\\n${GN}  ${WT}Can't determine installation status"
fi
}

main
source ${scripts_dir}/menu-master.sh
exit 0
