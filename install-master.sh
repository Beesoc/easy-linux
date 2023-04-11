#!/bin/bash
#
# 1st release of Beesoc's Easy Linux Loader
# * Defines a series of color codes for printing output in different colors.
# * Defines several variables that point to other shell scripts.
# * Defines two functions: Prompt_func(), which prints a command prompt with some information about the user & current  \\n
#   directory, and Banner_func(), which prints a banner at the top of the screen.
# * Displays a main menu with four options: Hacking, Customize, Downloads, and Pwnagotchi. The user can select an option 
#   by typing the corresponding number.
#
#printf "${BG}"
source=./.envrc

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

main() {
# Display the main menu
  clear
  Banner_func
  printf "                       ${OG}[???]${CY} Please select an option: ${OG}[???]${CY}\\n  \\n"
  printf "  ${OG} 1] ${GN}Hacking${OG}                         3] ${GN}Downloads \\n${WT}\\n"
  printf "  ${OG} 2] ${GN}Customize${OG}                       4] ${GN}Pwnagotchi${RED} \\n"
  printf " ${OG} \\n"
  printf "  99]${GN} Display System Information                                 ${RED} [✘] Exit tool [✘]${NC}\\n"  
  printf " \\n"
  Prompt_func
  printf "  ---->"
# Read user input and display the appropriate submenu
read -r choice
  printf "  ${LB}\\n"
#  printf "  ${LB}\\n"
if [[ ${choice} == 1 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Hacking. [!!!]This menu is coming soon. You can continue\\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
      #    Hacking_menu
bash /${scripts_dir}/install-hacking.sh
fi
if [[ ${choice} == 2 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Customize. [!!!]This menu is coming soon. You can continue\\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
#    Customize_menu
    bash /${scripts_dir}/install-customize.sh
fi
if [[ ${choice} == 3 ]]; then  
    clear
    printf "${YW}\\n\\n           You chose Downloads. [!!!]This menu is coming soon. You can continue\\n"
    printf "\\n           but know that you may experience bugs or other weird shit.  ${GN}You\\n"
    printf "\\n           have been warned. [!!!]\\n" 
    printf "\\n${YW}            Press ${WT}any key ${YW}to continue.\\n"
      read -r -n1 -s -t 60
      clear
      #    Download_menu
    bash ${scripts_dir}install-download.sh
fi
if [[ ${choice} == 4 ]]; then  
    printf "${YW}      You chose Pwnagotchi. \\n "
    clear
#    Pwnagotchi_menu
    bash ./install-backup_pwn-script.sh
fi
if [[ ${choice} == 99 ]]; then  
    printf "${YW}      You chose System Information. \\n "
    clear
#    Sysinfo_menu
    Banner_func
    printf "Show sys info"
fi
if [[ ${choice} == 0 ]]; then  
#    Exit_menu
    clear
    Banner_func
    printf "${RED}0. [✘] Exit tool [✘]${NC} \\n"
    exit 1
fi
}
main