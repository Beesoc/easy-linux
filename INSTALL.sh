#!/bin/bash
# 
# Installer script for Beesoc's Easy Linux Loader.
#     define colors
#
scripts_dir=/opt/easy-linux-loader
source .envrc
#printf "${BG}"



install_func() { 
clear
        source support/Banner_func.sh
        source support/Prompt_func.sh
        printf " ${WT} "
    read -p "   Should I overwrite and install to default location? [Y/N]  " install
        if [[ ${install} == "n" ]] || [[ ${install} == "N" ]]; then
            printf "${RED}     You chose not to install. Quiting application"
            exit 1
        elif [[ ${install} == "y" ]] || [[ ${install} == "Y" ]]; then
# add zip files to archive with:
#  sudo zip -rvq -T -9 INSTALL.zip *.sh  

#            if [[ ! command -v unzip &> /dev/null ]]; then
#                printf Prompt_func() {

folder_exists_func() {
  clear
  source /support/Banner_func.sh
if [[ ! -d ${scripts_dir} ]]; then  
    sudo mkdir ${scripts_dir}
elif [[ -d ${scripts_dir} ]]; then  
  printf "${CY}     Installation directory, ${WT}${scripts_dir}${CY}, already exists. ${OG}Overwrite?  ${WT}\\n "
    printf "${NC}\\n     NOTE: ${CY}If you have ${WT}NOT manually customized ${CY}any scripts, you ahould ${WT}always \\n"
    printf "     answer yes ${CY}to this question.\\n\\n"
    printf "${GN}     ---->${OG}"
else
    printf "      Invalid Selection\\n"
fi
}"Unzip could not be found...Installing...\\n"
#                sudo apt install -y zip unzip
 
            command -v unzip >/dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed.  Installing."; sudo apt install -y unzip; }
   
#            elif [[ ! command -v unzip &> /dev/null ]]; then
#                printf "Unzip found...Continuing...\\n"
#            fi

           printf "${CY}Unzipping files into ${scripts_dir}\\n"
            sudo unzip -o *.zip
              sudo cp *.sh ${scripts_dir}
              sudo chmod a+x *.sh
              sudo chown -vR 1000:1000 ${scripts_dir}
        else
            printf "     Invalid selection\\n"
        fi
}

main() {
clear
source support/Banner_func.sh
printf "\\n${OG}                 Welcome to the Installer for Beesoc's Easy Linux.                   ${CY}${NC}\\n" 
printf "\\n${CY}Press ${WT}any ${CY}key to continue.                                 Press ${RED}[ctrl+c] ${CY}to cancel\\n"
#printf "${WT}\\n    ---->"
printf "${WT} \\n"
  read -r -n1 -s -t 60
folder_exists_func
install_func  
}

main
