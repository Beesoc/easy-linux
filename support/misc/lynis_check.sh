#!/bin/bash
scripts_dir=/opt/easy-linux
#set -e
#Version: 0.0.3
clear
source ${scripts_dir}/support/support-Banner_func.sh
source ${scripts_dir}/.envrc

printf "${OG}Would you like to run ${WT}Lynis ${OG}to ${WT}check your "
read -n 1 -r -p "system's security? [Y/n] " lynis
lynis=${lynis:-y}
printf "\\n${NC}"
if [[ "$lynis" =~ ^[nN]$ ]]; then
	printf "\\n${RED}$USER has opted to NOT check system security. Exiting\\n"
	exit 0
elif [[ "$lynis" =~ ^[yY]$ ]]; then
	if [[ ! -d /usr/local/lynis ]]; then
		sudo mkdir -p /usr/local/lynis
	fi

	# Download the HTML page and extract the download link for the latest version
	download_link=$(curl -sS https://cisofy.com/downloads/lynis/ | grep -oE 'https://downloads.cisofy.com/lynis/lynis-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz' | tail -n 1)

	# Extract the version from the download link
	downloaded_version=$(echo "$download_link" | awk -F'lynis-' '{print $2}' | awk -F'.tar.gz' '{print $1}')

	# Get the installed version of Lynis
	installed_version=$(lynis --version | awk '{print $NF}')

	# Compare the versions
	if [[ $downloaded_version > $installed_version ]]; then
		echo "A newer version of Lynis is available: $downloaded_version"
		echo "Updating Lynis..."

		# Download the tar file
		curl -sS "$download_link" -o lynis.tar.gz

		# Extract the tar file
		tar -xzf lynis.tar.gz

		# Remove the old version
		sudo rm -rf /usr/local/lynis

		# Install the newer version
		sudo mv lynis "$downloaded_version"
		sudo ln -s "$downloaded_version" /usr/local/lynis

		echo "Lynis has been updated to version $downloaded_version"
	else
		printf "${OG}You have the latest version of ${WT}Lynis ${OG}installed: ${CY}${installed_version}\\n"
		printf "\\n${NC}"
	fi

	# Clean up the downloaded tar file
	if [[ -e /usr/local/lynis/lynis.tar.gz ]]; then
		sudo rm lynis.tar.gz
	fi
# Run the audit and save the report using sudo and tee
printf " \\n ${CY}Lynis will now evaluate your system. This process ${WT}may take 5 minutes ${CY}to complete.\\n"
printf " \\n ${GN}Please be patient\\n"
sudo lynis audit system | sudo tee report.txt > /dev/null

# Remove lines containing specified keywords and save modified report using sudo and tee

echo "# Color definitions for Lynis" > lynis.conf
echo "regex=(\[[[:alnum:]]+\])" >> lynis.conf
echo "colors=bold white on_black underline, yellow on_black bold, red on_black bold" >> lynis.conf


sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' report.txt | grep -Ev '\[ OK \]|\[ DONE \]|\[ ENABLED \]|\[ PROTECTED \]|\[ DEFAULT \]|\[ FOUND \]|\[ SKIPPED \]|\[ INSTALLED \]|\[ HARDENED \]|\[ CONFIGURED \]' | awk '{gsub(/\[ SUGGESTION \]/, "\033[33m&\033[0m"); gsub(/\[ WARNING \]/, "\033[31m&\033[0m"); gsub(/\[ WEAK \]|\[ PARTIALLY HARDENED \]|\[ NON DEFAULT \]|\[ UNSAFE \]|\[ EXPOSED \]|\[ MEDIUM \]/, "\033[31m&\033[0m"); gsub(/\[ DIFFERENT \]|\[ NONE \]|\[ NOT FOUND \]|\[ RUNNING \]|\[ YES \]|\[ NO \]|\[ DISABLED \]|\[ NOT ENABLED \]|\[ ACTIVE \]|\[ FILES FOUND \]|\[ NOT RUNNING \]|\[ AUTO \]|\[ NOT DISABLED \]/, "\033[35m&\033[0m"); gsub(/\[ NO UPDATE \]/, "\033[35m&\033[0m"); gsub(/\[ systemd \]/, "\033[34m&\033[0m"); print}' | awk 'BEGIN{OFS=""} /^\+\+/{print "\033[92m" $0 "\033[0m"; next} 1' > filtered_report.txt

#remove the excludes.
sed -r -e 's/\x1B\[[0-9;]*[mK]//g' -e '/\[ OK \]|\[ DONE \]|\[ ENABLED \]|\[ PROTECTED \]|\[ DEFAULT \]|\[ FOUND \]|\[ SKIPPED \]|\[ INSTALLED \]|\[ HARDENED \]|\[ CONFIGURED \]/d' colored_report.txt > filtered_report.txt

##Remove the excludes

sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' report.txt | grep -Ev '\[ OK \]|\[ DONE \]|\[ ENABLED \]|\[ PROTECTED \]|\[ DEFAULT \]|\[ FOUND \]|\[ SKIPPED \]|\[ INSTALLED \]|\[ HARDENED \]|\[ CONFIGURED \]' | awk '/^\* / { printf "\033[1;34m%s\033[0m\n"; next } { print }' > filtered_report.txt

cat filtered_report.txt

#sudo grep -Ev "\[ ok \]|\[ done \]|\[ enabled \]|\[ protected \]|\[ default \]|\[ found \]" report.txt | sudo grep --color=always . | less -R

fi
