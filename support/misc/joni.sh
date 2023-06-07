#!/bin/bash
sudo systemctl stop ssh.service

sshd=$(cat /etc/ssh/sshd_config | grep "#Port ")
sshd_port=$(cat /etc/ssh/sshd_config | grep "Port " | awk '{print $2}')
etc_sshd="Port $sshd_port"

ssh=$(cat /etc/ssh/ssh_config | grep "#Port ")
ssh_port=$(cat /etc/ssh/ssh_config | grep "Port " | awk '{print $2}')
etc_ssh="Port $ssh_port"

pubkey="PubkeyAuthentication yes"
kdb="KbdInteractiveAuthentication yes"

echo
echo "SSHD port=$sshd_port     " 
echo "SSH port=$ssh_port"
echo "Both of the fields above should be set to 22443." 
echo


read -n 1 -p "Are both fields above set to 22443? [Y/n] " correct
correct=${correct:-y}
if [[ $correct = y || $correct = Y ]]; then
   sudo sed -i "s/Port $sshd_port*/$etc_sshd/g" /etc/ssh/sshd_config

   sudo sed -i "s/Port $ssh_port*/$etc_ssh/g" /etc/ssh/ssh_config   
elif [[ $correct = n || $correct = N ]]; then 
   printf "\\n"
   read -n 1 -r -p "Port was incorrect. Hardcoding 22443. Continue? [Y/n] " cont
   cont=${cont:-y}
   etc_sshd="Port 22443"
   etc_ssh="Port 22443"
   if [[ "${cont}" =~ ^[yY]$ ]]; then
   sudo sed -i "s/Port $sshd_port*/$etc_sshd/g" /etc/ssh/sshd_config

   sudo sed -i "s/Port $ssh_port*/$etc_ssh/g" /etc/ssh/ssh_config   
   elif [[ "${cont}" =~ ^[nN]$ ]]; then
   echo "Not modifying SSH parameters.  Exiting."   
   else
   echo "Invalid selection.  Please select Y or N only"
   fi
else
   echo "Invalid selection.  Please select Y or N only"
fi

clear
echo 
echo $(cat /etc/ssh/sshd_config | grep "kdbInteractive")
echo $(cat /etc/ssh/sshd_config | grep "PubkeyAuth")
echo $(cat /etc/ssh/sshd_config | grep "UsePAM")
echo $(cat /etc/ssh/sshd_config | grep "PermitRootLogin" | awk '{print $1" " $2}')
echo $(cat /etc/ssh/sshd_config | grep "PasswordAuth" | awk '{print $1" " $2}')
echo 
echo "SSH port is now: $(cat /etc/ssh/ssh_config | grep "Port ")"
echo "SSHD port is now: $(cat /etc/ssh/sshd_config | grep "Port ")"
echo
sudo systemctl restart ssh.service
sudo systemctl restart sshd
echo "Thanks babe!  I appreciate it!"
echo 
