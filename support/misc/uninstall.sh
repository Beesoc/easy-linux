#!/bin/bash
set -e
# uninstaller for Easy Linux
scripts_dir=/opt/easy-linux
# Version: 0.0.3

if [[ -d ${scripts_dir} ]]; then
  sudo rm -rf /opt/easy-linux
fi

if [[ -e /usr/share/applications/easy-linux.desktop ]]; then
  sudo rm /usr/share/applications/easy-linux.desktop
fi

if [[ -e /usr/bin/easy-linux.sh ]]; then
  sudo rm /usr/bin/easy-linux.sh
fi

if [[ $(grep -c "export TERM=xterm-color" "$HOME/.zshrc") == 1 ]]; then
    sudo sed -i '/export TERM=xterm-color=.*/d' "$HOME/.zshrc"
fi


if [[ $(grep -c "export COLORTERM=truecolor" "$HOME/.zshrc") == 1 ]]; then
    sudo sed -i '/export COLORTERM=truecolor=.*/d' "$HOME/.zshrc"
fi


if [[ $(grep -c "export COLORFGBG=15,0" "$HOME/.zshrc") == 1 ]]; then
    sudo sed -i '/export COLORFGBG=15,0=.*/d' "$HOME/.zshrc"
fi

if [[ $(grep -c "command_not_found_handle" $HOME/.zshrc) == 1 ]]; then
    sed -i '/^command_not_found_handle()/,/^}/d' "$HOME/.zshrc"
    echo "The command_not_found_handle function has been removed from $HOME/.zshrc."
fi


if [[ $(grep -c "export TERM=xterm-color" "$HOME/.bashrc") == 1 ]]; then
    sudo sed -i '/export TERM=xterm-color=.*/d' "$HOME/.bashrc"
fi

if [[ $(grep -c "export COLORTERM=truecolor" "$HOME/.bashrc") == 1 ]]; then
    sudo sed -i '/export COLORTERM=truecolor=.*/d' "$HOME/.bashrc"
fi

if [[ $(grep -c "export COLORFGBG=15,0" "$HOME/.bashrc") == 1 ]]; then
    sudo sed -i '/export COLORFGBG=15,0=.*/d' "$HOME/.bashrc"
fi

if [[ $(grep -c "command_not_found_handle" $HOME/.bashrc) == 1 ]]; then
    sed -i '/^command_not_found_handle()/,/^}/d' "$HOME/.bashrc"
    echo "The command_not_found_handle function has been removed from $HOME/.bashrc."
fi


