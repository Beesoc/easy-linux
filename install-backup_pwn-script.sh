#!/bin/bash
# Pwnagotchi backup and restore script
#
# TODO: Get Mikes laptop hostname and FuckThatSh1t Mac address for this script
#
set -euo pipefail

#################################################  Begin User Options  #########
set -e

FuckThatSh1t_mac="33:33:33:33:33:33"
mike_host=TODO
###################################################  End User Options  #########
 
source=
options=("Backup" "Restore" "Maintenance" "Main Menu" "Exit")

mac_address=$(ip address show usb0 | grep -oE '(([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}){1}' | head -n 1)
# $(ifconfig usb0 | grep -oE '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}')
printf "${CY}"

Prompt_func() {
    prompt_symbol=㉿
    prompt_color=${GN}
    info_color=${BL}
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
#        prompt_color='\[\033[;94m\]'
        prompt_color=${GN}
        info_color=${RED}
        # Skull emoji for root terminal
        prompt_symbol=💀
    fi

printf "${GN}┌──(${CY}$USER${prompt_symbol}$HOSTNAME${GN})-[${YW}${PWD}${GN}]\\n"
printf "${GN}└─"${CY}"> ${CY}\\n"
}

Banner_func() {
  printf "${WT}\\n
${OGH}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${OGG}${RED}
    ▄████▄${BK}╗    ${RED}▄████▄${BK}╗   ${RED}▄████▄${BK}╗    ${RED}▄████▄${BK}╗     ${RED}▄███▄${BK}╗     ${RED}▄███▄${BK}╗  ${RED}██${BK}╗  ${RED}▄████▄${BK}╗  ${OG}  
    ██${BK}═══${OG}██${BK}╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔════╝    ${OG}██${BK}╔══${OG}██${BK}╗   ${OG}██${BK}╔══${OG}▀${BK}╝   ${OG}▀${BK}╝ ${OG}██${BK}╔════╝${OG}    
    ██████${BK}╝    ${OG}█████${BK}╗    ${OG}█████${BK}╗     ${OG}▀████▄${BK}╗    ${OG}██${BK}║  ${OG}██${BK}║   ${OG}██${BK}║           ${OG}▀████▄${BK}╗${OG}    
    ██${BK}═══${OG}██    ${OG}██${BK}╔══╝${OG}    ██${BK}╔══╝      ╚═══${OG}██${BK}║   ${OG}██${BK}║  ${OG}██${BK}╝   ${OG}██${BK}║  ${OG}▄${BK}╗        ╚═══${OG}██${BK}║ ${OGF}  
    ▀████▀${BK}╝    ${OGF}▀████▀${BK}╗   ${OGF}▀████▀${BK}╗    ${OGF}▀████▀${BK}╝     ${OGF}▀███▀${BK}╝${OGF}     ▀███▀${BK}╝"${OGF}"       ▀████▀${BK}╝   ${BK} 
     ╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝      ${OGG}
    ▄████▄${BK}╗   ${OGG}▄█▄${BK}╗    ${OGG}▄███▄${BK}╗ ${OGG}█▄${BK}╗   ${OGG}▄█${BK}╗   ${OGG}▄█${BK}╗    ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗  ${OGG}█▄${BK}╗ ${OGG}▄█${BK}╗  ${OGG}▄█${BK}╗ ${OGG}██▄${BK}╗  ${OGG}▄██${BK}╗ ${GN}  
    ██${BK}╔═══╝  ${GN}██${BK}║${GN}██${BK}╗  ${GN}██${BK}╔═══╝  ${GN}██${BK}╗ ${GN}██${BK}╔╝   ${GN}██${BK}║    ${GN}██${BK}║ "${GN}"██▄${BK}╗ ${GN}██${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▀██▄██▀${BK}╝${GN}    
    █████${BK}╗  ${GN}███▀███${BK}╗  ${GN}▀███▄${BK}╗   ${GN}████${BK}╔╝    ${GN}██${BK}║    ${GN}██${BK}║ ${GN}████▄██${BK}║ "${GN}"██${BK}║  ${GN}██${BK}║    ${GN}███${BK}║${GN}      
    ██${BK}╔══╝  ${GN}██${BK}║  ${GN}██${BK}║   ╚══${GN}██${BK}║   ${GN}██${BK}╔╝     ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██${BK}║${GN}▀███${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▄██▀██▄${BK}╗    ${WT}
    ▀████▀${BK}╝ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝    ${WT}██${BK}║      ${WT}▀████${BK}╗ ${WT}██${BK}║ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝  ${WT}██▀${BK}╝  ${WT}▀██${BK}╗   ${BK}
     ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝   ${OGH}
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄\\n"
printf "${NC}${CY}"
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
  #
}
pwnagotchi=""

select_pwn_func() {
# display a list of pwnagotchis
pwnagotchi_mac=""
pwnagotchi_host=""

if [[ ${mac_address} == "${gotcha_mac}" ]]; then
    # Gotcha is connected, run backup for Gotcha
    pwnagotchi_mac="Gotcha"
elif [[ ${mac_address} == "${sniffer_mac}" ]]; then
    # Sniffer is connected, run backup for Sniffer
    pwnagotchi_mac="Sniffer"
elif [[ ${mac_address} == "${FuckThatSh1t_mac}" ]]; then
    # FuckThatSh1t is connected, run backup for FuckThatSh1t
    pwnagotchi_mac="FuckThatSh1t"
fi

if [[ ${USER} == "beesoc" ]]; then
    # Gotcha is connected, run backup for Gotcha
    pwnagotchi_mac="Gotcha"
  elif [[ ${USER} == "larry" ]]; then
    # Sniffer is connected, run backup for Sniffer
    pwnagotchi_mac="Sniffer"
  else 
    # FuckThatSh1t is connected, run backup for FuckThatSh1t
    pwnagotchi_mac="FuckThatSh1t"
fi

if [[ $(hostname) = ${cory_host} ]]; then
   pwnagotchi_host=Gotcha
  elif [[ $(hostname) = ${larry_host} ]]; then
   pwnagotchi_host=Sniffer
  elif [[ $(hostname) = ${mike_host} ]]; then
   pwnagotchi_host=FuckThatSh1t
  else
    printf "\\n${CY}Unable to determine Pwnagotchi.automatically.  Press ${WT}any ${CY}key to override.\\n"
              read -r -n1 -s -t 60  
    # Unknown device connected, Override or setup new 
              read -p "What is the name of the Pwnagotchi you want to work on?" pwnagotchi
              printf "${CY}    You entered ${WT}${pwnagotchi}${CY}.  Press ${WT}any ${CY}key to continue\\n"
                     read -r -n1 -s -t 30  
fi
printf  "Your info:  $USER working on ${pwnagotchi}, plugged into $hostname.\\n"
}
#if [[ ${pwnagotchi_mac} != ${pwnagotchi_host} ]]; then
#    printf "${RED} [!!!] Automatic Pwnagotchi detection failed! Fatal Error.\\n "
#    printf "${RED}  To debug, see files in support folder: pwnagotchi_mac & pwnagotchi_host to see what \\n"
#    printf "  I determined values to be.  Press ${WT}any ${RED}key to exit [!!!]\\n"
#    echo $pwnagotchi_mac > ./support/pwnagotchi_mac
#    echo $pwnagotchi_host > ./support/pwnagotchi_host
#  exit 1
#fi
#}
ssh_func() {
# function to control SSH options.  check for key, create key, copy key to pwn.
clear
Banner_func
ssh-keygen -f "/home/beesoc/.ssh/known_hosts" -R "10.0.0.2"
  if [[ ! -e $HOME/.ssh/id_rsa.pub ]]; then
    printf "${YW}No Personal SSH key was not found.  Checking for key for Root user\\n  "
  elif [[ ! -e /root/.ssh/id_rsa.pub ]]; then
    printf "${YW}SSH key was not found.  Press ${WT}any ${YW}key to generate keys.  ${GN}Accept the default suggestions.\\n  "
        read -r -n1 -s -t 60
        ssh-keygen
  elif
    [[ -e ~/.ssh/id_rsa.pub ]]; then
      printf "${CY}SSH key was found.  Proceeding.\\n"
  else
      printf "Invalid selection, try again."
  fi
  printf "  ${CY}Now I'll copy SSH key to Pwnagotchi. Password is ${WT}'[uB2Aj3j'$'HcgNWP]'${CY}.\\n"
  printf "  If new, password is ${WT}[raspberry]${CY}.\\n" 
  printf "  You may be prompted to accept fingerprint next & will be asked for $(WT)${pwnagotchi} ${CY}password. \
  Press ${WT}any ${CY}key to continue.\\n"
        read -r -n1 -s -t 60
    ssh-copy-id -p 22 -i ~/.ssh/id_rsa.pub pi@10.0.0.2  
    sudo ssh-copy-id -p 22 -i /root/.ssh/id_rsa.pub pi@10.0.0.2  
  ssh -p 22 pi@10.0.0.2
}
udev_func() {
if [[ ! -e /etc/udev/rules.d/99-backup-rule.rules ]]; then
 sudo echo \"ACTION=="add", SUBSYSTEM=="net", "ENV{ID_NET_NAME}"=="usb*", ENV"{MAC_ADDRESS}"=="${gotcha_mac}|${sniffer_mac}|${FuckThatSh1t_mac}", RUN+="/bin/bash ${scripts_dir}/install-backup-pwn-script.sh" > /etc/udev/rules.d/99-backup-rule.rules
 sudo udevadm control --reload-rules

 fi
if [[ -e /etc/udev/rules.d/99-backup-rule.rules ]]; then
  printf "Its there.  yeah."
fi 
}
backup_func() {

# Backup files from backup server to remote computers

printf "\\n  ${CY}You are about to backup ${WT}${pwnagotchi}:\\n"
  printf "  ${CY}Common files [all Pwnagotchis share them]: ${OG}\\n"

    rsync -avz --rsync-path="sudo rsync" -e ssh --update --human-readable --mkpath --super --sparse --itemize-changes --executability --copy-links --progress --verbose --relative --exclude=".cache" --exclude=".thumbnails" --exclude=".local/share/Trash" pi@10.0.0.2:/home	 pi@10.0.0.2:/etc/pwnagotchi    pi@10.0.0.2:/root/ 	         pi@10.0.0.2:/root/handshakes    pi@10.0.0.2:/etc/ssh/        pi@10.0.0.2:/etc/nanorc        pi@10.0.0.2:/etc/logrotate   pi@10.0.0.2:/etc/sysctl.conf    pi@10.0.0.2:/usr/local/share/bettercap/caplets              pi@10.0.0.2:/etc/rc.local    pi@10.0.0.2:/etc/motd           pi@10.0.0.2:/etc/timezone    pi@10.0.0.2:/etc/wgetrc        "${backup_dir}/test"

  printf " ${CY} Files unique to ${WT}${pwnagotchi}:${CY}.${OG}\\n"
	rsync -avz --rsync-path="sudo rsync" -e ssh --update --human-readable --mkpath --super --sparse --itemize-changes \
	--executability --copy-links --progress --verbose --relative --exclude=".cache" --exclude=".thumbnails" \
	--exclude=".local/share/Trash" \
	pi@10.0.0.2:/boot/cmdline.txt        pi@10.0.0.2:/etc/pwnagotchi/fingerprint \
	pi@10.0.0.2:/etc/pwnagotchi/id_rsa   pi@10.0.0.2:/etc/pwnagotchi/id_rsa.pub \
	pi@10.0.0.2:/var/log/pwnagotchi.log  pi@10.0.0.2:/etc/hostname                 pi@10.0.0.2:/etc/hosts \
	pi@10.0.0.2:/etc/shadow              pi@10.0.0.2:/etc/network                  pi@10.0.0.2:/etc/passwd \
	"${backup_dir}/test/${pwnagotchi}"

    sudo chown -vR 1000:1000 /opt/backup
    printf "    Your Pwnagotchi is backed up!\\n "
    
}
restore_func() {
# Restore files from backup server to remote computers

printf "\\n  ${CY}You are about to restore ${WT}${pwnagotchi}:\\n"
  printf "  ${CY}Common files [all Pwnagotchis share them]: ${OG}\\n"


#!/bin/bash

# Define the backup directory where the files were saved
backup_dir="/opt/backup/test"

# Restore files to their original locations
rsync -avz --rsync-path="sudo rsync" -e ssh --human-readable --mkpath --super --sparse \
--itemize-changes --executability --copy-links --progress --verbose --relative \
"${backup_dir}/home/" pi@10.0.0.2:/ \
"${backup_dir}/pwnagotchi/" pi@10.0.0.2:/etc/ \
"${backup_dir}/root/" pi@10.0.0.2:/ \
"${backup_dir}/handshakes/" pi@10.0.0.2:/root/ \
"${backup_dir}/ssh/" pi@10.0.0.2:/etc/ \
"${backup_dir}/nanorc/" pi@10.0.0.2:/etc/ \
"${backup_dir}/logrotate/" pi@10.0.0.2:/etc/ \
"${backup_dir}/sysctl.conf/" pi@10.0.0.2:/etc/ \
"${backup_dir}/caplets/" pi@10.0.0.2:/usr/local/share/bettercap/ \
"${backup_dir}/rc.local/" pi@10.0.0.2:/etc/ \
"${backup_dir}/motd/" pi@10.0.0.2:/etc/ \
"${backup_dir}/timezone/" pi@10.0.0.2:/etc/ \
"${backup_dir}/wgetrc/" pi@10.0.0.2:/etc/

# Restore unique files to their original locations
rsync -avz --rsync-path="sudo rsync" -e ssh --human-readable --mkpath --super --sparse \
--itemize-changes --executability --copy-links --progress --verbose --relative \
"${backup_dir}/cmdline.txt" pi@10.0.0.2:/boot/ \
"${backup_dir}/fingerprint" pi@10.0.0.2:/etc/pwnagotchi/ \
"${backup_dir}/id_rsa" pi@10.0.0.2:/etc/pwnagotchi/ \
"${backup_dir}/id_rsa.pub" pi@10.0.0.2:/etc/pwnagotchi/ \
"${backup_dir}/pwnagotchi.log" pi@10.0.0.2:/var/log/ \
"${backup_dir}/hostname" pi@10.0.0.2:/etc/ \
"${backup_dir}/hosts" pi@10.0.0.2:/etc/ \
"${backup_dir}/shadow" pi@10.0.0.2:/etc/ \
"${backup_dir}/network" pi@10.0.0.2:/etc/ \
"${backup_dir}/passwd" pi@10.0.0.2:/etc/


}
#
main() {
clear
Banner_func
Prompt_func
printf " ${OG}\\n                 Welcome to the Pwnagotchi hub\\n"
select_pwn_func

select option in "${options[@]}"; do
    case ${option} in
        "Backup")
            clear
            Banner_func
printf " ${OG}\\nWelcome to the Pwnagotchi hub\\n"
            printf "You selected Backup\\n"
            if [[ ${pwnagotchi} == "" ]]; then
                select_pwn_func
            else
                printf "${pwnagotchi}: Proceeding"
            fi
            ssh_func
			backup_func
            udev_func
            break
            ;;
        "Restore")
            clear
            Banner_func
printf " ${OG}\\nWelcome to the Pwnagotchi hub\\n"
            printf "You selected Restore\\n"
            if [[ ${pwnagotchi} == "" ]]; then
                select_pwn_func
            else
                printf "${pwnagotchi}: Proceeding"
            fi            
            ssh_func
			restore_func
            udev_func
            break
            ;;
        "Maintenance")
            clear
            Banner_func
            printf " ${OG}\\nWelcome to the Pwnagotchi hub\\n"
            printf "${GN}You selected Maintenance\\n"
            if [[ ${pwnagotchi} == "" ]]; then
                select_pwn_func
            else
                printf "${pwnagotchi}: Proceeding"
            fi
            ssh_func
			maint_func
            udev_func
            break
            ;;
         "Main Menu")
            clear
			bash ${scripts_dir}/install-master.sh
			break
            printf "${OG}You selected Main Menu\\n${CY}"
            ;;
          "Exit")
          clear
            printf "${RED}You selected Exit${OG}\\n"
			exit 1
            ;;
        *)
            printf"${RED}Invalid option\\n${CY}"
            ;;
    esac
done
}
main
