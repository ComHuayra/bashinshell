#!/bin/bash

if [[ $# -eq 0 ]]; then
	zenity --error --text="Sin parámetros.\nIndique al menos un archivo de imagen." --title="Celuloide"
	exit 1
fi


zenity --question --text="¿Esta seguro de continuar?" --title="Celuloide"

if [[ $? -ne 0 ]]; then 
	exit $?
fi

feh --auto-zoom --fullscreen $*

shred --force --remove $*

exit $?
