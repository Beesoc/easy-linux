#!/bin/bash
# Version: 0.0.2
# check internet connection
set -e

internet=""
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
printf "${YW}[*]    Checking Internet Connection ..."
sleep 1 && printf "..." && sleep 1 && printf "..."
echo
if curl -s -m 10 https://www.google.com >/dev/null || curl -s -m 10 https://www.github.com >/dev/null; then
	printf "${GN}[✔] Internet connection is OK [✔]"
	echo
	printf "${GN}[*] Script is continuing ..."
	internet=1
else
	printf "    ${RED}No Internet Connection can be detected."
	internet=0
fi
if [[ $internet == 1 ]]; then
	printf "  ${BL}Your internet status is $internet."
elif [[ $internet == 0 ]]; then
	printf "  ${RED}Your internet status is $internet."
fi
