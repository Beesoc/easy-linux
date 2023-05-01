#!/bin/bash
# set a variable for handshakes directory so it can be changed in program
handshakes_dir=/opt/backup/root/handshakes
set -e
# Add Color
source .envrc
#
trap support/support-trap-wifi.sh EXIT
source support/support-Banner_func.sh
#printf "This script backs up your saved hashes from /opt/backup/root/handshakes." 

permissions_func() {
# make sure permissions are ok.
if [[ $HOST == "updates" ]]; then 
   sudo chown -vR beesoc:beesoc /opt/backup/root/*
elif [[ $HOST == "lepotato" ]]; then 
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
printf "${CY}Gzip is not supported on ${WT}OnlineHashCrack.  ${CY}Not compressing files. \\n ${CY}Uploading pcap's to OHC.${OG}\\n"
wlancap2wpasec -u https://api.onlinehashcrack.com  -e enc.mail.prot@protonmail.com /opt/backup/root/handshakes/*.pcap
printf "${CY}Send all cap's to OHC.${OG}\\n"
wlancap2wpasec -u https://api.onlinehashcrack.com  -e enc.mail.prot@protonmail.com /opt/backup/root/handshakes/*.cap
printf "${WT}Compress all PCAP and CAP files ${CY}before uploading to ${WT}WPA-Stanev${OG}.\\n"
gzip -v -9 --synchronous /opt/backup/root/handshakes/*.pcap
gzip -v -9 --synchronous /opt/backup/root/handshakes/*.cap
printf "${CY}Send all compressed ${WT}pcap's${CY} to ${WT}WPA-Stanev${CY}.  ${GN}Remove successful uploads.${OG}\\n"
wlancap2wpasec -k ac160b3ccfff2f1d93f5a0ff443061bf -t 45  -R \
/opt/backup/root/handshakes/*.pcap.gz
printf "${CY}Send all compressed ${WT}cap's${CY} to ${WT}WPA-Stanev${CY}.  ${GN}Remove successful uploads.${OG}\\n"
wlancap2wpasec -k ac160b3ccfff2f1d93f5a0ff443061bf -t 45 \
/opt/backup/root/handshakes/*.cap.gz
printf "${WT}Gzip ${CY}is not supported on ${WT}OnlineHashCrack${CY}.  Uploading ${WT}hccapx ${CY}files to ${WT}OHC.${OG}\\n"
wlancap2wpasec -u https://api.onlinehashcrack.com  -e enc.mail.prot@protonmail.com \
/opt/backup/root/hccapx/*.hccapx
printf "${CY}HCCAPX isn't supported on WPA-Stanev.\\n"
printf "${CY}Upload complete.  Press ${WT}any${CY} key to return to ${WT}Main Menu\\n"
  read -r -n1 -s -t 30
clear
}
main() {
clear
source support/support-Banner_func.sh
folders_exist_func
permissions_func
upload_func
}
main
clear
printf "${CY}All Operations completed. Cracked passwords will start appearing on \\n"
printf "https://www.OnlineHashCrack.com and https://wpa-sec.stanev.org within 24hr."
printf "Press ${WT}any${CY} key to return to ${WT}Main Menu.\\n "
  read -r -n1 -s -t 30
bash menu-master.sh