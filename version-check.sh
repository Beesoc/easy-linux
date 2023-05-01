#!/bin/bash
set -e
#shellcheck source=.envrc
source .envrc
source version.sh

# handle --version option
if [ "$1" == "--version" ]; then
  print_version
fi

scripts_dir=/opt/easy-linux
# Define the minimum required version for each script
declare -A required_versions=(
  ["$scripts_dir/menu-master.sh"]="0.0.2"
  ["$scripts_dir/menu-hacking.sh"]="0.0.2"
  ["$scripts_dir/menu-customize.sh"]="0.0.2"
  ["$scripts_dir/menu-apps.sh"]="0.0.2"
  ["$scripts_dir/menu-backup_pwn-script.sh"]="0.0.2"
  ["$scripts_dir/.envrc"]="0.0.2"
  ["$scripts_dir/README.md"]="0.0.2"
  ["$scripts_dir/version-check.sh"]="0.0.2"
  ["$scripts_dir/version.sh"]="0.0.2"
  ["$scripts_dir/SETUP.sh"]="0.0.2"
  ["$scripts_dir/INSTALL.sh"]="0.0.2"
  ["$scripts_dir/INSTALL.zip"]="0.0.2"
  ["$scripts_dir/.shellcheckrc"]="0.0.2"

  ["$scripts_dir/support/Banner_func.sh"]="0.0.2"
  ["$scripts_dir/support/support-fatrat.sh"]="0.0.2"
  ["$scripts_dir/support/support-fix-my-perm.sh"]="0.0.2"
  ["$scripts_dir/support/support-hxcdump.sh"]="0.0.2"
  ["$scripts_dir/support/support-linux_connection_script.sh"]="0.0.2"
  ["$scripts_dir/support/support-makeWordlist.sh"]="0.0.2"
  ["$scripts_dir/support/support-Prompt_func.sh"]="0.0.2"
  ["$scripts_dir/support/support-sysinfo.sh"]="0.0.2"
  ["$scripts_dir/support/support-trap-wifi.sh"]="0.0.2"
  ["$scripts_dir/support/support-webmin.sh"]="0.0.2"
  ["$scripts_dir/support/support-wifite.sh"]="0.0.2"

  # add more files from support subdirectory as needed
)


# Loop through each script and check its version against the minimum required version
for script in "${!required_versions[@]}"
do
  # Get the current version of the script
  current_version=$($script --version | awk '{print $NF}')
  
  # Get the minimum required version of the script
  required_version=${required_versions[$script]}
  
  # Compare the current version to the required version
  if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" != "$required_version" ]]; then
    printf "${RED}    Error: ${WT}$script ${RED}version ${WT}$required_version ${RED}or higher is required (current version is ${RED}$current_version)"
    exit 1
  fi
done
