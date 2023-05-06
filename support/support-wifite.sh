#!/bin/bash
# Wifite installer/executor
set -e
# Version: 0.0.2
source "${scripts_dir}/.envrc"
source "${scripts_dir}/support/support-Banner_func.sh"
trap ${scripts_dir}/support/support-trap.wifi.sh EXIT

app-install_func() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"

  if [[ -d "$HOME/compiled/wifite2/" ]]; then
    read -r -p "Wifite installation folder exists. Remove folder and reinstall?" reinstall
      if [[ ${reinstall} = "Y" ]] || [[ ${reinstall} = "y" ]]; then 
         sudo rm -fR $HOME/compiled/wifite2/
      elif [[ ${reinstall} = "N" ]] || [[ ${reinstall} = "n" ]]; then
         printf "${RED} Wifite will not be installed. Press ${WT}any ${RED} key to return to main menu."
         source "${scripts_dir}/support/support-Prompt_func.sh"
         read -r -n1 -s -t 60
           bash "$scripts_dir/menu-master.sh"
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
}

main() {
source ${scripts_dir}/support/support-Banner_func.sh

   if command -v wifite >/dev/null 2>&1; then
                printf "${GN}Wifite is already installed"
           else
                printf "${YW}Wifite is not installed.  Installing..."
                app-install_func
           fi

printf "${CY}  Your wordlist is currently set to: ${WT}${wordlist}${CY}." 
printf "${CY}  To change your used wordlist, select ${WT}C${CY}. To keep the default, enter ${WT}W."

read -r -p "[C]hange your wordlist or keep Default [W]ordlist?" wlchoice
if [[ ${wlchoice} = "W" ]] || [[ ${wlchoice} = "w" ]]; then
  printf "${CY}  Default wordlist, ${WT}${wordlist}${CY} selected."
elif [[ ${wlchoice} = "c" ]] || [[ ${wlchoice} = "C" ]]; then
  wordlist=""
  read -r -p "Enter the FULL PATH and file name for your desired wordlist" mywordlist
  wordlist=${mywordlist}
fi
clear
source ${scripts_dir}/support/support-Banner_func.sh
sudo wifite -v -i ${adapter} -mac -p 160 --kill -ic --daemon --clients-only --dict ${wordlist}
clear
bash ${scripts_dir}/menu-hacking.sh
}

main

