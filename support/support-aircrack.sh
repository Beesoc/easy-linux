#!/bin/bash
# Aircrack-ng installer/executor
# Version: 0.0.2

scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
air_installed=""
deps_installed=""

# Search for air_installed in .envrc and extract its value

# Initialize variables if not previously set 
if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) = 1 ]]; then
    run_func
fi

if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) != 1 ]]; then
    air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)
    sed -i 's/air_installed=0/air_installed=1/' .envrc
fi

if [[ $(cat "${scripts_dir}/.envrc" | grep "deps_installed" -c) = 1 ]]; then
    run_func
fi
if [[ $(cat "${scripts_dir}/.envrc" | grep "deps_installed" -c) != 1 ]]; then
    deps_installed=$(grep "deps_installed=" .envrc | cut -d= -f2)
    sed -i 's/deps_installed=0/deps_installed=1/' .envrc
fi

# Step 2 or 4 function.
check_directories_func() {
    if [[ $air_installed -eq 1 ]]; then 
        printf "${WT}[*] ${GN}Aircrack-ng ${CY}directory found.\\n"
        printf "${WT}[*] ${GN}Removing and reinstalling.\\n" 
        sleep 1
        sudo rm -fr /opt/aircrack-ng
    else
        printf "${WT}  Aircrack-ng ${CY}not detected. Continuing...\\n"
    fi

    if [[ $(command -v aircrack-ng) ]] > /dev/null 2>&1; then
        printf "  ${WT}[*] ${GN}Aircrack-ng ${CY}directory found.\\n"
        printf "  ${WT}[*] ${GN}Removing and reinstalling.\\n" 
        sleep 1
        sudo rm -fr /opt/aircrack-ng
    fi  
    wget https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz -P "$HOME/Downloads"

    app_install_func
}

# Step 3 function.
run_func() {
    if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) != 1 ]]; then
        sudo sh -c "echo 'export air_installed=$air_installed' >> ${scripts_dir}/.envrc"
    fi

    air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)

    if [[ $air_installed -eq 1 ]]; then
        printf "${WT}[*] ${GN}Aircrack-ng ${CY}directory found.\\n"
        printf "${WT}[*] ${GN}Removing and reinstalling.\\n"
        sleep 1
        sudo rm -fr /opt/aircrack-ng
    fi

    wget https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz -P "%HOME/Downloads"
    app_install_func

    if [[ $air_installed -ne 1 ]]; then
        sudo sed -i "s/air_installed=.*/air_installed=1/g" "${scripts_dir}/.envrc"
    fi

    cd "${scripts_dir}/support" && direnv allow
}

app_install_func() {
    cd $HOME/Downloads
    tar -xvf $HOME/Downloads/aircrack-ng-1.7.tar.gz

    if [[ $air_installed = 1 ]]; then
        printf "\\n${GN}  Aircrack-ng already installed\\n"
        read -n 1 -s -r -p "Press any key to continue..."
        run_func           
    else
        printf "\\n${GN}  Loading, please wait.\\n"
        if [[ $deps_installed = 1 ]]; then
            printf "${OG} Dependencies already installed\\n"
        elif [[ $deps_installed != 1 ]]; then 
            printf "${GN}\\n"
            read -n 1 -p "Would you like to download and install Aircrack-ng dependencies? [Y/n] " installdeps
            installdeps=${installdeps:-Y}
            if [[ $installdeps =~ ^[Yy]$ ]]; then
                printf "\\n${CY}  Downloading and installing dependencies.  ${WT}Please wait.\\n"
                sudo apt-get update
                sudo apt-get install -y build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils
                if [[ $(cat "${scripts_dir}/.envrc" | grep "deps_installed" -c) != 1 ]]; then
                   sudo sh -c "echo 'export deps_installed=$deps_installed' >> ${scripts_dir}/.envrc"
                   deps_installed=$(grep "deps_installed=" .envrc | cut -d= -f2)
                   sed -i 's/deps_installed=0/deps_installed=1/' ${scripts_dir}/.envrc
                cd ${scripts_dir} && direnv allow
                cd "${scripts_dir}/support" && direnv allow
                fi
                printf "\\n  ${GN}Dependencies installed successfully.\\n"
                read -n 1 -p "Would you like to install Aircrack-ng? [Y/n] " installair
                if [[ $installair =~ ^[Yy]$ ]]; then
                    sudo apt install -y hwloc
                    sudo apt install -y duma
                    sudo apt install -y mk-configure 
                    sudo apt install -y ui-auto
                    cd $HOME/Downloads/aircrack-ng-1.7
                    sudo ./autogen.sh
                    sudo make
                    sudo make install
                    set air_installed=1
                    if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) != 1 ]]; then
                           sudo sh -c "echo 'export air_installed=$air_installed' >> ${scripts_dir}/.envrc"
                           air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)
                           sed -i 's/air_installed=0/air_installed=1/' ${scripts_dir}/.envrc
                    cd "${scripts_dir}/support" && direnv allow
                    fi
                    printf "${GB}  Aircrack-ng has been installed.\\n"
                    read -n 1 -s -r -p "Press any key to continue..."
                    run_func
                fi
            fi
        fi
    fi
}

main() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"
  if [[ $(command -v aircrack-ng) ]] > /dev/null 2>&1; then
      run_func
  else
      check_directories_func
  fi
printf "\\n${GN} "
read -n 1 -s -r -p "Press any key to continue..."

}
main
cd ${scripts_dir}
direnv allow
sudo cp ${scripts_dir}/.envrc ${scripts_dir}/support/.envrc
cd ${scripts_dir}/support
direnv allow

source ${scripts_dir}/menu-master.sh
