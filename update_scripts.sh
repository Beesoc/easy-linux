#!/bin/bash
# update-scripts.sh
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.2
trap ${scripts_dir}/support/trap-master.sh EXIT
# Read the required versions from version-easy-linux.sh
source "${scripts_dir}/version-easy-linux.sh"
source "${scripts_dir}/.envrc"

sudo chown -vR "$USER:0" "${scripts_dir}"

cd ${scripts_dir} || exit
rm -rf tmp/
mkdir tmp/
mkdir tmp/support
mkdir tmp/support/misc 
mkdir tmp/install

if [[ ! -d "${scripts_dir}/tmp" ]]; then
    mkdir "${scripts_dir}/tmp"
    sudo chown -vR "$USER:0" "${scripts_dir}/tmp"
    if [[ ! -d "${scripts_dir}/tmp/support" ]]; then    
        mkdir "${scripts_dir}/tmp/support"
        sudo chown -vR "$USER:0" "${scripts_dir}"/support
          if [[ ! -d "${scripts_dir}/tmp/support/misc" ]]; then    
               mkdir "${scripts_dir}/tmp/support/misc"
          fi
    fi
    if [[ ! -d "${scripts_dir}/tmp/support/misc" ]]; then 
        mkdir "${scripts_dir}/tmp/support/misc"
        sudo chown -vR "$USER:0" "${scripts_dir}"/tmp/support/misc
    fi
    if [[ ! -d "${scripts_dir}/tmp/install" ]]; then
        mkdir "${scripts_dir}/tmp/install"
        sudo chown -vR "$USER:0" "${scripts_dir}"/tmp/install
    fi 
fi

# Array to store the script names
script_files=(
    "install/menu-master.sh"
    "install/menu-hacking.sh"
    "install/menu-hackapps.sh"
    "install/menu-customize.sh"
    "install/menu-apps.sh"
    "install/menu-pwn.sh"
    "install/menu-upload-hashes.sh"
    ".envrc"
    "README.md"
    "install/menu-trouble.sh"
    "INSTALLv2.sh"
    ".shellcheckrc"
    "update_scripts.sh"
    "support/.whoami.sh"
    "support/misc/pwnip.sh"
    "support/misc/restart_all_pwn.sh"
    "support/misc/uninstall.sh"
    "support/support-aircrack2.sh"
    "support/support-airgeddon.sh"
    "support/support-autojump.sh"
    "support/support-Banner_func.sh"
    "support/support-banner.sh"
    "support/support-docker.sh"
    "support/support-fatrat.sh"
    "support/support-fix-my-perm.sh"
    "support/support-getvars.sh"
    "support/support-hackingtool.sh"
    "support/support-hcxdump.sh"
    "support/support-ican-haz-internet.sh"
    "support/support-inst-standard.sh"
    "support/support-linux_connection_script.sh"
    "support/support-makeWordlist.sh"
    "support/support-monitor.sh"
    "support/support-monDOWN.sh"
    "support/support-makeWordlist.sh"
    "support/support-nano.sh"
    "support/support-netadapter.sh"
    "support/support-ohmy.sh"
    "support/support-Prompt_func.sh"
    "support/support-sysinfo.sh"
    "support/support-trap-wifi.sh"
    "support/support-updates.sh"
    "support/support-webmin.sh"
    "support/support-wifite.sh"
    "support/support-wpaUP.sh"
    "support/support-wpaDOWN.sh"
    "support/trap-master.sh"
    "support/update_scripts.sh"
    "support/version-easy-linux.sh"
)

# Associative array to store the version information
declare -A version_info

# Function to update a script
update_script() {
    local script_name=$1
    local required_version=$2

    # Get the current version of the script
    local current_version=$(grep -m 1 -o -P "(?<=# Version: ).*" "$script_name")

    # Compare versions
    if [[ $current_version != "$required_version" ]]; then
        printf "${OG}  [-] ${PL}Updating $script_name...${NC}\\n"
        
        # Download the updated script from GitHub or any other source
        # Replace the existing script with the updated version
        # For example:
        sudo curl -o "${scripts_dir}/tmp/$script_name" -sSLO "https://raw.githubusercontent.com/Beesoc/easy-linux/main/$script_name"  
        if [[ -e "${scripts_dir}/tmp/$script_name" ]]; then
            sudo chmod +x "${scripts_dir}/tmp/$script_name"
            sudo mv "${scripts_dir}/tmp/$script_name" "${scripts_dir}/$script_name"
        fi

        printf "${GN}  [*] ${CY}Script $script_name updated.\\n"

        # Store the version information in the associative array
        version_info["$script_name"]="Current Ver: $current_version. New Ver: $required_version"
    else
        printf "${GN}  [*] No update needed for $script_name${GN}.\\n"
    fi
}

# Loop through the scripts and check for updates
for script_name in "${script_files[@]}"; do
    # Check if the script exists
    if [[ -f $script_name ]]; then
        # Get the required version from the associative array
        required_version="${required_versions[$script_name]}"

        if [[ -n $required_version ]]; then
            update_script "$script_name" "$required_version"
        else
            printf "${RED}Required version not found for $script_name in version-easy-linux.sh.${RED}\\n"
        fi
    else
        printf "${RED}Script $script_name not found.${NC}\\n"
    fi
done

# Print update report
# Print update report
clear
source "${scripts_dir}/support/support-Banner_func.sh"
printf "${OG}|                                                                                 |\n"
printf "${OG}|------------------------------ ${GN}| Update Report | ${OG}--------------------------------|${OG}\n"
#printf "|                                                                                 |\n"
printf "    ${WT}User: ${OG}$USER     |     ${WT}Computer: ${OG}$computername     |     ${WT}Date: ${OG}$(date +"%Y-%m-%d")${NC}\n"
printf "    ${WT}Total updates: ${PL}${#version_info[@]}${NC}\n"
printf "${OG}|_________________________________________________________________________________|${CY}\n"

# Define the column widths
script_name_width=40
version_info_width=40

# Print column headers
printf "|                                                                                 |${CY}\n    "
printf "%-${script_name_width}s %-${version_info_width}s\n" "${BOLD}Script Name" "${BOLD}Version Information"

printf "|                                                                                 |${WT}\n"
# Loop through the version info array and print the details in columns
for script_name in "${!version_info[@]}"; do
    printf " %-${script_name_width}s %-${version_info_width}s\n" "$script_name" "${version_info[$script_name]}"
done
printf "${GN}|                                                                                 |\n"
printf "${GN}|_________________________________________________________________________________|\n"
echo
printf "  ${GN}Press ${WT}any ${GN}key to continue${NC}\n"
echo
read -n 1 -s -r -t 300

# Clean up temporary files
rm -rf "${scripts_dir}/tmp"
