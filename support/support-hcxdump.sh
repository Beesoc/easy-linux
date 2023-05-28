#!/bin/bash
scripts_dir="/opt/easy-linux"
set -e
# Version: 0.0.4
# trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
source "${scripts_dir}/.envrc"

ripper_func() {
  clear
  printf "\\n"

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

  if [[ ${ripperchoice} -eq 1 ]]; then
    # Crack the hash with John the Ripper using the OneRuleToRuleThemAll.rule
    john --wordlist="${WORDLIST}" --rules="${RULES}" --stdout | aircrack-ng -w - -e SSID /opt/backup/root/handshakes/hashes.22000 -J /opt/backup/root/handshakes/mypots.potfile
  elif [[ ${ripperchoice} -eq 2 ]]; then
    # Crack the hash with hashcat
    hashcat -m 22000 -a 3 -w 4 -o /opt/backup/root/handshakes/mypots.potfile --force --opencl-device-types=1,2 "${WORDLIST}" /opt/backup/root/handshakes/hashes.22000 --increment --increment-min=8 --increment-max=13
  else
    # Invalid choice
    printf "${RED}  Invalid choice. Exiting...\\n"
    exit 1
  fi

}

full_scan() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"
if [[ $hcxdump_full -ne 1 ]]; then
  printf "${CY}  Whoop. How would you like to do a ${WT}REAL ${CY}scan.\\n"
  printf "${OG}  The longer you wait on the next screen, the more attacks will complete, and the\\n" 
  printf "${OG}  more hashes you will have. It will stop itself after 10 mins or you can press\\n"
  printf "${OG}  ${WT}Ctrl${OG} + ${WT}C ${OG}to stop it early.\\n"
  read -n 1 -r -p "Good things come...Press any key "
  echo "export hcxdump_full=1"
  source ${scripts_dir}/support/support-hcxdump_full.sh
  sleep 600
  sudo /usr/bin/hcxpcapngtool -o "${scripts_dir}/support/misc/hcxdump_full.pcapng*"

  ripper_func
elif [[ $hcxdump_full == 1 ]]; then
  printf "${GN}  So...you ran the full scan"; sleep 2; printf " ...I hope it paid off for you."; sleep 2; printf "You'll find out soon\\n"
  sleep 3; printf "...ish"
  echo "export hcxdump_full="
  read -r -p "Press any key to continue."
  ripper_func
fi
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
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "${OG}   \\n"

  sudo systemctl stop NetworkManager && sudo systemctl stop wpa_supplicant
  echo
  printf " \\n${WT}"
  printf "  ${CY}Press ${WT}[S] ${CY}to scan...Please ${RED}do not interrupt for 40 sec ${CY}scan...${OG}\\n"
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
   #   cat 
   #   rm -f ./*pcapng*
        do_rcascan="0"  
      read -n 1 -p "Done with hcxpcapng RCAScanning. Press any key. \\n"
      full_scan
      elif (! ls "${scripts_dir}/support/misc/hcxdumptool*" >/dev/null 2>&1); then
      # Code to execute when the files don't exist
      printf "${OG}  You have selected scan. The next step will take 30 secs.\\n"
      printf "${OG}  Do ${WT}NOT ${OG}interrupt until the scan has completed.\\n  "
      read -n 1 -r -p "Press any key to continue." anykey2
        do_rcascan=1
        sleep 40 $
        source "${scripts_dir}/support/support-hcxdump_dorcascan.sh"
      printf "\\n"
      sudo chown -vR $USER:0 "${scripts_dir}/support/misc"
      sudo /usr/bin/hcxpcapngtool -o "${scripts_dir}/support/misc/*.pcapng*"
      fi
else
      printf "${RED}  Invalid Selection.  Press ${WT}S ${RED}to scan, or ${WT}T ${RED}to test wifi adapters."
fi
}

main() {
  source "${scripts_dir}/support/support-netadapter.sh"
  # Capture the hashes with hcxdumptool
  choice_func
  ripper_func
}

main
sleep 1
printf "    ${OG}Restarting NetworkManager and wpa_supplicant...\\n"
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant

