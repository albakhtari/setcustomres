#!/bin/bash

realuser=$(who | awk 'NR==1{print $1}')

if [[ ! $(whoami) = "root" ]]; then
    echo "Please run this script using sudo or as root."
    exit 1
fi

if [[ "$#" -ne 1 ]] || ! ([[ "$1" = "install" ]] || [[ "$1" = "uninstall" ]]); then
    echo "Invalid usage!"
    echo "Correct usage: ./setup.sh install(i)|uninstall(u)"
    exit 1
fi

if [[ "$1" = "uninstall" || "$1" = "u" ]]; then
    echo "Uninstalling setcustomres!"
    read -n1 -p "Are you sure? [Y/N] : " userinput

    case $userinput in
      y|Y) rm -rf /usr/bin/setcustomres; \
      rm -rf /usr/share/licenses/setcustomres; \
      echo -e "\nsetcustomres uninstalled successfully!";;
      *) echo "Aborting!"; exit 1;;
    esac
elif [[ "$1" = "install" || "$1" = "i" ]]; then
    echo "Updating local repository..."
    sudo -u $realuser git pull origin main

    echo ""
    read -n1 -p "Are you sure you want to install setcustomres? [Y/N] : " userinput

    case $userinput in
      y|Y) sudo install -Dm755 setcustomres.sh /usr/bin/setcustomres; \
        sudo install -Dm644 LICENSE /usr/share/licenses/setcustomres/LICENSE; \
        echo -e "\nsetcustomres installed!";;
      *) echo "Aborting installation!"; exit 1;;
    esac
fi