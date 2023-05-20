#!/bin/bash
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
trap "${scripts_dir}/support/support-trap-wifi.sh" EXIT
source ${scripts_dir}/support/support-Banner_func.sh
echo
printf "${OG}                      Troubleshooting War Room  \\n"
