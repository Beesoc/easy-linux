#!/bin/bash
scripts_dir="/opt/easy-linux"
set -e
# ...
# trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
source "${scripts_dir}/.envrc"
# Version: 0.0.4

ripper_func() {
  read -n 1 -r -p "Made it another step. Any key to continue" madeit
  clear
  printf "\\n"

  # ...

  # Prompt the user to choose between John the Ripper and Hashcat
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "\\n"
  printf "${OG}1] ${CY}John the Ripper\\n"
  printf "${OG}2] ${CY}Hashcat\\n"
  printf "\\n"
  printf "$CY  Choose a tool for cracking the hash [1/2] ${GN}----> ${OG}\\n"
  printf "\\n"
  read -n 1 -r ripperchoice
  ripperchoice=${ripperchoice:-2}

  # Capture the hashes with hcxdumptool

  if [[ ${ripperchoice} -eq 1 ]]; then
    # Crack the hash with John the Ripper using the OneRuleToRuleThemAll.rule
    john --wordlist="${WORDLIST}" --rules="${RULES}" --stdout | aircrack-ng -w - -e SSID /opt/backup/root/handshakes/hashes.22000 -J /opt/backup/root/handshakes/mypots.potfile
  elif [[ ${ripperchoice} -eq 2 ]]; then
    # Crack the hash with hashcat
    hashcat -m 22000 -a 3 -w 4 -o /opt/backup/root/handshakes/mypots.potfile --force --opencl-device-types=1,2 "${WORDLIST}" /opt/backup/root/handshakes/hashes.22000 --increment --increment-min=8 --increment-max=13
  else
    # Invalid choice
    printf "${RED}  Invalid choice. Exiting..."
    exit 1
  fi

  # ...
}

Test_func() {
  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "${OG}             What test do you want to run?\\n"
  printf "  \\n"
  printf "   ${OG}1] ${CY}Injection Test - Test your network adapter's packet injection abilities.\\n"
  printf "   ${OG}2] ${CY}Driver Test - Runs several tests to determine if the driver supports all IOCTL calls. \\n"
  printf "   \\n"
  printf "   ${OG}99] ${CY}Return to the main menu.                       ${RED} [✘] Exit tool [✘]${CY}\\n "
  read -n 1 -r -p "Which test? " test

  if [[ ${test} = 1 ]]; then
    sudo systemctl stop NetworkManager
    sudo systemctl stop wpa_supplicant
    sudo hcxdumptool --check_injection -i "${adapter}"
  elif [[ ${test} = 2 ]]; then
    sudo systemctl stop NetworkManager
    sudo systemctl stop wpa_supplicant
    sudo hcxdumptool --check_driver -i "${adapter}"
  elif [[ ${test} = 99 ]]; then
    source "${scripts_dir}/install/menu-master.sh"
  elif [[ ${test} = "x" ]] || [[ ${test} = "X" ]]; then
    clear
    printf "    ${RED}0. [✘] Exit tool [✘]${NC} \\n"
    exit 0
  else
    printf "${RED}  Invalid Selection${NC}\\n"
  fi
}

choice_func() {
  clear
  printf "${OG}   \\n"
  source "${scripts_dir}/support/support-Banner_func.sh"


  sudo systemctl stop NetworkManager && sudo systemctl stop wpa_supplicant
  echo
  printf " \\n${WT}"
  printf "  ${CY}Press ${WT}[S] ${CY}to scan...Please ${RED}do not interrupt for 30 sec ${CY}scan...${OG}\\n"
  echo
  printf "  Scan will stop automatically when complete...\\n${WT}   "
  printf "${GN} \\n"
  printf "  Press ${WT}[T]${GN}est to test adapters or ${WT}[S]${GN}can to scan AP's.${WT} \\n     "
  read -n 1 -r -p "[T]est or [S]can [t/S] ----> " torscan
  torscan=${torscan:-S}
  printf "\\n"
  
  if [[ "${torscan}" = "T" ]] || [[ "${torscan}" = "t" ]]; then
    Test_func
  elif [[ "${torscan}" = "S" ]] || [[ "${torscan}" = "s" ]]; then
    printf " \\n"

    if (ls "${scripts_dir}/support/misc/hcxdumptool*" >/dev/null 2>&1); then
      cd "${scripts_dir}/support/misc" || exit
      printf "${OG}  Hcxdump files exist in your misc/ directory. Using them.\\n"
      sleep 3
      sudo chown -vR $USER:0 "${scripts_dir}/support/misc"
      sudo /usr/bin/hcxpcapngtool -o "${scripts_dir}/support/misc/*.pcapng*"
      rm -f ./*pcapng*
      
      read -n 1 -p "Done with hcxpcapng. Files deleted.\\n"
      ripper_func
    elif (! ls "${scripts_dir}/support/misc/hcxdumptool*" >/dev/null 2>&1); then
      # Code to execute when the files don't exist
      printf "${OG}  You have selected scan. The next step will take 30 secs.\\n"
      printf "${OG}  Do ${WT}NOT ${OG}interrupt until the scan has completed.\\n  "
      read -n 1 -r -p "Press any key to continue." anykey2
      printf "\\n"
      do_rcascan=""
      if [[ $do_rcascan == 0 ]]; then
        do_rcascan=1
        source "${scripts_dir}/support/support-hcxdump2.sh"
        sleep 40
      elif [[ $do_rcascan == 1 ]]; then
        do_rcascan=0
        source "${scripts_dir}/support/support-hcxdump3.sh"
        sleep 120
      fi
    fi
    printf "\\n  ${GN}Success. Hcxdump files have been joined. \\n"
  fi
}

main() {
  source "${scripts_dir}/support/support-netadapter.sh"
  choice_func
  ripper_func
}

main
sleep 1
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant

