#!/bin/bash
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
set -e
source "${scripts_dir}/support/support-Banner_func.sh"
printf "\\n    ${OG}install docker requirements, but first...\\n"
printf "  ${CY}This script will install Docker Desktop.${GN}" 
read -n 1 -r -p "Do you want to continue? [Y/n] "instdocker
instdocker=${instdocker:-Y}
    if [[ "$instdocker" =~ ^[Nn]$ ]]; then
        printf "${RED}  User chose no. Exiting"
        exit 0
    if [[ "$instdocker" =~ ^[Yy]$ ]]; then
printf "    ${CY}General maintenance: sudo apt --fix-broken install -y${NC}\\n"
printf "    ${CY}Installing dependencies. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
  sudo apt --fix-broken install -y > /dev/null
  sudo apt install -y docker docker-compose wmdocker python3-dockerpty docker.io uidmap rootlesskit golang-github-rootless-containers-rootlesskit-dev containerd runc tini cgroupfs-mount needrestart golang-github-gofrs-flock-dev golang-github-gorilla-mux-dev golang-github-insomniacslk-dhcp-dev golang-github-moby-sys-dev golang-github-sirupsen-logrus-dev golang-golang-x-sys-dev libsubid4
  fi
  printf "    ${CY}Installing dependencies. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
  sudo apt --fix-broken install -y > /dev/null
  printf "${OG}Install ${WT}Docker-desktop requirements QEMU${NC}\\n"
  sudo apt install -y qemu-system-x86
  printf "${OG}Installing ${WT}kernel modules for kvm_intel ${OG}and add kvm to your Groups.${NC}\n"
  sudo modprobe kvm_intel
  sudo usermod -aG kvm $USER 
  sudo usermod -aG kvm root
  printf "    ${CY}Installing dependencies. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
  sudo apt install -y docker.io sen skopeo ruby-docker-api python3-dockerpycreds python3-ck podman podman-compose libnss-docker golang-github-opencontainers-runc-dev golang-github-fsouza-go-dockerclient-dev golang-github-docker-notary-dev golang-github-containers-image-dev golang-docker-credential-helpers elpa-dockerfile-mode due docker-registry distrobox crun catatonit buildah auto-apt-proxy
  printf "    ${CY}Removing old packages. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
  sudo apt remove -y docker-desktop > /dev/null
  rm -r $HOME/.docker/desktop
  sudo rm /usr/local/bin/com.docker.cli
  sudo apt remove -y docker-desktop > /dev/null
  sudo apt --fix-broken install -y
  sudo apt install -y gnome-terminal plocate > /dev/null
  sudo docker completion bash && docker completion zsh
  printf "${CY}Grab docker's key and install docker-ce.${NC}\\n"
  sudo apt install -y ca-certificates curl gnupg lsb-release > /dev/null
  if [ -d $install_keyrings ]; then
        printf " \n";
          cd $install_keyrings || exit
        printf "  \n";
        else
          mkdir /etc/apt/keyrings
        fi
  sudo chmod 0755 /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" |\
sudo tee /etc/apt/sources.list.d/docker-ce.list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  printf "  ${CY}Performing an apt update and then installing ${WT}Docker Desktop.${CY}"
  sudo apt-get update > /dev/null
  sudo apt-get install docker-ce docker-ce-cli containerd.io pass > /dev/null
  printf  "  ${CY}Install Docker Desktop${NC}\\n"

  wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.19.0-amd64.deb
  sudo dpkg -i ./docker-desktop-4.19.0-amd64.deb
  sudo /opt/docker-desktop/bin/com.docker.admin completion bash
  sudo /opt/docker-desktop/bin/com.docker.admin completion zsh
  sudo apt --fix-broken install -y > /dev/null
  sudo apt autoremove -y > /dev/null
  systemctl --user start docker-desktop
