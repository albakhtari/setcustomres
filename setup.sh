#!/bin/bash

if [[ ! $(whoami) = "root" ]]; then
    echo "Please run this script using sudo or as root."
    exit 1
fi

if [[ "$#" -ne 1 ]] || ! ([[ "$1" = "install" ]] || [[ "$1" = "uninstall" ]]); then
    echo "Invalid usage!"
    echo "Correct usage: ./setup.sh install|uninstall"
    exit 1
fi

if [[ "$1" = "uninstall" ]]; then
    echo "Uninstalling setcustomres\!"
    read -n1 -p "Are you sure? [Y/N] : " userinput

    case $userinput in
      y|Y) rm -rf /usr/bin/setcustomres; \
      rm -rf /usr/share/licenses/setcustomres; \
      echo "setcustomres uninstalled successfully!";;
      *) echo "Aborting installation!"; exit 1;;
    esac
elif [[ "$1" = "install" ]]; then
    install -Dm755 setcustomres.sh /usr/bin/setcustomres
    install -Dm644 LICENSE /usr/share/licenses/setcustomres/LICENSE
    echo "setcustomres installed\!"
fi