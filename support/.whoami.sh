#!/bin/bash
# Capture user's username and computer name

FLAG_FILE=/opt/easy-linux/.envrc_populated

if [ ! -f "$FLAG_FILE" ]; then

  # Function to populate .envrc file
  function populate_envrc() {
#sudo chown 1000:0 /opt/easy-linux/.envrc
    # Add more environment variables as needed
#    echo "export MY_VAR=my_value" >> /opt/easy-linux/.envrc
sudo echo "export docker_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export fatrat_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export hacktool_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export hcxdump_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export nano_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export webmin_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export wifite_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export stand_install=0" >> ${scripts_dir}/.envrc 
sudo echo "export airc_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export airc_deps_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export airg_deps_inst=0" >> ${scripts_dir}/.envrc
sudo echo "export airg_installed=0" >> ${scripts_dir}/.envrc
sudo echo "export user=$USER" >> ${scripts_dir}/.envrc
sudo echo "export username=$(whoami)" >> ${scripts_dir}/.envrc
sudo echo "export useraccount=$(getent passwd 1000 | cut -d ":" -f 1))" >> ${scripts_dir}/.envrc
sudo echo "export computername=$HOST" >> ${scripts_dir}/.envrc
sudo echo "export hostname=$HOST" >> ${scripts_dir}/.envrc
sudo echo "export arch=$(uname -m)" >> ${scripts_dir}/.envrc
sudo echo "export wordlist=/usr/share/wordlists/Top304Thousand-probable-v2.txt" >> ${scripts_dir}/.envrc
sudo echo "export amiPwn=$(if [ -f "/etc/pwnagotchi/config.toml" ]; then echo 1; else echo 0; fi)" >> ${scripts_dir}/.envrc
}

# Populate the envrc table
populate_envrc

# Update flag to indicate function has ran.
touch "$FLAG_FILE"
fi

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

cd /opt/easy-linux || exit
direnv allow
sudo direnv allow

}
