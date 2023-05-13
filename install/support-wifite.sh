#!/bin/bash
# Wifite installer/executor
set -e
# Version: 0.0.2
source "${scripts_dir}/.envrc"
trap ${scripts_dir}/support/support-trap-wifi.sh EXIT

app-install_func() {

  if [[ -d "$HOME/compiled/wifite2/" ]]; then
    printf "${WT}Wifite ${OG}installation folder exists.\\n${CY}  " 
    read -n 1 -r -p "Remove folder and reinstall? [Y/n]" reinstall
      reinstall=${reinstall:-Y}
      if [[ ${reinstall} = "Y" ]] || [[ ${reinstall} = "y" ]]; then 
         sudo rm -fR $HOME/compiled/wifite2/
      elif [[ ${reinstall} = "N" ]] || [[ ${reinstall} = "n" ]]; then
         printf "${RED} Wifite will not be installed. Press ${WT}any ${RED} key to return to main menu."
         source "${scripts_dir}/support/support-Prompt_func.sh"
         read -r -n 1 -s -t 300
           source "$scripts_dir/menu-master.sh"
      else
         printf "${YW}    Invalid Selection."
      fi
  else
      printf "${CY}  Creating $HOME/compiled/wifite and cloning Wifite repo into wifite2 folder for installation."
  fi
  
  cd $HOME/compiled || exit
  git clone https://github.com/kimocoder/wifite2.git
  cd wifite2 || exit
  pip3 install -r requirements.txt
  sudo python3 setup.py install
  wifite-installed=1
}

main() {
clear
source ${scripts_dir}/support/support-Banner_func.sh
                  

   if [[ $(command -v wifite >/dev/null 2>&1) ]]; then
                printf "${GN}Wifite is already installed"
                sudo wifite
                wifite-installed=1
           else
                printf "${YW}Wifite is not installed.  Installing..."
                     read -n 1 -r -p "Do you want to install Wifite? [Y/n]" install
                     install=${install:-Y}
                         if [[ $install = "N" ]] || [[ $install = "n" ]]; then
                            exit 0
                         elif [[ $install = "Y" ]] || [[ $install = "y"  ]]; then
                app-install_func
                         fi
           fi

printf "${CY}  Your wordlist is currently set to: ${WT}${wordlist}${CY}\\n." 
printf "${CY}  To change your used wordlist, select ${WT}C${CY}.\\n"
printf "To keep the default, enter ${WT}W.\\n"

read -n 1 -p "[C]hange your wordlist or keep Default [W]ordlist?" wlchoice
if [[ ${wlchoice} = "W" ]] || [[ ${wlchoice} = "w" ]]; then
  printf "${CY}  Default wordlist, ${WT}${wordlist}${CY} selected.\\n"
elif [[ ${wlchoice} = "c" ]] || [[ ${wlchoice} = "C" ]]; then
  wordlist=""
  read -r -p "Enter the FULL PATH and file name for your desired wordlist" mywordlist
  wordlist=${mywordlist}
fi
clear
source ${scripts_dir}/support/support-Banner_func.sh
sudo wifite -v -i ${adapter} -mac -p 160 --kill -ic --daemon --clients-only --dict ${wordlist}
source ${scripts_dir}/menu-hacking.sh
}

main
