#!/bin/bash
# Wifite installer/executor
set -e
cd ..
source .envrc
source support/Banner_func.sh

app-install_func() {
clear
source support/Banner_func.sh
  if [[ -d "~/compiled/wifite2/" ]]; then
    read -r -p "Wifite installation folder exists. Remove folder and reinstall?" reinstall
      if [[ ${reinstall} = "Y" ]] || [[${reinstall} = "y" ]]; then 
         sudo rm -fR ~/compiled/wifite2/
      elif [[ ${reinstall} = "N" ]] || [[ ${reinstall} = "n" ]]; then
         printf "${RED} Wifite will not be installed. Press ${WT}any ${RED} key to return to main menu."
         source support/Prompt_func.sh
         read -r -n1 -s -t 60
           bash $scripts_dir/install-master.sh
      else
         printf "${YW}    Invalid Selection."
      fi
  else
      printf "${CY}  Creating ~/compiled/wifite and cloning Wifite repo into wifite2 folder for installation."
  fi
  
  cd ~/compiled
  git clone https://github.com/kimocoder/wifite2.git
  cd wifite2
  pip3 install -r requirements.txt
  sudo python3 setup.py install
}

main() {
source support/Banner_func.sh
if which wifite >/dev/null 2>&1; then
  printf "${WT}Wifite ${CY}is ${RED}not installed${CY}. Installing..."
  app-install_func
else
  printf "Wifite is already installed. Continuing"
fi

printf "${CY}  Your wordlist is currently set to: ${WT}${wordlist}${CY}." 
printf "To change your used wordlist, select ${WT}C${CY}. To keep the default, enter ${WT}W."

read -r -p "[C]hange your wordlist or keep Default [W]ordlist?" wlchoice
if [[ ${wlchoice} = "W" ]] || [[ ${wlchoice} = "w" ]]; then
  printf "${CY}  Default wordlist, ${WT}${wordlist}${CY} selected."
elif [[ ${wlchoice} = "c" ]] || [[ ${wlchoice} = "C" ]]; then
  wordlist=""
  read -r -p "Enter the FULL PATH and file name for your desired wordlist" mywordlist
  wordlist=${mywordlist}

clear
source ${scripts_dir}/support/Banner_func.sh
sudo wifite -v -i ${adapter} -mac -p 160 --kill -ic --daemon --clients-only --dict ${wordlist}
clear
bash ${scripts_dir}/install-hacking.sh
}

main

