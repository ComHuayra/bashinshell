#!/bin/sh
#Solo para xfce :/
xrdb -l ~/.Xresources

RUN="sh -c '(tmux ls | grep -vq attached && tmux at) || tmux -q'"
#RUN="/usr/bin/sh -c 'screen -d -R'"
#lxterminal --geometry=125x40 --working-directory=~/ -e "$RUN"
#xfce4-terminal --geometry=145x60 --hide-menubar --hide-toolbar -e "$RUN"
xterm -title $(uname -n) -e "$RUN"
#urxvt -geometry 125x40 -e $RUN
#vte  -h -r -c "$RUN"
