#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if the required commands are available
if ! command_exists timeout || ! command_exists aircrack-ng || ! command_exists tshark; then
  echo "One or more required tools are missing. Attempting to install..."

  if command_exists apt; then
    sudo apt update
    sudo apt install -y timeout aircrack-ng tshark
  elif command_exists yum; then
    sudo yum install -y epel-release
    sudo yum install -y timeout aircrack-ng wireshark
  else
    echo "Unable to install required tools automatically. Please install timeout, aircrack-ng, and tshark manually."
    exit 1
  fi
fi

# Function to check if a valid handshake hash is present in the given file
check_handshake() {
  local file="$1"
  local tool="$2"

  if [ "$tool" == "tshark" ]; then
    # Using tshark to check for handshake hash
    tshark -r "$file" -Y "wlan.fc.type_subtype == 0x08 && wlan_mgt.rsn.akms.type == 0x01 && wlan_mgt.rsn.akms.type == 0x02" -T fields -e wlan.sa -e wlan.da -e wlan.ra -e wlan.ta -e eapol.keydes.keyinfo.type > /dev/null
  elif [ "$tool" == "aircrack-ng" ]; then
    # Using aircrack-ng to check for handshake hash
    aircrack-ng -J "$file" > /dev/null
  fi

  return $?
}

# Check if the hcx_dorca.pcapng and hcxdump_full*.pcapn* files exist
if ls hcx_dorca.pcapng hcxdump_full*.pcapn* 1> /dev/null 2>&1; then
  echo "Output files exist. Checking for handshake hash..."

  # Loop through the files and check for a handshake hash
  for file in hcxdump_full*.pcapn*; do
    if check_handshake "$file" "tshark" || check_handshake "$file" "aircrack-ng"; then
      echo "Handshake hash found in $file"
      hcxpcapng -o "${file%.pcapn*}.hc22000" "$file"
      rm "$file"
    else
      echo "No handshake hash found in $file"
    fi
  done

  # Check for handshake hash in hcx_dorca.pcapng
  if check_handshake "hcx_dorca.pcapng" "tshark" || check_handshake "hcx_dorca.pcapng" "aircrack-ng"; then
    echo "Handshake hash found in hcx_dorca.pcapng"
    hcxpcapng -o hcx_dorca.hc22000 hcx_dorca.pcapng
    rm hcx_dorca.pcapng
  else
    echo "No handshake hash found in hcx_dorca.pcapng"
  fi
else
  # Calculate the time difference since the last execution of support-hcxdump_dorcascan script
  last_execution=$(stat -c %Y support-hcxdump_dorcascan.sh)
  current_time=$(date +%s)
  time_diff=$((current_time - last_execution))
  time_threshold=$((24 * 60 * 60))  # 24 hours in seconds

  if [ $time_diff -gt $time_threshold ]; then
    echo "Running support-hcxdump_dorcascan script..."
    timeout 1m ./support-hcxdump_dorcascan.sh
  else
    echo "Running support-hcxdumptool_full.sh script..."
    timeout 15m ./support-hcxdumptool_full.sh
  fi
fi
