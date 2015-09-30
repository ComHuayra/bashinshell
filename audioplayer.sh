#!/bin/bash 

NEXT="-n" 
PREV="-p" 
TOGGLE="-t"


function mpd_control {

    if [[ -z $MPD_PORT ]]; then 
        printf "Error, failed to get mpd port"
        PORT= 6000
    else 
        PORT=$MPD_PORT
    fi

    case "$1" in
        $NEXT) mpc -p $PORT next;;
        $PREV) mpc -p $PORT prev;;
        $TOGGLE) mpc -p $PORT toggle;
    esac
}

function mocp_control {
    
    case "$1" in 
        $NEXT) mocp -f;;
        $PREV) mocp -r;;
        $TOGGLE) mocp -G;;
    esac
}

mocp_control "$1"
#mpd_control "$1"

