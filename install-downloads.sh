#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
LIGHTBLUE='\e[0;34m'
NC='\e[0m'

Prompt_func() {
  printf " \\n"
  printf "  ${GREEN}┌──(${BLUE}$USER㉿$HOSTNAME${GREEN})-[${WHITE}$(pwd)${BLUE}${GREEN}]\\n "
  printf " ${GREEN}L${BLUE}$ ${ORANGE}"
#  printf " \\n "
}

Banner_func() {
  printf "${OG}
${OG}███████████████████████████████████████████████████████████████████████████████████████████████████${OG}
███                                                                                             ███
███    ${BL}▄████▄╗     ▄████▄╗    ▄████▄╗     ▄████▄╗     ▄████▄╗      ▄███▄╗    ██╗    ▄████▄╗     ${OG}███
███    ${BL}██═══██╝    ██╔═══╝    ██╔═══╝    ██╔═══╝     ██╔═══██╗    ██╔═══▀╝    ▀╝   ██╔════╝     ${OG}███
███    ${BL}█████═╝     █████╗     █████╗      ▀████▄╗    ██║   ██║    ██║               ▀████▄╗     ${OG}███
███    ${BL}██═══██     ██╔══╝     ██╔══╝       ╚═══██║   ██║   ██╝    ██║   ▄╗           ╚═══██║    ${OG}███
███    ${BL}▀████▀╝     ▀████▀╗    ▀████▀╗     ▀████▀╝     ▀████▀╝      ▀███▀╝           ▀████▀╝     ${OG}███
███     ${BL}╚══╝        ╚═══╝      ╚═══╝       ╚══╝        ╚══╝         ╚═╝              ╚══╝       ${OG}███
███                                                                                             ${OG}███
███    ${BL}▄████▄╗    ▄█▄╗    ▄████▄╗  ██╗   ██╗    ▄█╗      ▄█╗ ▄█╗   █▄╗ ▄█╗   ▄█╗  ██▄╗  ▄██╗    ${OG}███
███    ${BL}██╔═══╝   ██║██╗  ██╔════╝   ██╗ ██╔╝    ██║      ██║ ██▄╗  ██║ ██║   ██║   ▀██▄██▀╝     ${OG}███
███    ${BL}█████╗   ███████╗ ╚▀█████▄╗   ████╔╝     ██║      ██║ ████▄ ██║ ██║   ██║     ███║       ${OG}███
███    ${BL}██╔══╝   ██║  ██║   ╚═══██║    ██╔╝      ██║      ██║ ██║▀████║ ██║   ██║   ▄██▀██▄╗     ${OG}███
███    ${BL}▀████▀╝  ██║  ██║  ▀████▀╝     ██║       ╚▀█████╗ ██║ ██║  ▀██║  ▀█████▀╝  ██▀╝  ▀██╗    ${OG}███
███     ${BL}╚═══╝   ╚═╝  ╚═╝   ╚══╝       ╚═╝         ╚════╝ ╚═╝ ╚═╝   ╚═╝   ╚═══╝    ╚═╝    ╚═╝    ${OG}███
███████████████████████████████████████████████████████████████████████████████████████████████████ \\n"
printf " \\n"
#
#  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
}

Banner_func
printf "${OG} \\n   "
printf "You have entered the Downloads menu.  Press any key to exit \\n"

  printf "  ${LIGHTBLUE}\\n"
  printf "    ${YELLOW}1. Install and Run${WHITE} aptitude package management${CYAN} \\n   "
  printf "2. Install${WHITE} all upgrades${RED}[✘] NOTE: [✘]${CYAN} don't run on Pwnagotchi!${GREEN} \\n   "
  printf "3. TODO - fill this menu${LIGHTBLUE} \\n   "

Prompt_func
read -r -n1 -s -t 10

 printf "  ${LIGHTBLUE}\\n"
  printf "    ${YELLOW}1. Install and Run${WHITE} aptitude package management${CYAN} \\n   "
  printf "2. Install${WHITE} all upgrades${RED}[✘] NOTE: [✘]${CYAN} don't run on Pwnagotchi!${GREEN} \\n   "
  printf "3. TODO - fill this menu${LIGHTBLUE} \\n   "
  printf "4. TODO - fill this menu${RED} \\n   "
  printf "0. [✘] Exit tool [✘]${NC} \\n   "
exit
