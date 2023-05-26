#!/bin/bash
# set a variable for handshakes directory so it can be changed in program
# Version: 0.0.4
handshakes_dir="/opt/backup/root/handshakes"
scripts_dir="/opt/easy-linux"
backup_dir="/opt/backup"
set -e
# Add Color
source "${scripts_dir}/.envrc"
#
trap "source ${scripts_dir}/support/support-trap-wifi.sh" EXIT

# List of source directories
source_dirs=(
  "$HOME/compiled/aircrack-ng/hs/"                             # *.cap
  "$HOME/Downloads/"                                            # *.cap
  "$HOME/hs/"                                                   # *.pcap    *.pcapng    *.22000
  "/home/hackingtool/hs/"                                       # *.cap    *.pcapng    *.22000
  "$HOME/security/handshakes/"                                  # *.cap
  "$HOME/security/"                                             # *.pcap    *.pcapng
  "${backup_dir}/archive/FuckThatSh1t/home/pi/handshakes/"      # *.cap
  "${backup_dir}/archive/FuckThatSh1t/root/backups/1677/root/handshakes"  # *.pcap
  "${backup_dir}/archive/FuckThatSh1t/root/handshakes/"         # *.cap    *.pcap
  "${backup_dir}/archive/root/handshakes/"                      # *.cap
  "/opt/easy-linux/support/"                                    # *.cap    *.pcap    *.pcapng
  "/opt/easy-linux/support/misc"                                # *.cap    *.pcap    *.pcapng
  "${handshakes_dir}"                                           # *.cap
)

destination_dir="/opt/backup/root"

# Function to check if a directory exists
directory_exists() {
  if [[ ! -d "$1" ]]; then
    printf "${OG}Source directory ${WT}$1 ${OG}does not exist. Skipping...\\n"
    return 1
  fi
}

# Function to create the destination directory if it doesn't exist
create_destination_directory() {
  if [[ ! -d "$1" ]]; then
    mkdir -p "$1"
  fi
}

# Function to move files with specified extensions
move_files() {
  local dir="$1"

  # Move *.cap files
  find "$dir" -type f -name "*.cap" -exec mv -u "{}" "$destination_dir/" \;

  # Move *.pcap files
  find "$dir" -type f -name "*.pcap" -exec mv -u "{}" "$destination_dir/" \;

  # Move *.pcapng files
  find "$dir" -type f -name "*.pcapng" -exec mv -u "{}" "$destination_dir/" \;

  # Move *.22000 files
  find "$dir" -type f -name "*.22000" -exec mv -u "{}" "$destination_dir/" \;

  # Move *.hccapx files
  find "$dir" -type f -name "*.hccapx" -exec mv -u "{}" "$destination_dir/" \;
}

# Function to gzip files in the destination folder
gzip_files() {
  for file in "$1"/*; do
    if [[ -f "$file" ]]; then
      gzip -r "$file"
    fi
  done
}

upload_func() {
   clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  if [[ $(find "${handshakes_dir}" -maxdepth 1 \( -name '*.cap' -o -name '*.pcap' -o -name '*.pcap-ng' \) -type f -print -quit | grep -q '.') ]]; then
    wlancap2wpasec -u https://api.onlinehashcrack.com -e "$pro_email" "${handshakes_dir}"/*.pcap
    printf " ${GN} [*] ${CY}Send all cap's to OHC.${OG}\\n"
    wlancap2wpasec -u https://api.onlinehashcrack.com -e "$pro_email" "${handshakes_dir}"/*.cap
  fi

  printf " ${GN} [X] ${WT}Gzip ${CY}is not supported on ${WT}OnlineHashCrack${CY}.\\n ${GN} [*] ${CY}Uploading ${WT}hccapx ${CY}files to ${WT}OHC.${OG}\\n"

  if [[ $(find "${backup_dir}/root/hccapx" -maxdepth 1 -name '*.hccapx' -type f -print -quit | grep -q '.') ]]; then
    wlancap2wpasec -u https://api.onlinehashcrack.com -e "$pro_email" \
      "${backup_dir}/root/hccapx/*.hccapx"
    printf " ${GN} [X] ${CY}HCCAPX isn't supported on WPA-Stanev.\\n"
  fi
  clear
}

}

gzip_upload() {
 printf " ${GN} [X] ${CY}Gzip is not supported on ${WT}OnlineHashCrack.\\n ${GN} [X] ${CY}Not compressing files. \\n ${GN} [*] ${CY}Uploading pcap's to OHC.${OG}\\n"
  if [[ $(find "${handshakes_dir}" -maxdepth 1 -name '*.pcap' -type f -print -quit | grep -q '.') ]]; then
    printf " ${GN} [*] ${WT}Compress all PCAP files.\\n ${GN} [*] ${CY} Uploading to ${WT}WPA-Stanev${OG}.\\n"
  else
    printf "${OG}  No ${WT}GZIP compressed PCAP ${OG}files.\\n"
  fi
  if [[ $(find "${handshakes_dir}" -maxdepth 1 -name '*.cap' -type f -print -quit | grep -q '.') ]]; then
    printf " ${GN} [*] ${WT}Compress all and CAP files.\\n ${GN} [*] ${CY} Uploading to ${WT}WPA-Stanev${OG}.\\n"
  else
    printf "${OG}  No ${WT}GZIP compressed CAP ${OG}files.\\n"
  fi
  if [[ $(find "${handshakes_dir}" -maxdepth 1 -name '*.gz' -type f -print -quit | grep -q '.') ]]; then
    printf " ${GN} [*] ${CY}Send all compressed ${WT}pcap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
    wlancap2wpasec -k "$wpa_api" -t 45 -R \
      "${handshakes_dir}"/*.pcap.gz
    printf " ${GN} [*] ${CY}Send all compressed ${WT}cap's${CY} to ${WT}WPA-Stanev${CY}.\\n ${GN} [*] ${CY}Remove successful uploads.${OG}\\n"
    wlancap2wpasec -k "$wpa_api" -t 45 \
      "${handshakes_dir}"/*.cap.gz
  else
    printf " No *.gz files to upload.\\n"
  fi
}

main() {
  clear
  source "${scripts_dir}/support/support-Banner_func.sh"
  printf "\n"
  printf "  ${CY}This script uploads your saved hashes from ${WT}$handshakes_dir${CY}\n"
  printf "  to ${WT}Onlinehashcrack.com ${CY}and ${WT}www.wpa-stanev.org${CY}.\n${NC} "
  printf "\n"
  printf "  ${OG}Press ${WT}any ${OG}key to continue.\n${NC}  "
  read -n 1 -r -t 300

  # Check if all source directories exist
  for dir in "${source_dirs[@]}"; do
    directory_exists "$dir" || continue
  done

  # Create destination directory if it doesn't exist
  create_destination_directory "$destination_dir"

  # Move files from source directories to destination directory
  for dir in "${source_dirs[@]}"; do
    if directory_exists "$dir"; then
      move_files "$dir"
    fi
  done

  # Call upload function
  upload_func

  # Gzip files in the destination folder
  gzip_files "$destination_dir"

  # Call gzip upload function
  gzip_upload
}

main

printf "${CY}  All Operations completed. Cracked passwords will start appearing on \n"
printf "${WT}  https://www.OnlineHashCrack.com ${CY}and ${WT}https://wpa-sec.stanev.org ${CY}within 24 hours.\n"
printf "      ${GN}Press ${WT}any${GN} key to return to ${WT}Main Menu${GN}.\n "
read -n 1 -r -t 300

