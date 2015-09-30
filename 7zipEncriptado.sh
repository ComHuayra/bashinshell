#!/usr/bin/bash

################################################################################
# @ 7zipEncriptado:
# - Permite, mediante el menú contextual, sobre un archivo o carpeta, encriptar
#   dichos archivos mediante una clave ingresada por el usuario. El resultado es
#   un archivo con nombre de la carpeta o archivo más la extensión de 
#   formato .7z
#
# @ Resumen:
# - Si el archivo es nuevo se ingresa la clave sólo para encriptar.
# - Si el archivo ya existe, se actualizará dicho archivo,la clave debe ser la
#   del archivo ya encriptado.

# @ Dependecias:
# - p7zip
# - Zenity

# @ Importante:
# - No una aplicación para terminal, debe utilizarse desde un
#   explorador de archivos (Thunar, PCManFM, etc)

# @ Platillas:

#--------------------------------------- 
# $Id: Thunar, SendTo 
# ~/.local/share/Thunar/sendto/7zipEncriptado.desktop
#--------------------------------------- 
#  [Desktop Entry]
#  Type=Application
#  ToolbarLabel=7zip Encriptado
#  Name=7zip Encriptado
#  Profiles=profile-zero;
#  Icon=gtk-orientation-landscape
#  MimeTypes=*;
#  Exec=/usr/bin/7zipEncriptado.sh %F
#---------------------------------------


#---------------------------------------
# $Id: PCManFM
# ~/.local/share/file-manager/actions/7zipEncriptado.desktop
#---------------------------------------
#  [Desktop Entry]
#  Type=Action
#  ToolbarLabel=7zip Encriptado
#  Name=7zip Encriptado
#  Profiles=profile-zero;
#  Icon=gtk-orientation-landscape
#  
#  [X-Action-Profile profile-zero]
#  MimeTypes=*;
#  Exec=/usr/bin/7zipEncriptado.sh %F
#  Name=Default profile
#  SelectionCount==1
#---------------------------------------
################################################################################

TITLE='7zip encriptado'

# Sin parámetros, termina. 
# Util, en caso de utilizarse la terminal.
if (( $# == 0 )); then
    zenity --error --title="$TITLE" --text="Ningún archivo o directorio seleccionado."
    exit
fi


if (( $# > 1 )); then 
    zenity --error --title="$TITLE" --text="Demasiados archivos contenedores."
    exit
 
fi

FILE="$1"
NAME_ZIP=${FILE%/}.7z
func=a # Por defecto, crear.

# Si el archivo no existe, termina.
# Util, en caso de utilizarse la terminal.
if ! [[ -e $FILE ]]; then
    zenity --error --title="$TITLE" --text="El archivo/directorio \"$FILE\" no existe!"
    exit
fi


# Verifica si el archivo ya existe.
# Presenta opciones al usuario.
if [[ -e $NAME_ZIP ]]; then 
   
    ACTION=`zenity --list \
            --title="$TITLE" \
            --text="El archivo \"$NAME_ZIP\" ya existe.\n¿Que desea hacer?" \
            --column="Acción" \
            --print-column=1 \
            Actualizar  \
            Sobrescribir `

    if [[ -z $ACTION ]]; then
        exit
    fi

    if [[ $ACTION == "Actualizar" ]]; then
        func=u # Actualizar.
    fi
fi

# Obtener la clave.
# Este es lugar indicado.
TENC="Ingrese la clave para encriptar:"
TDEC="Ingrese la clave para\ndesencriptar y actualizar:"
if [[ $func == "u" ]]; then 
    TEXT="$TDEC"
else
    TEXT="$TENC"
fi

pass=`zenity --entry \
    --text="$TEXT"    \
    --title="$TITLE" \
    --hide-text`

# Si la clave es vacía, termina.
if [[ -z $pass ]]; then
    exit
fi

# Si se va ha crear un nuevo archivo y la clave es válida
# es seguro eliminar.
if [[ $func == "a" ]]; then
    rm "$NAME_ZIP"
fi

(
    MSG_ERROR="p7zip informa de un error.\n \
    Es posible que Ud. quiso actualizar su archivo\n \
    e ingreso una clave no válida."
    7za $func -y -mhe=on -p$pass "$NAME_ZIP" "$FILE" || \
        zenity --info --title="$TITLE" --text="$MSG_ERROR"

) | zenity --progress --title="$TITLE" --text="En progreso..." --pulsate --width=250

