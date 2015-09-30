#!/bin/bash
# $Dep: notify-osd, amixer(alsa-utils)

# Parámetros:
# $1 = -i (incr vol),-d (decr vol),-t (mute/unmute)
# $2 = valor del volumen, por defecto 3

function get_current_volume()
{
	amixer get Master | grep 'Mono:' | sed -e 's/^[^\[]*//' -e 's/^.//' -e 's/%.*$//'
}

function get_current_mute()
{
	amixer get Master | grep 'Mono:' | grep '\[on]*$'
}

# Quiero que si el estado actual es mute/unmute y cambio
# el volumen cambie ha unmute/mute :)
function unmute_mute()
{
	if [[ -z $(get_current_mute) ]]; then 
		amixer set 'Master' toggle
	fi
}

VOL=${2:-3}

if [ "$1" == "-i" ]; then
	unmute_mute
	amixer set 'Master' $VOL+
	
elif  [ "$1" == "-d" ]; then
	unmute_mute
	amixer set 'Master' $VOL-

elif  [ "$1" == "-t" ]; then
	amixer set 'Master' toggle
else 
	echo "Parámetro desconicido"
fi

 # -- daemon notify-osd  or MATE --
 
 VOL=$(get_current_volume)

 if [[ VOL -eq 0 || $(get_current_mute) -eq 0 ]]; then
	 ICON=notification-audio-volume-muted
 else
	 if [[ VOL -lt 25 ]]; then
		 ICON=notification-audio-volume-low
	 elif [[ VOL -lt 80 ]]; then
		 ICON=notification-audio-volume-medium
	 else
		 ICON=notification-audio-volume-high
	 fi
 fi

notify-send  "Volume" -i $ICON -h int:value:$VOL -h string:x-canonical-private-synchronous:1
