#!/bin/bash

# Foreground colours
dark_grey=$'\e[30m'
grey=$'\e[90m'
red=$'\e[31m'
dull_red=$'\e[91m'
green=$'\e[32m'
dull_green=$'\e[92m'
orange=$'\e[33m'
yellow=$'\e[93m'
blue=$'\e[34m'
dull_blue=$'\e[94m'
magenta=$'\e[35m'
dull_magenta=$'\e[95m'
cyan=$'\e[36m'
dull_cyan=$'\e[96m'

# Background colours
invert_bg=$'\e[7m'
red_bg=$'\e[41m'
dull_red_bg=$'\e[101m'
green_bg=$'\e[42m'
dull_green_bg=$'\e[102m'
orange_bg=$'\e[43m'
yellow_bg=$'\e[103m'
blue_bg=$'\e[44m'
dull_blue_bg=$'\e[104m'
magenta_bg=$'\e[45m'
dull_magenta_bg=$'\e[105m'
cyan_bg=$'\e[46m'
dull_cyan_bg=$'\e[106m'
white_bg=$'\e[47m'

# Formatting effects
bold=$'\e[1m'
italic=$'\e[3m'
underline=$'\e[4m'
strikethrough=$'\e[9m'
blinking=$'\e[5m'

# Reset colour/effect
reset=$'\e[0m'



example_formatting()
{
    echo "     ${bold}${underline}COLOURS${reset}                             ${bold}${underline}BACKGROUND COLOURS${reset}"
    echo ""
    echo "     ${grey}grey${reset}                                ${invert_bg}invert_bg${reset}"
    echo "     ${red}red${reset}                                 ${red_bg}red_bg${reset}"
    echo "     ${dull_red}dull_red${reset}                            ${dull_red_bg}dull_red_bg${reset}"
    echo "     ${green}green${reset}                               ${green_bg}green_bg${reset}"
    echo "     ${dull_green}dull_green${reset}                          ${dull_green_bg}dull_green_bg${reset}"
    echo "     ${orange}orange${reset}                              ${orange_bg}orange_bg${reset}"
    echo "     ${yellow}yellow${reset}                              ${yellow_bg}yellow_bg${reset}"
    echo "     ${blue}blue${reset}                                ${blue_bg}blue_bg${reset}"
    echo "     ${dull_blue}dull_blue${reset}                           ${dull_blue_bg}dull_blue_bg${reset}"
    echo "     ${magenta}magenta${reset}                             ${magenta_bg}magenta_bg${reset}"
    echo "     ${dull_magenta}dull_magenta${reset}                        ${dull_magenta_bg}dull_magenta_bg${reset}"
    echo "     ${cyan}cyan${reset}                                ${cyan_bg}cyan_bg${reset}"
    echo "     ${dull_cyan}dull_cyan${reset}                           ${dull_cyan_bg}dull_cyan_bg${reset}"
    echo "     ${dark_grey}dark_grey${reset}                           ${white_bg}white_bg${reset}"
    echo ""
    echo "     ${bold}${underline}FORMATTING EFFECTS${reset}"    
    echo ""
    echo "     ${bold}bold${reset}                              ${underline}underline${reset}"
    echo "     ${italic}italic${reset}                            ${strikethrough}strikethrough${reset}"
    echo "     ${blinking}blinking${reset}"
}