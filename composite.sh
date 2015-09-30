#!/bin/bash

function _xcompmgr()
{
    local R=`pidof xcompmgr`
    if [ "$R" -ne 0 ];  then 
  	    killall xcompmgr
    else
        xcompmgr -cC -t-3 -l-5 -r4 -o .80 &
    fi
}


function _compton()
{
    local R=`pidof compton`
    if [ "$R" -ne 0 ];  then 
  	    killall compton
    else
        # Ver ~/.compton.conf
        compton -cC &
    fi
}


_compton

#_xcompmgr

exit
