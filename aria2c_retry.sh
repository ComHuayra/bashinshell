#!/bin/bash 

sleep_sec=60 # sec.

low_speed="70K"

function help () 
{
    printf "\n\aUsage: $0 [-s sleep seconds (60s)] [-l low speed limit (70K)] [-u url | file] url\n"
    exit 1
}


while getopts "s:l:u:" opt; do
    case $opt in
        s) sleep_sec=$OPTARG ;;
        l) low_speed=$OPTARG ;;
        u) url_file=$OPTARG ;;
        \?) help ;;
     esac
 done

if [[ -z $url_file ]]; then
    help
fi

trap 'printf "\n\a[*] Quit\n"; exit 1' TERM INT

declare -i count=1

if [[ -e $url_file ]]; then
    CMD="aria2c -i "
else
    CMD="aria2c "
fi

while [[ 1 ]]; do
    $CMD "$url_file" --lowest-speed-limit "$low_speed"
    if [[ $? -eq 0 ]]; then 
        printf "\n\a[*] The download is complete on #$count retries.\n"
        exit 0
    else if [[ $? -eq 1 ]]; then
        help
    fi
    fi
    printf "\n\a[#$count] Waiting $sleep_sec seconds...\n"
    count=count+1
    sleep $sleep_sec
 done
 
