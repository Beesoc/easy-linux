#!/bin/bash
# script to install and launch airgeddon.
scripts_dir=/opt/easy-linux
set -e
#
source ${scripts_dir}/.envrc
clear
source "${scripts_dir}/support/support-Banner_func.sh"

run_airg_func() {
sudo aircrack-ng --help && sudo aircrack-ng -u
sudo airgeddon
printf "${CY}end.  Press ${WT}any ${CY}"

read -n 1 -s -p "key to continue."
source /opt/easy-linux/menu-master.sh
exit 0

}

airg_install_func() {
if [[ $airg_deps_inst = 0 ]]; then
   deps_airg_install
else [[ $airg_deps_inst = 1 ]]; then
   printf "  ${CY}Dependencies all installed.  Continuing.\\n"
      if

run_airg_func
}

deps_airg_install() {
# List of package names to install
       packages=("iw" "aircrack-ng" "ip" "ps" "gawk" "xterm" "lspci" "autoconf" "automake" "libtool pkg-config" "libnl-3-dev" "libnl-genl-3-dev" "libssl-dev" "ethtool" "shtool" "rfkill zlib1g-dev" "libpcap-dev" "libsqlite3-dev" "libpcre3-dev" "libhwloc-dev" "libcmocka-dev" "hostapd" "wpasupplicant" "tcpdump" "screen" "iw" "usbutils" "xml2" "procps" "procps-ng" "iproute2" "airodump-ng" "pciutils" "groff")

# Loop through the list of package names
for package in "${packages[@]}"
do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo "$package is already installed"
    else
        echo "Installing $package"
        sudo apt-get install -y "$package"
    fi
done
    airg_deps_inst=1
}

deps_airg_check() {
    printf "\\n${GN} Checking dependencies...\\n"
    if [[ "${airg_deps_inst}" = 1 ]]; then
    printf "  ${WT}$Airgeddon dependencies ${CY}are installed.  Continuing..."
    inst_airg_func
    elif [[ "${airg_deps_inst}" = 0 ]]; then
    printf "  ${WT}Airgeddon dependencies ${CY}not installed.  Installing..."
    fi
#  install Deps - Aircrack-ng check
        if [[ $(command -v aircrack-ng >/dev/null 2>&1) ]]; then
           printf "  Aircrack-NG is installed."    
        else
           clear
           source ${scripts_dir}/support/support-aircrack2.sh
        fi
#  install Deps - airgeddon
        if $airg_deps_inst=0; then
        deps_airg_install
        elif $airg_deps_inst=1; then
        airg_install
        fi
}


airg_inst_func() {

}

main() {
    clear
    source ${scripts_dir}/support/support-Banner_func.sh
    printf "  \\n${CY}This script will ${WT}install/launch Airgeddon${CY}.\\n${OG}  "
    read -n 1 -s -p "Do you want to continue? [Y/n] " installairg
    installairg=${installairg:-Y}
    if [[ $air_installed = 0 ]]; then
       source ${scripts_dir}/support/support-aircrack2.sh
    fi
    if [[ "$installairg" ~= ^[Nn]$ ]]; then
       printf "  ${WT}$USER ${RED}chose not to install. Exiting."   
       exit 0
    elif [[ "$installairg" ~= ^[Yy]$ ]]; then
       deps_airg_func
    else
         printf "  ${RED}Invalid Selection."
    fi
}

main
clear
source ${scripts_dir}/menu-master.sh
