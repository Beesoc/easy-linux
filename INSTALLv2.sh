#/bin/bash
# New app installer from Github
# Version: 0.0.2
sudo git clone https://github.com/Beesoc/easy-linux.git /opt/easy-linux && cd /opt/easy-linux
sudo chown -vR 1000:1000 .
sudo chmod +x *.sh
sudo chmod +x install/*.sh
sudo chmod +x support/*.sh
sudo cp -fr install/*.sh /opt/easy-linux
sudo cp -f install/easy-linux.desktop /usr/share/applications/
