#!/bin/bash
# Version: 0.0.4
#set -e
# Define the minimum required version for each script
declare -A required_versions=(
	["install/menu-master.sh"]="0.0.3"
	["install/menu-hacking.sh"]="0.0.3"
	["install/menu-hackapps.sh"]="0.0.3"
	["install/menu-customize.sh"]="0.0.3"
        ["install/menu-containerized.sh"]="0.0.3"
	["install/menu-apps.sh"]="0.0.3"
	["install/menu-pwn.sh"]="0.0.3"
	["install/menu-upload-hashes.sh"]="0.0.4"
	[".envrc"]="0.0.4"
	["README.md"]="0.0.3"
	["install/menu-trouble.sh"]="0.0.3"
	["INSTALLv2.sh"]="0.0.4"
	[".shellcheckrc"]="0.0.3"
	["update_scripts.sh"]="0.0.4"
	["support/misc/pwnip.sh"]="0.0.4"
	["support/misc/restart_all_pwn.sh"]="0.0.3"
        ["support/misc/uninstall.sh"]="0.0.3"
	["support/misc/lynis_check.sh"]="0.0.3"
        ["support/.whoami.sh"]="0.0.3"
	["support/support-aircrack2.sh"]="0.0.3"
	["support/support-airgeddon.sh"]="0.0.3"
	["support/support-autojump.sh"]="0.0.3"
	["support/support-banner.sh"]="0.0.2"
	["support/support-Banner_func.sh"]="0.0.4"
	["support/support-docker.sh"]="0.0.3"
	["support/support-fatrat.sh"]="0.0.3"
	["support/support-fix-my-perm.sh"]="0.0.3"
	["support/support-getvars.sh"]="0.0.3"
 	["support/support-glances.sh"]="0.0.3"
  	["support/support-hashcat.sh"]="0.0.4"
	["support/support-hackingtool.sh"]="0.0.3"
	["support/support-hashcat.sh"]="0.0.4"
        ["support/support-hcxdump.sh"]="0.0.4"
	["support/support-hcxdump_dorcascan.sh"]="0.0.4"
	["support/support-hcxdump_full.sh"]="0.0.4"
	["support/support-hcxdump.sh"]="0.0.4"
	["support/support-hcxdump-pmkid.sh"]="0.0.4"
	["support/support-hcxdump.redo.sh"]="0.0.4"
        ["support/support-ican-haz-internet.sh"]="0.0.3"
	["support/support-inst-standard.sh"]="0.0.3"
	["support/support-linux_connection_script.sh"]="0.0.3"
	["support/support-makeWordlist.sh"]="0.0.3"
	["support/support-monitor.sh"]="0.0.4"
	["support/support-makeWordlist.sh"]="0.0.3"
	["support/support-nano.sh"]="0.0.3"
	["support/support-netadapter.sh"]="0.0.4"
	["support/support-ohmy.sh"]="0.0.4"
	["support/support-Prompt_func.sh"]="0.0.4"
	["support/support-sysinfo.sh"]="0.0.4"
	["support/support-trap-wifi.sh"]="0.0.3"
	["support/support-updates.sh"]="0.0.3"
	["support/support-webmin.sh"]="0.0.3"
	["support/support-wifite.sh"]="0.0.3"
	["support/support-wpa.sh"]="0.0.3"
	["support/trap-master.sh"]="0.0.3"
)
