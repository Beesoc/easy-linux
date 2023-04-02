#!/bin/bash
#
#   Beesoc - Mar 22, 2023
#
#   Beesoc's Easy Linux Loader.  This is my big script of everything.  I plan to keep 
# updating this script with new features and various goodness regularly.  
#   1) The initial version will backup any of the 3 Pwnagotchi's that I regularly have access to. 
#   2) Will update/upgrade all packages on the Linux system that it is ran on.
#   3) Will provide option to install several packages I consider "must-have".
#   4) Will copy several wordlists the machine that runs it to /usr/share/wordlists.
#
# TODO: move this script to Github.

#use error trapping and exit if there is an error
set -e
set -u
#
#export PS4="\$LINENO: "
#set -xv
RED='\e[1;31m'
GN='\e[1;32m'
YW='\e[1;33m'
BL='\e[1;34m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
LB='\e[0;34m'
NC='\e[0m'
#
backup_dir=/opt/backup/
# Dont change this pwn_choice field.  part of the logic of this script will change it.
pwn_choice=FuckThatSh1t
scripts_dir=${HOME}/scripts
pwn_override=./support/pwn_override
#
sshfile="${HOME}/.ssh/id_rsa.pub"
HN=${HOSTNAME}
#
Prompt_func() {
  printf " \\n"
  printf "  ${GN}┌──(${BL}$USER㉿$HOSTNAME${GN})-[${WT}$(pwd)${BL}${GN}]\\n "
  printf " ${GN}L${BL}$ ${OG}"
#  printf " \\n "
}
#
Banner_func() {
  printf "${WT}\\n
-------------------------------------------------------------------------------${CY}
  ▄████▄╗    ▄████▄╗   ▄████▄╗    ▄████▄╗     ▄███▄╗     ▄███▄╗  ██╗  ▄████▄╗  
  ██═══██╝   ██╔═══╝   ██╔═══╝   ██╔════╝    ██╔══██╗   ██╔══▀╝   ▀╝ ██╔════╝  
  ██████╝    █████╗    █████╗     ▀████▄╗    ██║  ██║   ██║           ▀████▄╗  
  ██═══██    ██╔══╝    ██╔══╝      ╚═══██║   ██║  ██╝   ██║  ▄╗        ╚═══██║ 
  ▀████▀╝    ▀████▀╗   ▀████▀╗    ▀████▀╝     ▀███▀╝     ▀███▀╝       ▀████▀╝  
   ╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝
  ▄████▄╗   ▄█▄╗    ▄███▄╗ █▄╗   ▄█╗   ▄█╗    ▄█╗ ▄█╗  █▄╗ ▄█╗  ▄█╗ ██▄╗  ▄██╗ 
  ██╔═══╝  ██║██╗  ██╔═══╝  ██╗ ██╔╝   ██║    ██║ ██▄╗ ██║ ██║  ██║  ▀██▄██▀╝  
  █████╗  ███▀███╗  ▀███▄╗   ████╔╝    ██║    ██║ ████▄██║ ██║  ██║    ███║    
  ██╔══╝  ██║  ██║   ╚══██║   ██╔╝     ██║    ██║ ██║▀███║ ██║  ██║  ▄██▀██▄╗  
  ▀████▀╝ ██║  ██║  ▀███▀╝    ██║      ▀████╗ ██║ ██║  ██║  ▀███▀╝  ██▀╝  ▀██╗ 
   ╚═══╝  ╚═╝  ╚═╝   ╚═╝      ╚═╝       ╚═══╝ ╚═╝ ╚═╝  ╚═╝   ╚═╝    ╚═╝    ╚═╝ ${WT}
------------------------------------------------------------------------------- \\n"
  #
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
}
#
#
pwn_choice_func() {
          printf "   ${YW}[!] If you regenerate keys, you may lose access to any previously connected servers.${NC} \\n "
          printf "   ${GN}[✔]  ${WT}[recommended]${GN}  [✔] ${GN}Using existing keys. Press ${WT}any key${OG} to continue. ${NC}\\n"
   pwn_choice=FuckThatSh1t      
if [[ ${HN} == "Updates" ]] || [[ ${HN} == "updates" ]]; then
   pwn_choice=Gotcha
   printf "   ${WT}[*] ${USER},${OG} you have selected${WT} ${pwn_choice}.  ${OG}Working... \\n"
   printf "    Here is a fake backup placeholder.${OG} \\n"
fi
if [[ ${HN} == "Larry" ]] || [[ ${HN} == "larry" ]]; then
   pwn_choice=Sniffer
   printf "   ${WT}[*] ${USER},${OG} you have selected${WT} ${pwn_choice}${OG}.  ${WT}Working...${OG}\\n"
   printf "    ${CY}Here is a fake restore placeholder.${OG} \\n"
fi
if [[ -f "${pwn_override}" ]]; then
   printf "   ${OG}[?] You have overriden the default choice. ${YW}Proceeding with ${pwn_override}. ${NC} \\n"
   pwn_choice=${pwn_override}
   rm ${pwn_override}
fi
}
override_func() {
            printf "${OG}"
            printf "${BL}- "
            clear  
        Banner_func
        printf "Override Selected: What Pwnagotchi are you working on?${BL}     \\n"
        read -r "Name of Pwnagotchi" pwn_override_choice
        echo "${pwn_override_choice}" > $pwn_override
            printf "    \\n"
            printf "    \\n"
            pwn_choice=${pwn_override}
   rm ${pwn_override}
}
#  check if ssh keys exists
ssh_func() {
        printf "   [-] ${YW}Logging in with passwords ${WT}suck.${YW}  So we are going to automatically log in to ${WT}${pwn_choice}${OG}\\n "
        printf "with ${WT}secure, encrypted SSH keys${OG}. I will look for your key now and generate \n " 
        printf "new ones if you dont have any. ${WT}Default location is ${BL}${HOME}/.ssh/id_rsa.pub. ${OG} \n "  
        printf "${OG}   To log in to ${WT}${pwn_choice}${OG}, we will generate SSH keys and use them instead of passwords.\\n"
        printf "   ${OG}[*] Checking for SSH keys...\\n"

        if [[ -e "${sshfile}" ]]; then
          printf "   ${OG}[?] SSH Keys already exist. ${YW}We will use these pre-existing keys. ${NC} \\n"
 #         printf "   ${YW}[!] If you regenerate keys, you may lose access to any previously connected servers.${NC} \\n "
 #         printf "   ${GN}[✔]  ${WT}[recommended]${GN}  [✔] ${GN}Using existing keys. Press ${WT}any key${OG} to continue. ${NC}\\n"
        else
          printf "${OG}SSH Keys ${WT}NOT${OG} found. Generating new keys for $USER and root...${NC}"
          printf "TESTING.  generating keys...blah....blah...."
#    ssh-keygen -t rsa -N "" -f "${HOME}/.ssh/id_rsa" -y
#    sudo ssh-keygen -t rsa -N "" -f "/root/.ssh/id_rsa" -y
        fi
      printf "${OG}Now we will login to ${pwn_choice} with our SSH key. ${YW}NOTE: ${OG}you will be prompted for your password the 1st time you connect.  No more passwords after that! ${NC} \n"
      printf "TESTING  copying ssh key to pwnagotchi...blah...blah"
      printf "ssh-copy-id -i "${HOME}/.ssh/id_rsa.pub" pi@10.0.0.2"  
sleep 5       
            ssh-copy-id -i "${HOME}/.ssh/id_rsa.pub" pi@10.0.0.2   
printf "sudo ssh-copy-id -i "/root/.ssh/id_rsa.pub" pi@10.0.0.2"
sleep 5
            sudo ssh-copy-id -i "/root/.ssh/id_rsa.pub" pi@10.0.0.2       
}
ssh_connect_func() {
clear
ssh pi@10.0.0.2
}

backup_pwn_func() {
  printf "${OG}      You have selected to ${WT}Backup ${pwn_choice}${OG}."
  printf "${OG}       Your backup will be saved to ${WT}${backup_dir}${OG}."
}

restore_pwn_func() {
  printf "${OG}      You have selected to ${WT}Restore ${pwn_choice}${OG}."
  printf "${OG}      Your restore will be pulled from ${WT}${backup_dir}${OG}."
}

pwn_maint_func() {
  printf "${OG}      You have selected Pwnagotchi ${WT}Maintenance for  ${pwn_choice}${OG}."
  printf "${OG}      TODO: Build this menu.  Rename${OG}."
}

pwn_trouble_func () {
            Banner_func
            printf "${BL}                       Trouble with ${WT}${pwn_choice} ${NC}\\n"
              printf "   \\n"
              printf "   \\n"
              printf "                ${RED}[!] Oh noes.  You haz errors [!]${LB} \\n "
              printf "   \\n"
              printf "                          ${YW}Dont Panic.${LB} \\n"
              printf "   \\n"
              printf "   Here are a few things to try.  Good luck. \\n"
              printf "   \\n"
              printf "   ${WT}${pwn_choice}${LB} will usually be listed as usb0 on your linux \\n"
    printf "  computer. \\n" 
              printf "     ${YW}NOTE:${LB} When using a USB wifi adapter, ${WT}${pwn_choice}${LB} may be usb1. \\n"
              printf "   \\n"
              printf "   If no usb0 device is listed, unplug and replug the USB cable into ${WT}${pwn_choice}${LB}. \\n"
              printf "   \\n"
              printf "   Use the linux terminal command [lsusb] to see every USB device currently       \\n"
    printf "  seen by Linux.  If you cant see ${WT}${pwn_choice}${LB} there, you will not               \\n"
    printf "  be able to access him or his data anywhere. \\n "
              printf "   \\n"   
              printf "   The biggest problem Ive seen with ${WT}${pwn_choice}${LB} is cheap USB cables. \\n "
    printf "  Cheap cables are frequently power only so you will not be able to SSH to ${WT}${pwn_choice}${LB}. \\n"
              printf "   \\n"
              printf "   Make sure that the cable is inserted into the correct USB port on Raspberry Pi. \\n"
    printf "  [Pi has 2 MicroUSB plugs. The USB port that is almost in the middle of the Pi is the data  \\n"
    printf "  port. The other port is for power only.You can ONLY use the data port if you wanto to SSH  \\n" 
    printf "  to the Pi or connect it to the internet. The device can ONLY run in auto mode when plugged \\n"
    printf "  into the power port.  It can be booted into manual mode, which then allows Bettercap to    \\n"
    printf "  run and SSH access to the device.\\n"
              exit 1
 }
#
printf "${LB}"
clear
#    
# Set the screen background to BL
printf "${LB}"
    pwn_choice_func
  clear
    Banner_func
      printf "${OG}         ${GN}${pwn_choice}${OG}          Welcome to the Pwnagotchi Hub!${GN}          ${pwn_choice}${OG}\\n"
      printf "   \\n"
      printf "${WT}  [*]${OG}  Machine Name: ${WT}${HN}${OG}.            ${WT}[*]${OG}  Username: ${WT}${USER}${OG}.\\n"
      printf "${WT}  [*]${OG}  Pwnagotchi is ${WT}${pwn_choice}${OG}              ${WT}[*]${OG}  Home Folder: ${WT}${HOME}${OG}.\\n"
      printf "${WT}  [*]${OG}  Backup directory is ${WT}${backup_dir}${OG}."
        printf "   \\n"
        printf "   \\n"
        printf "  ${CY}Choose${RED}                         [✘]  Press [ctrl+c] at any time to cancel [✘]${BL}\\n"
        printf "   \\n"     
        printf "  ${WT}[C]${OG}ontinue to the Backup, Restore and Maintenance screen\\n"
        printf "  ${WT}[P]${OG}wnagotchi to connect to your Pwnagotchi over SSH, or \\n"
        printf "   \\n"     
        printf "  ${WT}[99]${OG} return to the Main [Beesoc's Easy Linux] menu.${OG} \\n  " 
    Prompt_func
    read -r c_or_menu
          if [[ ${c_or_menu} = "99" ]]; then
    bash "${scripts_dir}"/install-master.sh
          fi
          if [[ ${c_or_menu} = "C" ]] || [[ ${c_or_menu} = "c" ]]; then
            clear
          fi
          if [[ ${c_or_menu} = "P" ]] || [[ ${c_or_menu} = "p" ]]; then
            ssh_connect_func
          fi
          if [[ ${c_or_menu} = "?" ]]; then
            override_func
          else
            "Invalid Selection"
          fi
        printf "   \\n"     
        printf "   \\n"     
        printf "   \\n"     
   clear
   Banner_func
          printf "   \\n"     
          printf "     1]  If ${WT}${pwn_choice}${GN} CAN${OG} be seen, select option 1 to continue.${OG} \\n"
          printf "     2]  If ${WT}${pwn_choice}${RED} CAN NOT${OG} be seen, select option 2 for help.${RED}${OG} \\n"
          printf "   \\n"     
          printf "     3]  To override the ${WT}default Pwnagotchi${OG} of ${WT}${pwn_choice}, enter ${WT}[?]${OG}\\n"
          printf "   \\n"     
          printf "     ${BL}Is your Linux PC able to see ${WT}${pwn_choice}?${OG}\\n"
          printf "   \\n   "
        read -r -p "Select 1 to continue or 2 for help" pwn_trouble
        printf "      ${GN} \\n"     
        clear
        Banner_func
        if [[ ${pwn_trouble} == 1 ]]; then
              printf "${BL}"
              printf "${GN}- "
              printf "    Awesomesauce."   
        fi
        if [[ ${pwn_trouble} == 2 ]]; then
            printf "${OG}"
            printf "${BL}- "
            clear  
            printf "    \\n"
            printf "    \\n"
            pwn_trouble_func
        fi
        if [[ ${pwn_trouble} == "?" ]]; then
            override_func
        fi
#
         printf "${OG}[?] Would you like ${WT}(B)${OG}ackup, ${WT}(R)${OG}estore or ${WT}(M)${OG}aintenance ${WT}${pwn_choice}? [B] or [R] or [M]:${OG}\\n"
            read -r inputpwn 
         if [[ ${inputpwn} == "b" ]] || [[ ${inputpwn} == "B" ]]; then
            printf "   ${WT}[*] ${pwn_choice},${OG} you have selected to backup ${WT}${pwn_choice}.${OG} Working...\\n"
            backup_pwn_func
            printf "    Here is a fake backup placeholder. \\n"
         fi
         if [[ ${inputpwn} == "r" ]] || [[ ${inputpwn} == "R" ]]; then
            printf "   ${WT}[*] ${pwn_choice},${OG} you have selected to restore ${WT}${pwn_choice}.${OG} Working...\\n"
            restore_pwn_func
            printf "    Here is a fake restore placeholder.\\n"
         fi
         if [[ ${inputpwn} == "m" ]] || [[ ${inputpwn} == "M" ]]; then
            printf "   ${WT}[*] ${pwn_choice},${OG} you have selected Pwnagotchi Maintenance for ${WT}${pwn_choice}.${OG} Working...\\n"
            pwn_maint_func
            printf "    Here is a fake restore placeholder.\\n"
         fi
         if [[ ${inputpwn} == "?" ]]; then
         override_func
         fi
         if [[ ${inputpwn} == "x" ]] || [[ ${inputpwn} == "X" ]]; then
#      clear
         printf "${RED}[✘] Exiting tool [✘]${NC}"
    exit 1
         fi
   ssh_func
   printf "${BL}"
   printf "${GN}- "
   clear
   Banner_func
   printf "    \\n"
            printf "${BL}"
            printf "    \\n"
       clear
bash ${HOME}scripts/install-master.sh

