#!/bin/bash
# set a variable for handshakes directory so it can be changed in program
# Version: 0.0.2
handshakes_dir=/opt/backup/root/handshakes
scripts_dir=/opt/easy-linux
backup_dir=/opt/backup
set -e
# Add Color
source ${scripts_dir}/.envrc
#
trap "source ${scripts_dir}/support/support-trap-wifi.sh" EXIT

allcaps=$(locate *.cap > ${scripts_dir}/support/misc/allcaps.list)
allpcaps=$(locate *.pcap > ${scripts_dir}/support/misc/allpcaps.list)
allhcx=$(locate *.hcxcapx > ${scripts_dir}/support/misc/allhcx.list)
cat $allcaps >> ${scripts_dir}/support/misc/backup-list.list
cat $allpcap >> ${scripts_dir}/support/misc/backup-list.list
cat $allhcx >> ${scripts_dir}/support/misc/backup-list.list

upload_func() {
        if [[ $(find ${handshakes_dir} -maxdepth 1 \( -name '*.cap' -o -name '*.pcap' -o -name '*.pcap-ng' \) -type f -print -quit | grep -q '.') ]]; then
                printf " ${GN} [X] ${CY}Gzip is not supported on ${WT}OnlineHashCrack.\\n ${GN} [X] ${CY}Not compressing files. \\n ${GN} [*] ${CY}Uploading pcap's to OHC.${OG}\\n"
                wlancap2wpasec -u https://api.onlinehashcrack.com -e $pro_email ${handshakes_dir}/*.pcap
                printf " ${GN} [*] ${CY}Send all cap's to OHC.${OG}\\n"
                wlancap2wpasec -u https://api.onlinehashcrack.com -e $pro_email ${handshakes_dir}/*.cap
                if [[ $(find ${handshakes_dir} -maxdepth 1 -name '*.pcap' -type f -print -quit | grep -q '.') ]]; then
                        printf " ${GN} [*] ${WT}Compress all PCAP files.\\n ${GN} [*] ${CY} Uploading to ${WT}WPA-Stanev${OG}.\\n"
                        gzip -r ${handshakes_dir}/*.pcap
                fi
                if [[ $(find ${handshakes_dir} -maxdepth 1 -name '*.cap' -type f -print -quit | grep -q '.') ]]; then
                        printf " ${GN} [*] ${WT}Compress all and CAP files.\\n ${GN} [*] ${CY} Uploading to ${WT}WPA-Stanev${OG}.\\n"
                        gzip -r ${handshakes_dir}/*.cap
                fi
        fi
        if [[ $(find ${handshakes_dir} -maxdepth 1 -name '*.gz' -type f -print -quit | grep -q '.') ]]; then
                printf " ${GN} [*] ${CY}Send all compressed ${WT}pcap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
                wlancap2wpasec -k $wpa_api -t 45 -R \
                        ${handshakes_dir}/*.pcap.gz
                printf " ${GN} [*] ${CY}Send all compressed ${WT}cap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
                wlancap2wpasec -k $wpa_api -t 45 \
                        ${handshakes_dir}/*.cap.gz
        fi
        printf " ${GN} [X] ${WT}Gzip ${CY}is not supported on ${WT}OnlineHashCrack${CY}.\\n ${GN} [*] ${CY}Uploading ${WT}hccapx ${CY}files to ${WT}OHC.${OG}\\n"

        if [[ $(find ${backup_dir}/root/hccapx -maxdepth 1 -name '*.hccapx' -type f -print -quit | grep -q '.') ]]; then
                wlancap2wpasec -u https://api.onlinehashcrack.com -e $pro_email \
                        ${backup_dir}/root/hccapx/*.hccapx
                printf " ${GN} [X] ${CY}HCCAPX isn't supported on WPA-Stanev.\\n"
        fi
        clear
}

permissions_func() {
        # make sure permissions are ok.
        if [[ $HOST == "$cwb_computername" && $USER == "$cwb_username" ]]; then
                pwnagotchi=Gotcha
                sudo sed -i "s/pwnagotchi.*/pwnagotchi=${pwnagotchi}/g" ${scripts_dir}/.envrc
                sudo chown -vR $cwb_username:0 ${backup_dir}/root/
        elif [[ $HOST == "$ldb_computername" && $USER == "$ldb_username" ]]; then
                pwnagotchi=Sniffer
                sed -i "s/pwnagotchi.*/pwnagotchi=${pwnagotchi}/g" ${scripts_dir}/.envrc
                sudo chown -vR $ldb_username:0 ${backup_dir}/root/
        else
                sudo chown -vR root:root ${backup_dir}/root/*
        fi
        upload_func
}

folders_exist_func() {
        # make sure /opt/backup/root exists
        if [[ ! -d ${backup_dir} ]]; then
                sudo mkdir ${backup_dir}
        fi
        if [[ ! -d ${backup_dir}/root/ ]]; then
                sudo mkdir ${backup_dir}/root/
        fi
        if [[ ! -d "${handshakes_dir}" ]]; then
                sudo mkdir ${handshakes_dir}
        fi
        permissions_func
}

main() {
        clear
        source "${scripts_dir}/support/support-Banner_func.sh"
        printf "  ${CY}This script uploads your saved hashes from ${WT}$handshakes_dir${CY}\\n"
        printf "  to ${WT}Onlinehashcrack.com ${CY}and ${WT}www.wpa-stanev.org${CY}.\\n${NC} "
        echo
        printf "  ${OG}Press ${WT}any ${OG}key to continue.\\n${NC}  "
        read -n 1 -r -t 300
        folders_exist_func
}

main
clear
source ${scripts_dir}/support/support-Banner_func.sh
printf "${CY}All Operations completed. Cracked passwords will start appearing on \\n"
printf "${WT}https://www.OnlineHashCrack.com ${CY}and ${WT}https://wpa-sec.stanev.org ${CY}within 24hr.\\n"
printf "Press ${WT}any${CY} key to return to ${WT}Main Menu${CY}.\\n "
read -n 1 -r -t 300
source ${scripts_dir}/menu-master.sh
