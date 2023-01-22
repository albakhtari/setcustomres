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
magenta=$'\e[1;35m'

number='^[0-9]+$'
version="2.1"


help()
{
    echo "${yellow}Description:${reset} Set custom resolution to a display using ${bold}xrandr${reset}"
    echo "${yellow}Usage:${reset} setcustomres OPTIONS"
    echo "${yellow}Version:${reset} $version"
    echo ""
    echo "-w | --width            ${bold}Mandatory:${reset} Width of resolution"
    echo "-h | --height           ${bold}Mandatory:${reset} Hight of resolution"
    echo "-o | --output           ${bold}Mandatory:${reset} Display output"
    echo "-r | --refresh-rate     Custom refresh rate (Default 60Hz)"
    echo "-p | --param            xrandr parameters, wrap with double quotes"
    echo "--help                  Print this help message"
    echo ""
    echo ""
    echo ""
    echo "          ---Usage Examples---"
    echo ""
    echo "${cyan}# This sets a custom resolution to HDMI-1${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} ${magenta}-w${reset} 1920 ${magenta}-h${reset} 1080 ${magenta}-o${reset} HDMI-1"
    echo ""
    echo "${cyan}# This sets a custom resolution to DP-1 and maps it to the right of VGA-1${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} ${magenta}--width${reset} 1366 ${magenta}--height${reset} 768 ${magenta}--output${reset} DP-1 ${magenta}--param${reset} ${light_blue}\"--right-of VGA-1\"${reset}"
    echo ""
    echo "${cyan}# This sets a custom resolution to VGA-2 and makes it the primary screen${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} ${magenta}-w${reset} 1680 ${magenta}-h${reset} 1050 ${magenta}-o${reset} VGA-2 ${magenta}-p${reset} ${light_blue}\"--primary\"${reset}"
    echo ""
    echo "${cyan}# This sets a custom resolution to HDMI-1 with a refresh rate of 120Hz${reset}"
    echo "${blue}~\$${reset} ${green}setcustomres${reset} ${magenta}-w${reset} 1600 ${magenta}-h${reset} 900 ${magenta}-o${reset} HDMI-1 ${magenta}-r${reset} 120"
}

printMessage() 
{
    echo -e "\n    ${yellow}[+]${reset} ${bold}$1${reset} \n"
}

printError()
{
    echo -e "\n${red}ERROR:${reset} ${bold}$1${reset} \n"
    exit 1
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

set_resolution() 
{
    width=$1
    height=$2
    output=$3
    param=$4
    refresh=$5
    res="${width}x${height}$([[ "${refresh}" ]] && echo "_${refresh}")"
    
    printMessage "Setting custom resolution of ${width}x${height} to output $output $([[ "$refresh" ]] && echo "at a refresh rate of ${refresh}Hz") $([[ "$param" ]] && echo "\n    With flags: $param")"

    monitor_connected=$(xrandr --listactivemonitors | grep " $output")

    if [[ $monitor_connected = "" ]]; then
        printError "Monitor $output is not active!"
    fi
    
    [[ "$refresh" ]] && cvt="$(echo $res $(cvt "$width" "$height" "$refresh" | tail -1 | cut -d ' ' -f3-))" || cvt="$(echo $res $(cvt "$width" "$height" | tail -1 | cut -d ' ' -f3-))"
    mode=$(echo $cvt | cut -d ' ' -f1)
    status=$(checkMonitorStatus $output $res)
    
    if [[ $status = "false" ]]; then
        xrandr --newmode $(echo $cvt) 2> /dev/null
        xrandr --addmode "$output" "$mode"
    fi
    
    xrandr --output "$output" --mode "$mode" $(echo $param)
}

flags() {

    if [[ "$#" -eq 0 ]]; then
        printError "Missing arguments, parse \"--help\" for more information"
    fi

    while [[ "$1" != "" ]]
    do
        case $1 in
            -v|--version)
                echo "setcustomres v$version"
                exit
                ;;
            --help)
                help
                exit
                ;;
            -w|--width)
                if [[ ! $2 =~ $number ]]; then
                    printError "Invalid value parsed! Only numbers are applicable."
                elif [ "$2" ]; then
                    shift
                    width="$1"
                else
                    printError "\"-w|--width\" requires a non-empty argument"
                fi
                ;;
            -h|--height)
                if [[ ! $2 =~ $number ]]; then
                    printError "Invalid value parsed! Only numbers are applicable."
                elif [ "$2" ]; then
                    shift
                    height="$1"
                else
                    printError "\"-h|--height\" requires a non-empty argument"
                fi
                ;;
            -r|--refresh-rate)
                if [[ ! $2 =~ $number ]]; then
                    printError "Invalid value parsed! Only numbers are applicable."
                elif [ "$2" ]; then
                    shift
                    refresh="$1"
                else
                    printError "\"-r|--refresh-rate\" requires a non-empty argument"
                fi
                ;;
            -o|--output)
                if [ "$2" ]; then
                    shift
                    output="$1"
                else
                    printError "\"-o|--output\" requires a non empty arguments"
                fi
                ;;
            -p|--param)
                if [ "$2" ]; then
                    shift
                    param="$1"
                else
                    printError "\"-p|--param\" requires a non empty arguments"
                fi
                ;;
            --)
                break
                ;;
            -?*)
                printError "Unknown option: $1"
                ;;
            *)
                break
                ;;
        esac

        shift
    done

    if [[ ! "$width" ]]; then
        printError "Missing width value!"
    fi

    if [[ ! "$height" ]]; then
        printError "Missing height value!"
    fi

    if [[ ! "$output" ]]; then
        printError "Missing output!"
    fi

}

flags "$@" # Deal with flags
set_resolution "$width" "$height" "$output" "$param" "$refresh" # Call set_resolution