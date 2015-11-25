#!/bin/bash 

NEXT="-n" 
PREV="-p" 
TOGGLE="-t"
SEEK_PLUS="++"
SEEK_MINUS="--"
SEEK_VAL=15

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
		# TODO: seek
    esac
}

function mocp_control {
    
    case "$1" in 
        $NEXT) mocp -f;;
        $PREV) mocp -r;;
        $TOGGLE) mocp -G;;
        $SEEK_PLUS) mocp -k $SEEK_VAL;;
        $SEEK_MINUS) mocp -k -$SEEK_VAL;;
    esac
}

mocp_control "$1"
#mpd_control "$1"

