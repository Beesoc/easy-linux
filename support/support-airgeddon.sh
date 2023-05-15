#!/bin/bash
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
source /opt/easy-linux/.envrc

run_airg_func() {
if [[ $(command -v airgeddon >/dev/null 2>&1) ]] && [[ $airg_installed = 1 ]]; then
airg_deps_inst=1
export airg_installed=1

    sudo sed -i "s/airg_deps_inst=.*/airg_deps_inst=$airg_deps_inst/g" "${scripts_dir}/.envrc"
    sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "/opt/easy-linux/.envrc"
sudo /bin/bash airgeddon
fi
printf "${CY}  Press ${WT}any ${CY}"

read -n 1 -s -t 300 -p "key to continue "
printf "${CY}to the ${WT}Main Menu."
source /opt/easy-linux/menu-master.sh
exit 0
}

airg_install_func() {
if [[ $airg_deps_inst = 0 ]]; then
   deps_airg_install
elif [[ $airg_deps_inst = 1 ]]; then
   printf "  ${CY}Dependencies all installed.  Continuing.\\n"
fi
if [[ -d $HOME/Downloads/airgeddon ]]; then
        rm -rf $HOME/Downloads/airgeddon
        mkdir $HOME/Downloads/airgeddon
elif [[ ! -d $HOME/Downloads/airgeddon ]]; then
        mkdir $HOME/Downloads/airgeddon
fi
git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git $HOME/Downloads/airgeddon

# Airgeddon must be run with BASH shell, not SH
cd $HOME/Downloads/airgeddon
sudo /bin/bash airgeddon.sh
airg_installed=1
sudo sed -i "s/airg_installed=.*/airg_installed=$airg_installed/g" "${scripts_dir}/.envrc"
run_airg_func
}

deps_airg_option() {
       optpackages=("wpaclean" "crunch" "aireplay-ng" "mdk4 / mdk3" "hashcat" "hostapd" "dhcpd / isc-dhcp-server / dhcp-server / dhcp" "nft / nftables / iptables" "ettercap / ettercap-text-only / ettercap-graphical" "hashcat-utils" "etterlog" "lighttpd" "dnsmasq" "wash / reaver" "reaver / wash" "bully" "pixiewps" "bettercap" "beef / beef-xss / beef-project" "packetforge-ng" "hostapd-wpe" "asleap / asleep" "john" "openssl" "hcxpcapngtool / hcxtools" "hcxdumptool" "tshark / wireshaek-cli" "xml2")

for optpackage in "${optpackages[@]}"
do
    if dpkg -s "$optpackages" >/dev/null 2>&1; then
          echo "$optpackages is already installed"
    else
          echo "Installing $optpackages"
          sudo apt-get install -y "$optpackages"
    fi
    airg_deps_inst=1
    sudo sed -i "s/airg_deps_inst=.*/airg_deps_inst=$airg_deps_inst/g" "${scripts_dir}/.envrc"
done
airg_install_func
}

deps_airg_install() {
# List of package names to install
       packages=("iw" "ip" "ps / procps / procps-ng" "awk / gawk" "xterm / tmux" "lspci / pciutils" "autoconf" "automake" "libtool pkg-config" "libnl-3-dev" "libnl-genl-3-dev" "libssl-dev" "ethtool" "shtool" "rfkill" "zlib1g-dev" "libpcap-dev" "libsqlite3-dev" "libpcre3-dev" "libhwloc-dev" "libcmocka-dev" "hostapd" "wpasupplicant" "tcpdump" "screen" "iw" "usbutils" "airodump-ng" "groff")

# Loop through the list of package names
for package in "${packages[@]}"
do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo "$package is already installed"
    else
        echo "Installing $package"
        sudo apt-get install -y "$package"
    fi
    airg_deps_inst=1
    sudo sed -i "s/airg_deps_inst=.*/airg_deps_inst=$airg_deps_inst/g" "${scripts_dir}/.envrc"
done
deps_airg_option
}

deps_airg_check() {
    printf "\\n${GN} Checking dependencies...\\n"
    if [[ "${airg_deps_inst}" = 1 ]]; then
    printf "  ${WT}$Airgeddon dependencies ${CY}are installed.  Continuing...\\n"
    airg_install_func
    elif [[ "${airg_deps_inst}" = 0 ]]; then
    printf "  ${WT}Airgeddon dependencies ${CY}not installed.  Installing...\\n"
    fi
#  install Deps - Aircrack-ng check
#  install Deps - airgeddon
        if [[ "$airg_deps_inst" == 0 ]]; then
        deps_airg_install
        elif [[ "$airg_deps_inst" == 1 ]]; then
        airg_install_func
        fi
}

main() {
# Check for aircrack-ng installation
clear
source ${scripts_dir}/support/support-Banner_func.sh

# Check for airgeddon installation
if [[ -d $HOME/Downloads/airgeddon ]] && [[ $airg_installed -eq 1 ]]; then
    printf "Airgeddon is already installed. Launching...\n"
    run_airg_func
fi

if [[ $airg_deps_inst = 1 ]]; then
    airg_install_func
elif [[ $airg_deps_inst = 0 ]]; then
    deps_airg_install
fi

if [[ -f /opt/easy-linux/.envrc ]]; then
    airc_installed=$(grep "airc_installed" /opt/easy-linux/.envrc | cut -d "=" -f 2)
    if [[ $airc_installed -eq 1 ]]; then
        printf "Aircrack-NG is already installed. Skipping installation.\\n"
    else
        printf "Aircrack-NG dependencies not installed. Installing...\\n"
        source /opt/easy-linux/support/support-aircrack2.sh     
    fi
fi

if [[ -d $HOME/Downloads/airgeddon ]]; then
    printf "Airgeddon download folder not found. Cloning...\\n"
       if [[ $airg_installed -eq 1 ]]; then
#        printf "Aircrack-ng is already installed. Skipping installation.\\n"
        run_airg_func
    else
        printf "Airgeddon dependencies not installed. Installing...\\n"

        #source /opt/easy-linux/support/support-aircrack2.sh
    fi 
    deps_airg_check
    
fi
}

main
