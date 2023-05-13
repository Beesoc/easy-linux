#!/bin/bash
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
clear
source ${scripts_dir}/support/support-Banner_func.sh
# Verify the user and computer name in three different ways
VERIFY_HOST=$(hostname)
VERIFY_ETC_HOSTNAME=$(cat /etc/hostname)

# Verify computer name using three different methods
if [ $computername != $(echo $HOST) ]; then
  printf "${OG}  Warning: computer name does not match \$HOST" >&2
fi
if [ $computername != $(cat /etc/hostname) ]; then
  printf "${OG}  Warning: computer name does not match /etc/hostname" >&2
fi
if [ $computername != $(uname -n) ]; then
  printf "${OG}  Warning: computer name does not match uname -n" >&2
fi
if [ $username != $userid ] && [ $userid != $useraccount ]; then
  printf "${OG}  Warning: Username does not match $USER" >&2
fi
