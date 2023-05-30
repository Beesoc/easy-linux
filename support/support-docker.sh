#!/bin/bash
# Version: 0.0.3
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc
set -e

install_run_func() {
	wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.19.0-amd64.deb
	sudo dpkg -i ./docker-desktop-4.19.0-amd64.deb
	sudo /opt/docker-desktop/bin/com.docker.admin completion bash
	sudo /opt/docker-desktop/bin/com.docker.admin completion zsh
	sudo apt --fix-broken install -y >/dev/null
	sudo apt autoremove -y >/dev/null
	systemctl --user start docker-desktop
	docker_installed=1
	sudo sed -i "s/docker_installed=.*/docker_installed=$docker_installed/g" "${scripts_dir}/.envrc"
	source ${scripts_dir}/install/menu-master.sh
}

docker_keys() {
	printf "    ${GN}Grab docker's key and install ${WT}docker-ce${NC}.\\n"
	sudo apt install --ignore-missing -y ca-certificates curl gnupg lsb-release
	if [ -d $install_keyrings ]; then
		printf " \n"
		cd $install_keyrings || exit
		printf "  \n"
	else
		mkdir /etc/apt/keyrings
	fi
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo $VERSION_CODENAME)" stable" |
		sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	printf "  \\n${CY}Performing an apt update and then installing ${WT}Docker Desktop.${CY}\\n"
	sudo apt-get update
	sudo apt-get install -y -- ignore-missing docker-ce docker-ce-cli containerd.io pass
	printf "  ${CY}Install Docker Desktop${NC}\\n"
	install_run_func
}

docker_deps_func() {
	# List of package names to install
	packages=("docker" "docker-compose" "wmdocker" "python3-dockerpty" "docker.io" "uidmap" "rootlesskit" "golang-github-rootless-containers-rootlesskit-dev" "containerd" "runc" "tini" "cgroupfs-mount" "needrestart" "golang-github-gofrs-flock-dev" "golang-github-gorilla-mux-dev" "golang-github-insomniacslk-dhcp-dev" "golang-github-moby-sys-dev" "golang-github-sirupsen-logrus-dev" "golang-golang-x-sys-dev" "libsubid4")

	# Loop through the list of package names
	for package in "${packages[@]}"; do
		if dpkg -s "$package" >/dev/null 2>&1; then
			echo "$package is already installed"
		else
			echo "Installing $package"
			sudo apt-get install --ignore missing -y "$package"
		fi
		printf "The first set of dependencies is complete. This set consisted of:\\n ${WT}${packages[*]}."
		# sudo sed -i "s/docker_deps=.*/docker_deps=$docker_deps/g" "${scripts_dir}/.envrc"
	done
	printf "    ${CY}Installing dependencies. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
	sudo apt --fix-broken install -y >/dev/null

	printf "${OG}Install ${WT}Docker-desktop requirements QEMU${NC}\\n"
	sudo apt install -y qemu-system-x86

	printf "${OG}Installing ${WT}kernel modules for kvm_intel ${OG}and add kvm to your Groups.${NC}\\n"
	sudo modprobe kvm_intel
	sudo usermod -aG kvm $USER
	sudo usermod -aG kvm root

	printf "\\n   "
	printf "  ${CY}Installing dependencies. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"

	packages2=("docker.io" "sen" "skopeo" "ruby-docker-api" "python3-dockerpycreds" "python3-ck" "podman" "podman-compose" "libnss-docker" "golang-github-opencontainers-runc-dev" "golang-github-fsouza-go-dockerclient-dev" "golang-github-docker-notary-dev" "golang-github-containers-image-dev" "golang-docker-credential-helpers" "elpa-dockerfile-mode" "due" "docker-registry" "distrobox" "crun" "catatonit" "buildah" "auto-apt-proxy")

	# Loop through the list of package names
	for packages in "${packages2[@]}"; do
		if dpkg -s "$packages" >/dev/null 2>&1; then
			printf "$packages[@] is already installed"
		else
			printf "Installing $packages[@]"
			sudo apt-get install --ignore-missing -y "$packages[@]"
		fi
		docker_deps=1
		sudo sed -i "s/docker_deps=.*/docker_deps=$docker_deps/g" "${scripts_dir}/.envrc"
	done
	printf "The second set of dependencies is complete. This set consisted of:\\n ${WT}${packages2[@]}.\\n"
	printf " \\n "
	printf "    ${CY}Removing old packages. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
	sudo apt remove -y docker-desktop >/dev/null
	if [[ -f $HOME/.docker/desktop ]]; then
		sudo rm /usr/local/bin/cow.docker.cli
	else
		printf "$HOME/.docker/desktop not found."
	fi
	if [[ -f /usr/local/bin/com.docker.cli ]]; then
		sudo rm /usr/local/bin/com.docker.cli
	else
		printf "/usr/local/bin/com.docker.cli/ not found."
	fi
	sudo apt remove -y docker-desktop >/dev/null
	sudo apt --fix-broken install -y
	sudo apt install -y gnome-terminal plocate >/dev/null
	sudo docker completion bash
	sudo docker completion zsh
	docker_keys
}

intro() {
	clear
	source "${scripts_dir}/support/support-Banner_func.sh"
	printf "  ${CY}This script will install ${WT}Docker Desktop${GN}.\\n  "

	read -n 1 -r -p "Do you want to continue? [Y/n] " installdocker
	installdocker=${installdocker:-Y}
	if [[ "$installdocker" =~ ^[Nn]$ ]]; then
		printf "  ${WT}$USER ${RED}chose no to install. Exiting\\n"
		exit 0
	elif [[ "$installdocker" =~ ^[Yy]$ ]]; then
		printf "\\n${CY}  We will first ${WT}install docker requirements${CY}.\\n"
		printf "    ${CY}General maintenance: sudo apt --fix-broken install -y${NC}\\n"
		sudo apt --fix-broken install -y >/dev/null
		printf "\\n    ${CY}Installing dependencies. ${WT}Please wait. ${CY} This may take ${WT}several ${CY}minutes.\\n"
	fi
	docker_deps_func
}

main() {
	if [[ $(command -v docker-desktop) ]]; then
		install_run_func
	fi
	intro

}

main
