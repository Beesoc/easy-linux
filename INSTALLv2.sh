#!/bin/bash
# New app installer from Github
function help {
        echo
        echo "Usage: $0 [options]"
        echo "  This is the help menu for the app installer for Beesoc's Easy Linux Loader."
        echo "  No extra parameters can be applied to the installer at this point."
    echo "Make it executable with 'sudo chmod +x $0' then run with .$0"
        echo
        echo
        echo "Options:"
        echo "  -h, --help: Display this help information."
        echo "  -v, --version: Display the version information."
        echo
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        help
        exit 0
elif [[ "$1" == "-v" || "$1" == "--version" ]]; then
        echo "The script is version 0.0.4."
        exit 0
fi
# Version: 0.0.4
scripts_dir=/opt/easy-linux
set -e

BK='\e[0;44;30m'
RED='\e[1;31m'
GN='\e[1;32m'
CY='\e[1;36m'
WT='\e[1;37m'
OG='\e[1;93m'
OGG='\e[0;32;44m'
OGF='\e[0;33;44m'
OGH='\e[0;30;44m'
NC='\e[0m'

Banner_func() {
        printf "${WT}\\n"
        printf "${OGH}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${OGG}${RED}\\n"
        printf "    ▄████▄${BK}╗    ${RED}▄████▄${BK}╗   ${RED}▄████▄${BK}╗    ${RED}▄████▄${BK}╗     ${RED}▄███▄${BK}╗     ${RED}▄███▄${BK}╗  ${RED}██${BK}╗  ${RED}▄████▄${BK}╗    ${NC}\\n"
        printf "${OGG}    ${OG}██${BK}═══${OG}██${BK}╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔═══╝   ${OG}██${BK}╔════╝    ${OG}██${BK}╔══${OG}██${BK}╗   ${OG}██${BK}╔══${OG}▀${BK}╝   ${OG}▀${BK}╝ ${OG}██${BK}╔════╝${NC}${OGG}    ${NC}\\n"
        printf "${OGG}    ${OG}██████${BK}╝    ${OG}█████${BK}╗    ${OG}█████${BK}╗     ${OG}▀████▄${BK}╗    ${OG}██${BK}║  ${OG}██${BK}║   ${OG}██${BK}║           ${OG}▀████▄${BK}╗${OGG}    ${NC}\\n${NC}"
        printf "${OGG}    ${OG}██${BK}═══${OG}██    ${OG}██${BK}╔══╝${OG}    ██${BK}╔══╝      ╚═══${OG}██${BK}║   ${OG}██${BK}║  ${OG}██${BK}╝   ${OG}██${BK}║  ${OG}▄${BK}╗        ╚═══${OG}██${BK}║${OGF}   \\n"
        printf "    ${OGF}▀████▀${BK}╝    ${OGF}▀████▀${BK}╗   ${OGF}▀████▀${BK}╗    ${OGF}▀████▀${BK}╝     ${OGF}▀███▀${BK}╝${OGF}     ▀███▀${BK}╝${OGF}       ▀████▀${BK}╝   ${BK} \\n"
        printf "     ${BK}╚══╝       ╚═══╝     ╚═══╝      ╚══╝        ╚═╝        ╚═╝          ╚══╝      \\n${OGG}"
        printf "${OGG}    ${OGG}▄████▄${BK}╗   ${OGG}▄█▄${BK}╗    ${OGG}▄███▄${BK}╗  ${OGG}██${BK}╗   ${OGG}██${BK}╗   ${OGG}▄█${BK}╗    ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗  ${OGG}▄█${BK}╗ ${OGG}▄█${BK}╗ ${OGG} ▄█${BK}╗ ${OGG}██▄${BK}╗  ${OGG}▄██${BK}╗  \\n"
        printf "${GN}    ${GN}██${BK}╔═══╝  ${GN}██${BK}║${GN}██${BK}╗  ${GN}██${BK}╔═══╝  ${GN}▀██▄▄██▀${BK}╝   ${GN}██${BK}║    ${GN}██${BK}║ ${GN}█${BK}${GN}██▄${BK}╗${GN}██${BK}║${GN} ██${BK}║  ${GN}██${BK}║  ${GN}▀██▄██▀${BK}╝${GN}   \\n"
        printf "${OGG}    ${GN}█████${BK}╗  ${GN}███▀███${BK}║  ${GN}▀███▄${BK}╗    ${GN}▀██▀${BK}╔╝    ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██▀████${BK}║ ${GN}██${BK}║  ${GN}██${BK}║   ${GN} ███${BK}║     \\n  "
        printf "  ${GN}██${BK}╔══╝  ${GN}██${BK}╔══${GN}${OGG}${GN}██${BK}║      ${GN}██${BK}║    ${GN}██${BK}║      ${GN}██${BK}║    ${GN}██${BK}║ ${GN}██${BK}║ ${GN}███${BK}║ ${GN}██${BK}║  ${GN}██${BK}║  ${GN}▄██${BK}${GN}▀██${BK}${BK}╗    \\n"
        printf "  ${WT}${OGG}   ${WT}▀███▀${BK}╝ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝     ${WT}██${BK}║      ${WT}▀████${BK}╗ ${WT}██${BK}║ ${WT}██${BK}║  ${WT}██${BK}║  ${WT}▀███▀${BK}╝  ${WT}██▀${BK}╝  ${WT}▀██${BK}╗  \\n   ${BK}"
        printf "${OGG}  ${BK} ╚══╝  ${BK}╚═╝  ${BK}╚═╝   ${BK}╚═╝       ${BK}╚═╝       ${BK}╚═══╝ ${BK}╚═╝ ${BK}╚═╝  ${BK}╚═╝   ${BK}╚══╝   ${BK}╚═╝    ${BK}╚═╝  ${OGH}
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄\\n"
        printf "${NC}${CY}"

        #  █ ▌▀ ▄ ╚ ╝ ╔ ╗ ═ ║  Characters used in the banner.
        #
}


cleanup_func() {
        # Step 7 function. End.
        clear
        Banner_func
        printf "${WT}\\n   [*] ${CY}Please Wait while I cleanup some files used in the installation. ${NC}\\n"
        
        printf "   ${WT}[*] ${GN}Success: ${WT}Beesoc's Easy Linux Loader ${GN}has been installed.\\n\\n"
        printf "   ${GN}Use the option on your ${WT}Apps menu ${GN}or enter [ ${WT}easy-linux.sh${GN} ]\\n"
        printf "   from ${WT}any Terminal ${GN}to access. Thanks for using ${WT}Beesoc's Easy Linux Loader${GN}!\\n${CY}"
        echo
        
        printf "\\n${CY}      Hey ${WT}$USER${CY}, would you like to launch \\n${WT}      "
        read -n 1 -r -p "Beesoc's Easy Linux Loader now? [Y/n] " launchnow
        launchnow=${launchnow:-Y}
        if [[ $launchnow =~ ^[Yy]$ ]]; then
                printf "${GN}\\n   Starting Beesoc's Easy Linux now....\\n"
                bash /opt/easy-linux/install/menu-master.sh
        else
                echo
                printf "\\n       ${RED}Exiting.\\n"
                echo
                exit 0
        fi

}

misc_func() {
# Check the user's current shell
shell="$SHELL"
rc_file=""

# Determine the RC file based on the current shell
if [[ "$shell" == *'"/bash"' ]]; then
        rc_file="$HOME/.bashrc"
        rc=$(cat $HOME/.bashrc | grep "truecolor" -c)
        pcheckbash=$(cat $HOME/.bashrc | grep "PATH=/opt/easy-l" -c)
        if [ $pcheckbash == 0 ];then
        	echo "export PATH=/opt/easy-linux/install:$PATH" >> sudo tee -a $HOME/.bashrc
              	echo "export PATH=/opt/easy-linux/support:$PATH" >> sudo tee -a $HOME/.bashrc
                return 0
        fi
        if [[ $rc == 0 ]]; then
                sudo echo "export COLORTERM=truecolor" >> sudo tee -a $HOME/.bashrc
                sudo echo "export COLORFGBG=15;0" >> sudo tee -a $HOME/.bashrc
                return 0
        fi
fi
if [[ "$shell" == *'"/zsh"' ]]; then
        rc_file="$HOME/.zshrc"
        zc=$(cat $HOME/.zshrc | grep "truecolor" -c)
        pcheckzsh=$(cat $HOME/.zshrc | grep "PATH=/opt/easy-l" -c)
        if [ $pcheckzsh == 0 ]; then
        	echo "export PATH=/opt/easy-linux/install:$PATH" >> sudo tee -a $HOME/.zshrc
              	echo "export PATH=/opt/easy-linux/support:$PATH" >> sudo tee -a $HOME/.zshrc
                return 0
        fi
        if [[ $zc == 0 ]]; then
                echo "export COLORTERM=truecolor" >> sudo tee -a $HOME/.zshrc
                echo "export COLORFGBG=15;0" >> sudo tee -a $HOME/.zshrc
                return 0
        fi
fi

# Check if the RC file contains the command_not_found_handle function
if [[ -f "$rc_file" ]]; then
    if ! grep -q "command_not_found_handle()" "$rc_file"; then
        # Append the function to the end of the RC file
        cat >> "$rc_file" <<EOL

# Command Not Found Handler
command_not_found_handle() {
    local package="\$1"

    echo "Command '\$package' not found."

    # Check if sudo is installed
    if ! command -v sudo &> /dev/null; then
        echo "sudo is not installed. Please install sudo to proceed."
        if apt-cache show sudo &> /dev/null; then
            read -n 1 -p "Do you want to install sudo now? [Y/n] " instsudo
            instsudo=\${instsudo:-Y}
            if [[ "\$instsudo" =~ ^[yY]$ ]]; then
                apt-get install -y sudo
            else
                printf "%s has chosen not to install sudo. Exiting." "\$USER"
                exit 0
            fi
        else
            printf "I cannot find sudo in your apt-cache. Exiting."
            exit 1
        fi
    fi

    # Check if the package is available
    if apt-cache show "\$package" &> /dev/null; then
        read -n 1 -p "Package '\$package' is available. Do you want to install it now? [Y/n] " instcomm
        instcomm=\${instcomm:-Y}
        if [[ "\$instcomm" =~ ^[yY]$ ]]; then
            sudo apt-get install -y "\$package"
        else
            printf "%s has chosen not to install. Exiting." "\$USER"
            exit 0
        fi
    else
        printf "Package '%s' not found in the repositories. Cannot install." "\$package"
        exit 1
    fi
}
EOL
        printf "Added the command_not_found_handle function to $rc_file"
        cleanup_func
        return 0
    else
        printf "The $rc_file already contains the command_not_found_handle function."
        cleanup_func
        return 0  
    fi
else
    printf "The $rc_file does not exist. Cannot insert the command_not_found_handle function."
    cleanup_func
fi

cleanup_func

sudo touch ${scripts_dir}/support/.last_update
sudo chown -vR $USER:0 ${scripts_dir}/support/.last_update

}
command_not_found_handle() {

    # Check if sudo is installed
    if ! command -v sudo &> /dev/null; then
        echo "sudo is not installed. Please install sudo to proceed."
        if apt-cache show sudo &> /dev/null; then
            read -n 1 -r -p "Do you want to install sudo now? [Y/n] " instsudo
            instsudo=${instsudo:-Y}
            if [[ "$instsudo" =~ ^[yY]$ ]]; then
                apt-get install -y sudo
            else
                printf "%s has chosen not to install sudo. Exiting." "$USER"
                exit 0
            fi
        else
            printf "I cannot find sudo in your repositories. Exiting."
            exit 1
        fi
    fi

    # Check if Git is available
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Please install Git to proceed."
        if apt-cache show git &> /dev/null; then
        read -n 1 -r -p "Do you want to install it now? [Y/n] " instcomm
        instcomm=${instcomm:-Y}
            if [[ "$instcomm" =~ ^[yY]$ ]]; then
                sudo apt-get install -y git
            else
                printf "%s has chosen not to install git. Exiting." "$USER"
                exit 0
            fi
        else
            printf "Package git not found in the repositories. Cannot install."
            exit 1
        fi
   fi
clear
Banner_func
}

git_files_func() {
        # step 6 function.
        printf "  ${WT} \\n  [*] ${GN}Cloning remote Git repo.${OG}\\n  "
        sleep 1
        sudo git clone https://github.com/Beesoc/easy-linux.git /opt/easy-linux

        sudo chown -vR $USER:0 /opt/easy-linux
        sudo chmod +x /opt/easy-linux/support/*.sh
        sudo chmod +x /opt/easy-linux/*.sh
  
  if [ -d /usr/share/applications ]; then
        sudo mv /opt/easy-linux/install/easy-linux.desktop /usr/share/applications/
  fi
        sudo chmod +x /opt/easy-linux/install/*.sh
        sudo chmod +x /opt/easy-linux/support/misc/*.sh
        sudo cp -f /opt/easy-linux/install/menu-master.sh /usr/bin/easy-linux.sh

    misc_func
}

install_func() {
        # Step 5 function.
        # Banner_func
        printf "${WT}\\n  [*] ${GN}Dependencies satisfied.\\n\\n  ${WT}[*]${OG} "
        sleep 1
        read -n 1 -r -p "Do you want to install Easy Linux Loader? [Y/n] " choiceez
        choiceez=${choiceez:-Y}
        if [[ "$choiceez" =~ ^[Yy]$ ]]; then
                #if [[ $choiceez = "Y" ]] || [[ $choiceez = "y" ]]; then
                printf "\\n${WT}  [*] ${CY}Installation confirmed...\\n"
                sleep 1
                printf "..Please wait..\\n"
                sleep 1
        elif [[ "$choiceez" =~ ^[Nn]$ ]]; then
                #elif [[ $choiceez = "n" ]] || [[ $choiceez = "N" ]]; then
                printf "\\n${WT}  [*] ${OG}Installation rejected...\\n"
                exit 0
        else
                printf "\\n${WT}  [*]  ${RED}Invalid Selection. Exiting.\\n"
                exit 1
        fi
        git_files_func
}
check_directories_func() {
        # Step 2 or 4 function.
        if [[ -d /opt/easy-linux ]]; then
                printf "  ${WT}[*] ${CY}/opt/easy-linux ${CY}directory found.\\n"
                printf "  ${WT}[*] ${CY}Removing and recloning repository.\\n"
                sleep 1
                sudo rm -fr /opt/easy-linux
        elif [[ ! -d /opt/easy-linux ]]; then
                printf "\\n ${WT} [*] ${WT}/opt/easy-linux ${CY}directory not found. Cloning repo into that folder.\\n"
                sleep 1
        fi
        install_func
}

direnv_func() {
        # Step 3 or skip function.
        
        printf "\\n${WT}  [?]${OG} "
        read -n 1 -r -p "DIRENV is not installed. Do you want me to install it? [y/N] " choicedirenv
        choicedirenv=${choicedirenv:-N}
        if [[ "$choicedirenv" =~ ^[Yy]$ ]]; then
                printf "\\n${GN}  Continuing...\\n"
                printf "  ${CY}Please wait.\\n${NC}"
                sudo apt update
                sudo apt install -y direnv
                if [[ -f $HOME/.bashrc ]]; then
                echo "eval $(direnv hook bash)" >> sudo tee -a $HOME/.bashrc
                elif [[ -f $HOME/.zshrc ]]; then
                echo "eval $(direnv hook zsh)" >> sudo tee -a $HOME/.zshrc
                else
                printf "${RED}  ERROR: I couledn't find your .bashrc or .zshrc file.\\n" 
                printf "Please check the Direnv website for instructions on how to proceed:\\n"
                printf "https://direnv.net/docs/hook.html\\n"
                fi
        elif [[ "$choicedirenv" =~ ^[nN]$ ]]; then
        printf "\\n${WT}  [-] ${CY}Direnv is nice but not required. Continuing.\\n"
        fi
        check_directories_func
}

main() {
        # 1.  script starts executing here.
        clear
        Banner_func
        command_not_found_handle

        printf "\\n${GN}    Welcome to the Installer for ${WT}Beesoc's Easy Linux${GN}    Press ${RED}[ctrl+c] ${GN}to cancel\\n${CY}\\n"
        printf "${WT}  [?] ${OG}Do you want to ${WT}check dependencies ${OG}"
        read -n 1 -r -p "for Beesoc's Easy Linux Loader? [Y/n] " install
        install=${install:-Y}
        if [[ "$install" =~ ^[Yy]$ ]]; then
                printf "\\n  ${WT}[*] ${CY}Loading, Please Wait\\n"
        else
                printf "\\n  ${RED}   Exiting.\\n"
                exit 0
        fi
        # check for requirements.
        if command -v /usr/bin/direnv >/dev/null 2>&1; then
                check_directories_func
        else
                direnv_func
        fi
}

main
