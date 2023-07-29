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
version="2.2.1"


help()
{
    echo "${yellow}Description:${reset} Set custom resolution to a display using ${bold}xrandr${reset}"
    echo "${yellow}Usage:${reset} setcustomres [OPTIONS]..."
    echo "${yellow}Version:${reset} $version"
    echo ""
    echo "${magenta}-w${reset} | ${magenta}-width${reset} <integer>            ${bold}Mandatory:${reset} Width of resolution"
    echo "${magenta}-h${reset} | ${magenta}-height${reset} <integer>           ${bold}Mandatory:${reset} Hight of resolution"
    echo "${magenta}-o${reset} | ${magenta}-output${reset} <string>            ${bold}Mandatory:${reset} Display output"
    echo "${magenta}-r${reset} | ${magenta}-refresh-rate${reset} <integer>     Custom refresh rate (Default 60Hz)"
    echo "${magenta}-p${reset} | ${magenta}-param${reset} ${light_blue}\"<string>\"${reset}           Xrandr parameters - Wrap with double quotes"
    echo "${magenta}-u${reset} | ${magenta}-update${reset} <path>              ${bold}Standalone:${reset} Update setcustomres (requires path to setcutomres local repository)"
    echo "${magenta}-v${reset} | ${magenta}-version${reset}                    ${bold}Standalone:${reset} Print version"
    echo "${magenta}-help${reset}                            ${bold}Standalone:${reset} Print this help message"
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
    
    printMessage "Setting custom resolution of ${width}x${height} to output $output $([[ "$refresh" ]] && echo "at a refresh rate of ${refresh}Hz") $([[ "$param" ]] && echo "\n            With flags: ${reset}${magenta}$param")"

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
        printError "Missing arguments, parse \"-help\" for more information"
    fi

    while [[ "$1" != "" ]]
    do
        case $1 in
            -v|-version)
                echo "setcustomres v$version"
                exit
                ;;
            -help)
                help
                exit
                ;;
            -w|-width)
                if [[ ! $2 =~ $number ]]; then
                    printError "Invalid value parsed! Only numbers are applicable."
                elif [ "$2" ]; then
                    shift
                    width="$1"
                else
                    printError "\"-w|-width\" requires a non-empty argument"
                fi
                ;;
            -h|-height)
                if [[ ! $2 =~ $number ]]; then
                    printError "Invalid value parsed! Only numbers are applicable."
                elif [ "$2" ]; then
                    shift
                    height="$1"
                else
                    printError "\"-h|-height\" requires a non-empty argument"
                fi
                ;;
            -r|-refresh-rate)
                if [[ ! $2 =~ $number ]]; then
                    printError "Invalid value parsed! Only numbers are applicable."
                elif [ "$2" ]; then
                    shift
                    refresh="$1"
                else
                    printError "\"-r|-refresh-rate\" requires a non-empty argument"
                fi
                ;;
            -o|-output)
                if [ "$2" ]; then
                    shift
                    output="$1"
                else
                    printError "\"-o|-output\" requires a non empty arguments"
                fi
                ;;
            -p|-param)
                if [ "$2" ]; then
                    shift
                    param="$1"
                else
                    printError "\"-p|-param\" requires a non empty arguments"
                fi
                ;;
            -u|-update)
                if [[ "$2" ]]; then
                    shift  
                    if [[ -d "$1" && $(basename $1) = *"setcustomres"* ]]; then
                        cd $1
                        printMessage "Updating 'setcustomres'"
                        sudo ./setup.sh install
                        cd - &> /dev/null
                        shift
                    else
                        printError "\"-u|-update\" requires a path to the local setcustomres repository"
                    fi
                fi
                exit
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

    if [[ ! "$width" ]] || [[ ! "$height" ]] || [[ ! "$output" ]]; then
        printError "Missing arguments, parse \"-help\" for more information"
    fi
}

flags "$@" # Deal with flags
set_resolution "$width" "$height" "$output" "$param" "$refresh" # Call set_resolution