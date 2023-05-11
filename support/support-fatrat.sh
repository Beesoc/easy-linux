#!/bin/bash
# The Fat Rat installer/executor
# Version: 0.0.2

set -e
source ${scripts_dir}/.envrc
source ${scripts_dir}/support/support-Banner_func.sh

app-install_func() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"
  if [[ ! -d "$HOME/compiled/TheFatRat/" ]]; then
      read -n 1 -r -p "Would you like to install The Fat Rat? (Y/n) " install_fatrat
      install_fatrat={$install_fatrat:-Y}
      if [[ "$install_fatrat" ~= ^[Yy]$ ]]; then
        sudo git clone https://github.com/Screetsec/TheFatRat.git &&
          cd TheFatRat &&
          sudo chmod +x setup.sh &&
          sudo ./setup.sh
      fi
  elif [[ -d "$HOME/compiled/TheFatRat/" ]]; then 
    read -n 1 -r -p "The Fat Rat installation folder exists. Remove folder and reinstall?" reinstall
    reinstall={$reinstall:-Y}
      if [[ "$reinstall" ~= ^[Nn]$ ]]; then
         printf "${RED} The Fat Rat will not be installed. Press ${WT}any ${RED} key to return to Hacking Menu."
         read -r -n 1 -s -t 300
           source $scripts_dir/menu-hacking.sh
      elif [[ "$reinstall" ~= ^[Yy]$ ]]; then
         sudo rm -fR $HOME/compiled/TheFatRat
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
source "${scripts_dir}/support/support-Banner_func.sh"
if which fatrat >/dev/null 2>&1; then
  printf "  ${WT}The FAt Rat ${CY}is ${RED}not installed${CY}. Installing..."
  app-install_func
else
  printf "${GN}  The Fat Rat is already installed. Continuing"
fi

#printf "${CY}  Your wordlist is currently set to: ${WT}${wordlist}${CY}." 
#printf "To change your used wordlist, select ${WT}C${CY}. To keep the default, enter ${WT}W."

#read -r -p "[C]hange your wordlist or keep Default [W]ordlist?" wlchoice
#if [[ ${wlchoice} = "W" ]] || [[ ${wlchoice} = "w" ]]; then
#  printf "${CY}  Default wordlist, ${WT}${wordlist}${CY} selected."
#elif [[ ${wlchoice} = "c" ]] || [[ ${wlchoice} = "C" ]]; then
#  wordlist=""
#  read -r -p "Enter the FULL PATH and file name for your desired wordlist" mywordlist
#  wordlist=${mywordlist}
#fi
#sudo gnome-terminal -t "TheFatRat 1.9.5" --geometry=600x630 -e "bash -c 'fatrat';-bash"
app-install_func
}

main
clear
source ${scripts_dir}/menu-hacking.sh
exit 0
