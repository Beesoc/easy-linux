#!/bin/bash
# Version: 0.0.2
scripts_dir=/opt/easy-linux
source ${scripts_dir}/.envrc

zsh_install() {
	printf "ZSH was not found. ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
	read -n 1 -t 300
	sudo apt install -y zsh
}

default_shell_func() {
	read -n 1 -p "What do you want as your default shell, [Z]SH or [B]ASH? [Z/b] " defaultshell
	defaultshell=${defaultshell:-Z}
	if [[ "$defaultshell" =~ ^[Zz] ]]; then
             if ! command -v zsh &>/dev/null; then
                zsh_install
		sudo chsh -s $(which zsh)
	     fi
	elif [[ "$defaultshell" =~ ^[Bb] ]]; then
		sudo chsh -s $(which bash)
	else
		printf "${CY}Invalid selection.\\n"
		exit 0
	fi
}

main() {
	my_shell=$(echo $SHELL)
	clear
	source ${scripts_dir}/support/support-Banner_func.sh
	printf "  ${CY}Here you can easily install the Oh My BASH and Oh My ZSH projects\\n"
	printf "  to greatly enhance your terminal. I LOVE these projects.\\n"
	printf "  ${CY}Your current shell is ${WT}$my_shell.\\n"
	default_shell_func
	echo
	echo
	printf "\\n  ${CY}Do you want install Oh My BASH or Oh My ZSH? [Z/b] \\n"
	read -r -n 1 -s shellchoice
	shellchoice=${shellchoice:-Z}
	if [[ "$shellchoice" =~ ^[bB]$ ]]; then
		if [[ ! -d $HOME/.oh-my-bash ]]; then
			bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
		elif [[ -d $HOME/.oh-my-bash ]]; then
			printf "  Oh My BASH already installed.\\n"
		fi
	elif [[ "$shellchoice" =~ ^[zZ]$ ]]; then
		if ! command -v zsh &>/dev/null; then
			zsh_install
		else
			printf "ZSH is already installed.  Continuing\\n"
			if [[ -d $HOME/.oh-my-zsh ]]; then
				printf "  ${CY}You have already installed Oh My ZSH!\\n"
				printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
				read -n 1 -t 300
				source ${scripts_dir}/menu-master.sh
			elif [[ ! -d $HOME/.oh-my-zsh ]]; then
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
				source ${scripts_dir}/menu-master.sh
			fi
		fi
	else
		printf "  ${RED}Invalid Selection. \\n"
		exit 0
	fi
}

main
