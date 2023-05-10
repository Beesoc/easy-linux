#!/bin/bash
# Aircrack-ng installer/executor
# Version: 0.0.2

scripts_dir=/opt/easy-linux
source "${scripts_dir}/support/support-Banner_func.sh"
source "${scripts_dir}/.envrc"

if [[ $(cat ${scripts_dir}/.envrc | grep "depsinstalled" -c) = 0 ]]; then
    depsinstalled=0
fi

if [[ $(cat ${scripts_dir}/.envrc | grep "airinstalled" -c) = 0 ]]; then
    airinstalled=0
fi

check_directories_func() {
    # Step 2 or 4 function.
    if [[ $airinstalled = 1 ]]; then 
        run_func
    else
        printf "${WT}  Aircrack-ng ${CY}not detected. Continuing...\\n"
    fi

    if [[ -d /opt/aircrack-ng ]]; then
        printf "  ${WT}[*] ${GN}/opt/aircrack-ng ${CY}directory found.\\n"
        printf "  ${WT}[*] ${GN}Removing and reinstalling.\\n " 
        sleep 1
        sudo rm -fr /opt/aircrack-ng
    elif [[ ! -d /opt/aircrack-ng ]]; then
        #sudo chown -v 1000:1000 /opt
        printf " ${WT} [*] ${WT}/opt/aircrack-ng ${CY}directory not found. Installing into that folder.\\n"; sleep 1
    fi  
    #curl https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz $HOME/Downloads
    sudo wget https://download.aircrack-ng.org/aircrack-ng-1.7.tar.gz -P $HOME/Downloads

    app-install_func
}

run_func() {
    depsinstalled=1
    if [[ $(cat ${scripts_dir}/.envrc | grep "depsinstalled" -c) -gt 0 ]]; then
        printf "${CY}...Variables previously written...Continuing...\\n"
    elif [[ $(cat ${scripts_dir}/.envrc | grep "airinstalled" -c) != 1 ]]; then
        sudo sh -c "echo 'export depsinstalled=$depsinstalled' >> ${scripts_dir}/.envrc"
        cd ${scripts_dir}/support && direnv allow
    fi                 
    airinstalled=1
    if [[ $(cat ${scripts_dir}/.envrc | grep "airinstalled" -c) -gt 0 ]]; then
        printf "${CY}...Variables previously written...Continuing...\\n"
    elif [[ $(cat ${scripts_dir}/.envrc | grep "airinstalled" -c) != 1]]; then
           sudo sh -c echo "export airinstalled=$airinstalled" >> ${scripts_dir}/.envrc
           cd ${scripts_dir} && direnv allow
     fi
     sudo aircrack-ng --help
     sudo aircrack-ng -u
     printf "${CY} See program help above.\\n  ${WT}"
     read -n 1 -s -p "Press any key to continue..."

}

app-install_func() {
sudo tar -xvf $HOME/Downloads/aircrack-ng-1.7.tar.gz

if [[ $airinstalled = 1 ]]; then
    printf "${GB}  Aircrack-ng already installed\\n"
    read -n 1 -s -r -p "Press any key to continue..."
    run_func
else
  printf "${GN}  Loading, please wait."
  if [[ $depsinstalled = 1 ]]; then
       printf "${OG} Dependencies already installed\\n"
  elif [[ $depsinstalled != 1 ]]; then 
   printf "${GN}\\n"
       read -n 1 -p "Would you like to download and install Aircrack-ng dependancies? [Y/n] " installdeps
           installdeps=${installdeps:-Y}
           if [[ $installdeps =~ ^[Yy]$ ]]; then
                   printf "${CY}  Downloading and installing dependencies.  ${WT}Please wait.\\n"
                sudo apt-get update
        sudo apt-get install -y build-essential autoconf automake libtool pkg-config libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool rfkill zlib1g-dev libpcap-dev libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant tcpdump screen iw usbutils
                depsinstalled=1
                sudo sh -c echo "export depsinstalled=$depsinstalled" >> ${scripts_dir}/.envrc
                cd ${scripts_dir} && direnv allow
                   printf "  ${GN}Dependencies installed successfully.\\n"
                           read -n 1 -p "Would you like to download and install Aircrack-ng? [Y/n] " installair
                           if [[ $installair =~ ^[Yy]$ ]]; then
                           sudo apt install -y hwloc
                           sudo apt install -y duma
                           sudo apt install -y mk-configure 
                           sudo apt install -y ui-auto
                           cd $HOME/Downloads/aircrack-ng-1.7

                           sudo ./autogen.sh
                           sudo ./make

                           sudo make check
                           sudo make integration
                             if [[ -f /usr/bin/aircrack-ng ]]; then
                                sudo mv /usr/bin/aircrack-ng /usr/bin/aircrack-ng.backup
                             fi
                           sudo make install
                           airinstalled=1  
                           elif [[ $installair = "N" ]] || [[ $installair = "n" ]]; then
                           printf "${RED}  Not installing aircrack-ng.  Exiting.\\n"
                             exit 0
                           fi
                           sudo sh -c echo "export airinstalled=$airinstalled" >> ${scripts_dir}/.envrc
                           cd ${scripts_dir} && direnv allow
           elif [[ $installdeps =~ ^[Nn]$ ]]; then
                   printf "${RED} [✘] Exit tool [✘]${NC} \\n"
               exit 0
           else
               printf "  ${RED}Invalid Selection.\\n"
           fi
  else
      $depsinstalled=0
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
cd $HOME/easy-linux && direnv allow
sudo cp $HOME/easy-linux/.envrc $HOME/easy-linux/support/.envrc
cd $HOME/easy-linux/support && direnv allow

source ${scripts_dir}/menu-master.sh
