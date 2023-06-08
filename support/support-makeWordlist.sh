#!/bin/bash
#
#  Script to merge wordlists, sort and eliminate duplicates
set -e
# Version: 0.0.3
scripts_dir=/opt/easy-linux
#
#trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
#export PS4="\$LINENO: "
#set -xv
# colors for printf
source ${scripts_dir}/.envrc

backup_func() {
    backup_dir=/usr/share/wordlists
	backup="${file1}_$(date +%Y-%m-%d_%H-%M-%S).bak"
	sudo cp "$backup_dir"/"${file1}" "${backup_dir}"/"${backup}"
	printf "${CY}  Your backup was saved to ${WT}"$backup_dir"/"${backup}"\\n"
}

# function to merge another file
merge_another_func() {
	sudo chown $USER:$USER $backup_dir/${file1} $backup_dir/${file2}
	cat $backup_dir/${file1} | sudo tee -a $backup_dir/${file2}
}

add_another_func() {
	ls /usr/share/wordlists
	printf "${GN}\\n  "
	read -n 1 -r -p "  Would you like to add another file? [y/N] ----> " anotherfile
	anotherfile=${anotherfile:-N}
	if [[ "${anotherfile}" = "N" ]] || [[ "${anotherfile}" = "n" ]]; then
		printf "${RED}[✘] Finished adding files [✘]${NC}\\n"
		clear
	elif [[ ${anotherfile} = "Y" ]] || [[ ${anotherfile} = "y" ]]; then
		printf "\\n   ${WT}[*] ${CY}The file you are merging into is still ${BL}${file2}.\\n  ${OG}"
		read -r -p "Enter the additional filename to merge" file1
		backup_func
		merge_another_func

	else
		printf "  ${RED}Invalid selection.\\n"
	fi
}

# Function to merge
merge_func() {
	sudo chown $USER:$USER $backup_dir/${file1} $backup_dir/${file2}
	cat $backup_dir/${file1} | sudo tee -a $backup_dir/${file2}
}

#
main() {
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	printf "${OG}This script will join, or concatenate, 2 files, then remove duplicates.\\n"
	printf "\\n${WT}The 2 files ${RED}must be IN THIS FOLDER. ${WT}Copy files to this location, if needed.${WT}\\n"
	printf "Here are the contents of your current wordlist directory:\\n        ${GN}\\n"
    cd /usr/share/wordlists | exit
    ls /usr/share/wordlists
	printf "${GN}\\n  ${OG} "
	read -r -p "[???] Enter the 1st file to merge [???] ----> " file1
	printf "${BL}NOTE:  ${WT}A backup will be made of 2nd file before editing.${GN}\\n"
	printf "${BL}  NOTE: ${WT}The 1st file, ${file1} will be merged ${RED}INTO ${WT}this one.\\n     ${GN}"
	read -r -p "[???] Now enter the 2nd file to merge [???] ----> " file2

	backup_func
	merge_func
	printf " \\n"
	add_another_func
	#  If no additional files are requested, sort and eliminate dups.
	printf "Running [ LC_ALL=C sort -u $backup_dir/${file2} ] to remove dups and sort.\\n"
	LC_ALL=C sort -u $backup_dir/"${file2}"
	printf "${CY}All operations completed.\\n\\n${OG}"
	printf " Your new wordlist file, $backup_dir/${file2}, has been \\n"
	printf " joined together and dupliates have been removed.\\n"
}
main
