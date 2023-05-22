#!/bin/bash
# update-scripts.sh
scripts_dir=/opt/easy-linux
set -e
# Version: 0.0.2

# Read the required versions from version-easy-linux.sh
source ${scripts_dir}/version-easy-linux.sh
source ${scripts_dir}/.envrc

sudo chown -vR $USER:0 ${scripts_dir}

       if [[ ! -d ${scripts_dir}/tmp ]]; then
            mkdir ${scripts_dir}/tmp
            if [[ ! -d ${scripts_dir}/tmp/support ]]; then    
            mkdir ${scripts_dir}/tmp/support
            fi
            if [[ ! -d ${scripts_dir}/tmp/install ]]; then
            mkdir ${scripts_dir}/tmp/install
            fi 
        fi

# Array to store the script names
script_files=("install/menu-master.sh" "install/menu-hacking.sh" "install/menu-customize.sh" "install/menu-apps.sh" "install/menu-pwn.sh" "install/menu-upload-hashes.sh" "install/update_scripts.sh" ".envrc" "README.md"  "support/version-support.sh" "install/menu-trouble.sh" "install/version-easy-linux.sh" "INSTALLv2.sh" ".shellcheckrc" "update_scripts.sh" "support/.whoami.sh" "support/support-aircrack2.sh" "support/support-airgeddon.sh" "support/support-autojump.sh" "support/support-Banner_func.sh" "support/support-banner.sh" "support/support-docker.sh" "support/support-fatrat.sh" "support/support-fix-my-perm.sh" "support/support-getvars.sh" "support/support-hackingtool.sh" "support/support-hcxdump.sh" "support/support-ican-haz-internet.sh" "support/support-inst-standard.sh" "support/support-linux_connection_script.sh" "support/support-makeWordlist.sh" "support/support-monitor.sh" "support/support-monDOWN.sh" "support/support-makeWordlist.sh" "support/support-nano.sh" "support/support-netadapter.sh" "support/support-ohmy.sh" "support/support-Prompt_func.sh" "support/support-sysinfo.sh" "support/support-trap-wifi.sh" "support/support-updates.sh" "support/support-webmin.sh" "support/support-wifite.sh" "support/support-wpaUP.sh" "support/support-wpaDOWN.sh" "support/version-support.sh" "support/trap-master.sh" "support/update_scripts.sh" "support/version-support.sh"
)

# Function to update a script
update_script() {
    local script_name=$1
    local required_version=$2

    # Get the current version of the script
    local current_version=$(grep -m 1 -o -P "(?<=# Version: ).*" "$script_name")

    # Compare versions
    if [[ $current_version != "$required_version" ]]; then
        printf "${OG}  [-] ${PL}Updating $script_name...${NC}\\n"
        printf "
        printf "$script_name: Current Ver: $current_version. Required ver: $required_version." >> ${scripts_dir}/version_info.list
        # Download the updated script from GitHub or any other source
        # Replace the existing script with the updated version
        # For example:
        sudo curl -o ${scripts_dir}/tmp/"$script_name" -sSLO "https://raw.githubusercontent.com/Beesoc/easy-linux/main/$script_name"  
        if [[ -e ${scripts_dir}/tmp/${script_name} ]]; then
           sudo chmod +x ${scripts_dir}/tmp/"$script_name"
           sudo mv ${scripts_dir}/tmp/"$script_name" ${scripts_dir}/"$script_name"
        fi

        printf "${GN}  [*] ${CY}Script $script_name updated.\\n"
    else
        printf "${GN}  [*] No update needed for ${WT}$script_name${GN}.\\n"
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
            printf "${RED}Required version not found for ${WT}$script_name ${RED}in ${WT}version-easy-linux.sh${RED}.\\n"
        fi
    else
        printf "${RED}Script ${WT}$script_name ${RED}not found.${NC}\\n"
    fi
done
