#!/bin/bash
# Aircrack-ng installer/executor
# Version: 0.0.2

scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
air_installed=""
deps_installed=""

# Search for air_installed in .envrc and extract its value


# Step 3 function.
run_func() {
    if [[ $air_installed = 1 && $deps_installed = 1  ]]; then
        sudo aircrack-ng --help
        sudo aircrack-ng -u
        exit 0
    fi

    if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) != 1 ]]; then
        sudo sh -c "echo 'export air_installed=$air_installed' >> ${scripts_dir}/.envrc"
    app_install_func
    fi

    air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)
  
    if [[ $air_installed -ne 1 ]]; then
        air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)

        sudo sed -i "s/air_installed=.*/air_installed=1/g" "${scripts_dir}/.envrc"
    fi

    cd "${scripts_dir}/support" && direnv allow
}

app_install_func() {

    if [[ $air_installed -ne 1 ]]; then
        wget https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz -P "$HOME/Downloads"
        sudo tar -xvf $HOME/Downloads/aircrack-ng-1.7.tar.gz
        printf "\\n${GN}  Aircrack-ng already installed\\n"
        read -n 1 -s -r -p "Press any key to continue..."
    else
        printf "\\n${GN}  Loading, please wait.\\n"
        sudo aircrack-ng --help
        sudo aircrack-ng -u
    fi
    if [ ${deps_installed} -eq 1 ]; then
            printf "${OG} Dependencies already installed\\n"
    elif [ $deps_installed != 1 ]; then 
        printf "${GN}\\n"
        read -n 1 -p "Would you like to download and install Aircrack-ng dependencies? [Y/n] " installdeps
        printf "\\n"
        installdeps=${installdeps:-Y}
        if [[ "$installdeps" =~ ^[Yy]$ ]]; then
            printf "\\n${CY}  Downloading and installing dependencies.  ${WT}Please wait.\\n"
            sudo apt-get update
            sudo apt-get install -y build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils
              if [[ $(cat "${scripts_dir}/.envrc" | grep "deps_installed" -c) != 1 ]]; then
                   sudo sh -c "echo 'export deps_installed=$deps_installed' >> ${scripts_dir}/.envrc"
                   deps_installed=$(grep "deps_installed=" .envrc | cut -d= -f2)
                   sudo sed -i 's/deps_installed=0/deps_installed=1/' ${scripts_dir}/.envrc
                  cd ${scripts_dir}
                  direnv allow
                  cd "${scripts_dir}/support"
                  direnv allow
              fi   
         fi
                printf "\\n  ${GN}Dependencies installed successfully.\\n"
     fi      
     if [[ $air_installed = 0 ]]; then
          read -n 1 -p "Would you like to install Aircrack-ng? [Y/n] " installair
          installair=${installair:-Y}
               if [[ "$installair" =~ ^[Yy] ]]; then
                   sudo apt install -y hwloc
                   sudo apt install -y duma
                   sudo apt install -y mk-configure 
                   sudo apt install -y ui-auto
                   cd $HOME/Downloads/aircrack-ng-1.7
                   sudo ./autogen.sh
                   sudo make
                   sudo make install
               else
                   printf "${RED}  You chose to NOT install Aircrack-NG.  Exiting.
                   exit 0
               fi 
               printf "${GB}  Aircrack-ng has been installed.\\n"
      fi             
                    # Set the air_installed and deps_installed variables to 1
                         air_installed=1
                         deps_installed=1

                    # Write the air_installed and deps_installed variables to the .envrc file
                         sudo sed -i "s/air_installed=.*/air_installed=$air_installed/g" "${scripts_dir}/.envrc"
                         sudo sed -i "s/deps_installed=.*/deps_installed=$deps_installed/g" "${scripts_dir}/.envrc"

                       if [ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) != 1 ]; then
                           sudo sh -c "echo 'export air_installed=$air_installed' >> ${scripts_dir}/.envrc"
                           air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)
                           sudo sed -i 's/air_installed=0/air_installed=1/' ${scripts_dir}/.envrc
                       cd "${scripts_dir}/support"
                       direnv allow
                       fi
                     run_func

}

main() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"
# Initialize variables if not previously set 
if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) = 1 ]]; then
    run_func
fi

if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) != 1 ]]; then
    air_installed=$(grep "air_installed=" .envrc | cut -d= -f2)
    sudo sed -i 's/air_installed=0/air_installed=1/' .envrc
fi

if [[ $(cat "${scripts_dir}/.envrc" | grep "deps_installed" -c) = 1 ]]; then
    run_func
fi
if [[ $(cat "${scripts_dir}/.envrc" | grep "deps_installed" -c) != 1 ]]; then
    deps_installed=$(grep "deps_installed=" .envrc | cut -d= -f2)
    sudo sed -i 's/deps_installed=0/deps_installed=1/' .envrc
fi

  if [[ $(command -v aircrack-ng) ]] > /dev/null 2>&1; then
      run_func
  else
      app_install_func
  fi
printf "\\n${GN} "

# Check if air_installed and deps_installed are set to 1
if [[ $(cat "${scripts_dir}/.envrc" | grep "air_installed" -c) -eq 1 ]]; then
  printf "\\n${CY} Aircrack-ng and its dependencies have already been installed.\\n"
  sudo aircrack-ng --help
  sudo aircrack-ng -u
  read -n 1 -s -r -p "Press any key to continue..."
  source ${scripts_dir}/menu-master.sh
exit 0
else
  app_install_func
fi

}
main
cd ${scripts_dir}
direnv allow
sudo cp ${scripts_dir}/.envrc ${scripts_dir}/support/.envrc
cd ${scripts_dir}/support
direnv allow

source ${scripts_dir}/menu-master.sh
