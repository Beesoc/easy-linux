#!/bin/bash

# Define the minimum required version for each script
declare -A required_versions=(
  ["menu-master.sh"]="0.0.2"
  ["menu-hacking.sh"]="0.0.2"
  ["menu-customize.sh"]="0.0.2"
  ["menu-apps.sh"]="0.0.2"
  ["menu-backup_pwn-script.sh"]="0.0.2"
  ["menu-upload-hashes.sh"]="0.0.2"

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
    echo "Error: $script version $required_version or higher is required (current version is $current_version)"
    exit 1
  fi
done
