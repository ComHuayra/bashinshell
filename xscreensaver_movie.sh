#!/bin/bash

# Lugar en donde se encuentran los vídeos.  
    videos=~/Video/xscreensaver

# Un simple array...
    declare -a array

# Listamos los archivos disponibles según formato.
    for nombre in $(ls $videos/{*.avi,*.mp4,*.flv} 2>/dev/null)
    do
        N=${#array[*]} # Número de ítemes del array.

        array[N]=$nombre; # Almacenamos el nombre.
    done
    
# Obtener un número aleatorio de rango en base al número de ítemes del array.
    rand=$(( RANDOM % ${#array[*]} ))

# Esperar a que la ventana de xscreensaver esté lista.
    sleep 1s 

# Listo.!!!
    mpv --really-quiet --no-audio --fs --loop=inf --no-stop-screensaver --wid=$1 ${array[$rand]}

