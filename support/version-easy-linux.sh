#!/bin/bash
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
#source ${scripts_dir}/.envrc
#clear
#source "${scripts_dir}/support/support-Banner_func.sh"
# Define the minimum required version for each script
declare -A required_versions=(
	["install/menu-master.sh"]="0.0.3"
	["install/menu-hacking.sh"]="0.0.3"
	["install/menu-customize.sh"]="0.0.3"
	["install/menu-apps.sh"]="0.0.3"
	["install/menu-pwn.sh"]="0.0.3"
	["install/menu-upload-hashes.sh"]="0.0.3"
	["install/update_scripts.sh"]="0.0.2"
	[".envrc"]="0.0.2"
	["README.md"]="0.0.2"
	["support/version-support.sh"]="0.0.2"
	["install/menu-trouble.sh"]="0.0.2"
	["install/version-easy-linux.sh"]="0.0.2"
	["INSTALLv2.sh"]="0.0.2"
	[".shellcheckrc"]="0.0.2"
	["update_scripts.sh"]="0.0.2"
	["support/.whoami.sh"]="0.0.3"
	["support/support-aircrack2.sh"]="0.0.2"
	["support/support-airgeddon.sh"]="0.0.2"
	["support/support-autojump.sh"]="0.0.2"
	["support/support-banner.sh"]="0.0.2"
	["support/support-Banner_func.sh"]="0.0.2"
	["support/support-docker.sh"]="0.0.2"
	["support/support-fatrat.sh"]="0.0.2"
	["support/support-fix-my-perm.sh"]="0.0.2"
	["support/support-getvars.sh"]="0.0.2"
	["support/support-hackingtool.sh"]="0.0.2"
	["support/support-hcxdump.sh"]="0.0.2"
	["support/support-ican-haz-internet.sh"]="0.0.2"
	["support/support-inst-standard.sh"]="0.0.2"
	["support/support-linux_connection_script.sh"]="0.0.2"
	["support/support-makeWordlist.sh"]="0.0.2"
	["support/support-monitor.sh"]="0.0.2"
	["support/support-monDOWN.sh"]="0.0.2"
	["support/support-makeWordlist.sh"]="0.0.2"
	["support/support-nano.sh"]="0.0.2"
	["support/support-netadapter.sh"]="0.0.2"
	["support/support-ohmy.sh"]="0.0.2"
	["support/support-Prompt_func.sh"]="0.0.2"
	["support/support-sysinfo.sh"]="0.0.2"
	["support/support-trap-wifi.sh"]="0.0.2"
	["support/support-troubleshooting.sh"]="0.0.2"
	["support/update_scripts.sh"]="0.0.2"
	["support/support-updates.sh"]="0.0.2"
	["support/support-webmin.sh"]="0.0.2"
	["support/support-wifite.sh"]="0.0.3"
	["support/support-wpaUP.sh"]="0.0.2"
	["support/support-wpaDOWN.sh"]="0.0.2"
	["support/trap-master.sh"]="0.0.2"
	["support/version-support.sh"]="0.0.2"
)

#function check_version {
#	script_path=$1
#	script_name=$(basename "$script_path")
#	current_version=$(grep '^# Version:' "$script_path" | awk '{print $3}')
#	required_version=${required_versions[$script_name]}
#
#	if [[ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" != "$required_version" ]]; then
#		printf "${RED}Error: $script_path version $required_version or higher is required (current version is $current_version)" >&2
#		exit 1
#	fi
#}

#function update_script {
#	script_name=$1
#	script_path=$2
#	latest_version=$(curl -s https://raw.githubusercontent.com/Beesoc/easy-linux/main/"$script_name" | grep '^# Version:' | awk '{print $3}')
#
#	if [[ "$(printf '%s\n' "$latest_version" "${required_versions[$script_name]}" | sort -V | head -n1)" == "$latest_version" ]]; then
#		echo "Updating $script_name to version $latest_version"
#		curl -s https://raw.githubusercontent.com/Beesoc/easy-linux/main/"$script_name" >"$script_path"
#		chmod +x "$script_path"
#	fi
#}

#for script_path in $(find . -type f -name "*.sh"); do
#	check_version "$script_path"
#done

#for script_path in $(find . -type f -name "*.sh"); do
#	script_name=$(basename "$script_path")
#	update_script "$script_name" "$script_path"
#done

#for script_path in $(find . -type f -name "*.zip"); do
#	check_version "$script_path"
#done

#for script_path in $(find . -type f -name "*.zip"); do
#	script_name=$(basename "$script_path")
#	update_script "$script_name" "$script_path"
#done

#printf "    ${GN}All scripts are up to date.\\n"
