#!/bin/bash
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.2
scripts_dir=/opt/easy-linux
source "${scripts_dir}/.envrc"
clear
source "${scripts_dir}/support/support-Banner_func.sh"

nano_lints_func() {
      printf "${OG}  Installing additional nano lints.${NC}\\n"
  if [[ -d ${compiled_dir} ]]; then
        printf " \\n";
          cd ${compiled_dir} || exit
        printf "  \\n";
  else
          mkdir ${compiled_dir} && cd ${compiled_dir}
  fi
         
  if [[ -d ${compiled_dir}/nanorc ]]; then
        sudo rm -Rf ${compiled_dir}/nanorc
          cd ${compiled_dir} || exit
        printf "  \\n"
  fi

      git clone https://github.com/scopatz/nanorc.git
        cd nanorc || exit
          sudo cp *.nanorc /usr/share/nano
          sudo cp ./shellcheck.sh /usr/bin
          sudo rm -Rf ${compiled_dir}/nanorc/
}

pack_sel_func() {
# List of package names to install
     packages=("ip" "ps" "gawk" "xterm" "lspci" "aptitude" "autoconf" "automake" "bc" "libtool" "pkg-config" "libssl-dev" "ethtool" "geany" "geany-plugins" " htop" "shtool" "rfkill" "libpcap-dev" "libsqlite3-dev" "libhwloc-dev" "ncdu" "hostapd" "wpasupplicant" "tcpdump" "screen" "iw" "usbutils" "procps" "procps-ng" "acpi" "pciutils" "groff")

# Loop through the list of package names
for package in "${packages[@]}"
do
    if dpkg -s "$package" >/dev/null 2>&1; then
        printf "  ${GN}$package is already installed"
    else
        printf "  ${CY}Installing $package${WT}\\n"
        sudo apt-get install -y "$package"
    fi
done
nano_lints_func
}

main() {
clear
               source "${scripts_dir}/support/support-Banner_func.sh"
               printf "${YW}\\n\\n    You chose standard apps.${WT} [***] ${YW}This menu contains software that is some\\n"
               printf "    of my favorites or are required for other things that Linux Loader needs.\\n"
                printf "\\n${GN}    Should be safe installing anything here. ${WT}[***]\\n\\n    " 

            read -n 1 -p "Do you want to continue? [Y/n] " choicefavs
            choicefavs=${choicefavs:-Y}
               if [[ $choicefavs =~ ^[Yy]$ ]]; then
                 printf "Continuing...\\n"
               else
                   printf "Exiting.\\n"
              exit 0
                  fi

              printf " ${OG}\\nInstalling Standard and Recommended favorite apps\\n"

}

main
pack_sel_func
standard_apps_func
printf "${CY}  All apps in this script have been successfully installed. This includes all apps listed here: ${PL}\\n"
printf "$packages\\n"
printf "${OG}  Press ${WT}any ${OG}key to continue."
read -n 1 -s -t 300
source ${scripts_dir}/menu-apps.sh
