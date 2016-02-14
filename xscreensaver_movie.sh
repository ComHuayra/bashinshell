#!/bin/bash

# Lugar en donde se encuentran los vídeos.  
    videos=~/Video/xscreensaver

# Separar la lista por salto de línea.
    SAVEIFS=$IFS
    IFS=$'\n'

# Listamos los archivos disponibles según formato.
    lista=$(ls $videos/{*.avi,*.mp4,*.flv} 2>/dev/null)

# Esperar a que la ventana de xscreensaver esté lista.
    sleep 1s 

# Listo.!!!
    mpv --really-quiet --no-audio --fs --loop=inf --no-stop-screensaver --wid=$1 $lista

# Restaurar
    IFS=$SAVEIFS
