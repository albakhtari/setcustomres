#!/bin/bash

red=$'\e[1;31m'
yellow=$'\e[1;93m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
bold=$'\e[1m'
reset=$'\e[0m'
light_blue=$'\e[94m'
green=$'\e[1;32m'
cyan=$'\e[1;36m'
number='^[0-9]+$'


help()
{
    echo "${yellow}Description:${reset} Set custom resolution to a display using ${bold}xrandr${reset}"
    echo "${yellow}Usage:${reset} setcustomres X Y OUTPUT [XRANDR FLAGS]"
    echo ""
    echo "          ---Usage Examples---"
    echo ""
    echo "${cyan}# This sets a custom resolution to HDMI-1${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} 1920 1080 HDMI-1"
    echo "${cyan}# This sets a custom resolution to DP-1 and maps it to the right of VGA-1${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} 1366 768 DP-1 ${light_blue}\"--right-of VGA-1\"${reset}"
    echo "${cyan}# This sets a custom resolution to VGA-2 and makes it the primary screen${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} 1680 1050 VGA-2 ${light_blue}\"--primary\"${reset}"
}

printMessage() 
{
    echo -e "\n    ${yellow}[+]${reset} ${bold}$1${reset} \n"
}

printError()
{
    echo -e "\n${red}ERROR:${reset} ${bold}$1${reset} \n"
}

checkMonitorStatus()
{
    
    output="$1"
    mode="$2"

    monitor_set="false"
    reached_output="false"

    while read -r line
      do
        if [[ $(echo "$line" | awk '{print $1}') = "$output" ]]; then
            reached_output="true"
        elif [[ $reached_output = "true" ]] && [[ $(echo "$line" | cut -d 'x' -f1) =~ $number ]]; then
            [[ $(echo $line | awk '{print $1}') = "$mode" ]] && monitor_set="true"
        elif ! [[ $(echo "$line" | cut -d ' ' -f1) = "" ]]; then
            reached_output="false"
        fi
    done < <(xrandr)

    echo $monitor_set
}

setCustomRes() 
{
    x=$1
    y=$2
    res="$1x$2"
    output=$3
    flags=$4
    
    printMessage "Setting custom resolution of $res to output $output $([[ "$flags" ]] && echo "with flags: $flags")"

    monitor_connected=$(xrandr --listactivemonitors | grep " $output")

    if [[ $monitor_connected = "" ]]; then
        echo "${red}ERROR:${reset} Monitor is not active!"
        exit 1
    fi
    
    cvt=$(echo $res $(cvt "$x" "$y" | tail -1 | cut -d ' ' -f3-))
    mode=$(echo $cvt | cut -d ' ' -f1)
    status=$(checkMonitorStatus $output $res)

    # echo "Status: $status"
    
    if [[ $status = "false" ]]; then
        xrandr --newmode $(echo $cvt)
        xrandr --addmode "$output" "$mode"
    fi
    
    xrandr --output "$output" --mode "$mode" $(echo $flags)
}

x="$1"
y="$2"
output="$3"
flags="$4"

if [[ "$#" -eq 0 ]]; then
    help
elif [[ "$#" -eq 3 || "$#" -eq 4 ]]; then
    if ! [[ "$x" =~ $number && "$y" =~ $number ]]; then
        printError "Invalid arguments for X or Y"
        help
    else
        setCustomRes "$x" "$y" "$output" "$flags"
    fi
else
    printError "Invalid usage!"
    help
fi