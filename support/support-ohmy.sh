                        my_shell=$(echo $SHELL)
                        printf "  ${CY}Here you can easily install the Oh My BASH and Oh My ZSH projects\\n"
                        printf "  to greatly enhance your terminal. I LOVE these projects.\\n"
                        printf "  ${CY}Your current shell is ${WT}$my_shell."
                        read -n 1 -s -p "Do you want Oh My [B]ASH, or Oh My [Z]SH? [B/z] " shellchoice
                        shellchoice=${shellchoice:-B}
                        if [[ $shellchoice == "B" ]]; then
                                if [[ $my_shell != "/usr/bin/bash" ]]; then
                                read -p "BASH is not your default shell. Should I make it so? [Y/n] " bash_default
                                bash_default=$(bash_default:-Y)
                                        if [[ $bash_default =~ ^[Yy] ]]; then
                                        sudo chsh -s $(which bash)
                                        elif [[ $bash_default =~ ^[Nn] ]]; then
                                        printf "${WT}$USER ${CY}has selected to NOT change the default shell.\\n"
                                        fi
                                elif [[ $my_shell = "/usr/bin/bash" ]]; then 
                                        if [[ -d $HOME/.oh-my-bash ]]; then
                                        printf "  ${CY}You have already installed Oh My BASH!\\n"
                                        printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
                                        read -n 1 -t 300
                                        source ${scripts_dir}/menu-master.sh
                                        elif  [[ ! -d $HOME/.oh-my-bash ]]; then
                                               bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
                                        fi
                                 fi
                         fi
                     if [[ $shellchoice == "Z" ]]; then
                          if [[ $(zsh --version > /dev/null  2>&1) ]]; then
                                printf "  ${CY}ZSH not found. ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
                                read -n 1 -t 300
                                sudo apt install -y zsh
                          else
                             printf "  ZSH found.  Continuing. \\n"
                          fi
                          if [[ $my_shell != "/usr/bin/zsh" ]]; then
                                read -p "ZSH is not your default shell. Should I make it so? [Y/n] " zsh_default
                                zsh_default=$(zsh_default:-Y)
                                        if [[ $zsh_default =~ ^[Yy] ]]; then
                                        sudo chsh -s $(which zsh)
                                        elif [[ $zsh_default =~ ^[Nn] ]]; then
                                        printf "${WT}$USER ${CY}has selected to NOT change the default shell.\\n"
                                        exit 0
                                        fi
                          elif [[ $my_shell = "/usr/bin/zsh" ]]; then 
                                        if [[ -d $HOME/.oh-my-zsh ]]; then
                                        printf "  ${CY}You have already installed Oh My ZSH!\\n"
                                        printf "  ${CY}Press ${WT}any ${CY}key to continue.\\n\\n"
                                        read -n 1 -t 300
                                        source ${scripts_dir}/menu-master.sh
                                        elif  [[ ! -d $HOME/.oh-my-zsh ]]; then
                                        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                                        source ${scripts_dir}/menu-master.sh
                                        fi      
                           fi
                      fi        
               
