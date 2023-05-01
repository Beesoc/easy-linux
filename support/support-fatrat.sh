#!/bin/bash
# The Fat Rat installer/executor
# Version: 0.0.2

set -e
cd ..
source .envrc
source support-Banner_func.sh

app-install_func() {
clear
source "support-Banner_func.sh"
  if [[ ! -d "$HOME/compiled/TheFatRat/" ]]; then
      read -rp "Would you like to install The Fat Rat? (y/n) " install_fatrat
      if [[ "$install_fatrat" = "y" ]] || [[ ${install_fatrat} = "Y" ]]; then
        sudo git clone https://github.com/Screetsec/TheFatRat.git &&
          cd TheFatRat &&
          sudo chmod +x setup.sh &&
          sudo ./setup.sh
      fi
  elif [[ -d "$HOME/compiled/TheFatRat/" ]]; then 
    read -r -p "The Fat Rat installation folder exists. Remove folder and reinstall?" reinstall
      if [[ ${reinstall} = "N" ]] || [[ ${reinstall} = "n" ]]; then
         printf "${RED} The Fat Rat will not be installed. Press ${WT}any ${RED} key to return to Hacking Menu."
         source "support-Prompt_func.sh"
         read -r -n1 -s -t 60
           bash $scripts_dir/menu-hacking.sh
      elif [[ "$reinstall" = "y" ]] || [[ ${reinstall} = "Y" ]]; then
         sudo rm -fR ~/compiled/TheFatRat
      else
         printf "${YW}    Invalid Selection."
  fi
  fi
        sudo git clone https://github.com/Screetsec/TheFatRat.git &&
          cd TheFatRat &&
          sudo chmod +x setup.sh &&
          sudo ./setup.sh

}

main() {
source "support-Banner_func.sh"
if which fatrat >/dev/null 2>&1; then
  printf "${WT}The FAt Rat ${CY}is ${RED}not installed${CY}. Installing..."
  app-install_func
else
  printf "The Fat Rat is already installed. Continuing"
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
fi
clear
source support-Banner_func.sh
sudo gnome-terminal -t "TheFatRat 1.9.5" --geometry=600x630 -e "bash -c 'fatrat';-bash"
clear
bash ${scripts_dir}/menu-hacking.sh
}

main

