#!/bin/bash

## Atención #########################################
#
# Éste script elimina archivos sin su consentimiento.
# 
#####################################################


if [[ $# -eq 0 ]]; then
	zenity --error --text="Sin parámetros.\nIndique al menos un archivo de imagen." --title="celuloide"
	exit 1
fi

feh --auto-zoom --fullscreen $*
shred --force --remove $*
exit $?
