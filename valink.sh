#!/usr/bin/bash 

if [[ $# -eq 0 ]]; then
    echo "Debe especificar un parámetro."
    exit 1
fi

# Ctrl + C
trap "echo Cancelado.; exit 1" TERM INT

echo "Buscando..."

find  "$1" -type l -exec bash -c '[ -e "'{}'" ] || echo "'{}' : No es un link valido."' \;

exit 0
