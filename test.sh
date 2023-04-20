#!/bin/bash

set -e

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Beesoc's Easy Linux"
TITLE="Application Installer"
MENU="Choose one of the following options:"

OPTIONS=(1 "Docker Desktop"
         2 "Hacking Tool"
         3 "Airgeddon"
         4 "Must-have built-in apps"
#         5 "Other"
         )

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "You chose Option 1, Docker Desktop"
            ;;
        2)
            echo "You chose Option 2, Hacking Tool"
            ;;
        3)
            echo "You chose Option 3, Airgeddon"
            ;;
        4)  
            echo "You chose Option 4, Must-have built-in tools"
            ;;
#        5)
#            echo "You chose Option 5, Other"
#            ;;
esac
