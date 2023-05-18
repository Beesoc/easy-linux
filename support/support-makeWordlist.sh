#!/bin/bash
#
#  Script to merge wordlists, sort and eliminate duplicates
set -e
# Version: 0.0.2
scripts_dir=/opt/easy-linux
#
set -e
#export PS4="\$LINENO: "
#set -xv
# colors for printf
source ${scripts_dir}/.envrc

add_another_func() {
	ls ${pwd}
	printf "${GN}\\n  "
	read -p -r "Would you like to add another file? [y/N] " anotherfile
	anotherfile=${anotherfile:-N}
	if [[ "${anotherfile}" = "N" ]] || [[ "${anotherfile}" = "n" ]]; then
		printf "${RED}[✘] Finished adding files [✘]${NC}\\n"
		clear
	elif [[ ${anotherfile} = "Y" ]] || [[ ${anotherfile} = "y" ]]; then
		printf "\\n   ${WT}[*] ${CY}The file you are merging into is still ${BL}${file2}.\\n  ${OG}"
		read -r -p "Enter the additional filename to merge" file3
		backup_func
		merge_another_func

	else
		printf "  ${RED}Invalid selection.\\n"
	fi
}
# function to backup
backup_func() {
	backup="${file2}_$(date +%Y-%m-%d_%H-%M-%S).bak"
	sudo cp "${file2}" "${backup}"
	printf "${CY}  Your backup was saved to ${WT}\"${backup}\"\\n"
}
# Function to merge
merge_func() {
	sudo chown $USER:$USER ${file1} ${file2}
	cat ${file1} | sudo tee -a ${file2}
}
# function to merge another file
merge_another_func() {
	sudo chown $USER:$USER ${file3} ${file2}
	cat ${file3} | sudo tee -a ${file2}
}
#
main() {
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	printf "${OG}This script will join, or concatenate, 2 files, then remove duplicates.\\n"
	printf "\\n${WT}The 2 files ${RED}must be IN THIS FOLDER. ${WT}Copy files to this location, if needed.${WT}\\n"
	printf "Here are the contents of your current wordlist directory:\\n        ${GN}\\n"
	ls /usr/share/wordlists
	printf "${GN}\\n  ${OG} "
	read -r -p "[???] Enter the 1st file to merge [???] ----> " file1
	printf "${BL}NOTE:  ${WT}A backup will be made of 2nd file before editing.${GN}\\n"
	source support-Prompt_func.sh
	printf "${BL}  NOTE: ${WT}The 1st file, ${file1} will be merged ${RED}INTO ${WT}this one.\\n     ${GN}"
	read -r -p "[???] Now enter the 2nd file to merge [???] ----> " file2

	backup_func
	merge_func
	printf " \\n"
	add_another_func
	#  If no additional files are requested, sort and eliminate dups.
	printf "Running [ LC_ALL=C sort -u ${file2} ] to remove dups and sort.\\n"
	LC_ALL=C sort -u "${file2}"
	printf "${CY}All operations completed.\\n\\n${OG}"
	printf " Your new wordlist file, ${file2}, has been joined together and\\n"
	printf " dupliates have been removed.\\n"
	exit 1
}
main
