#!/bin/bash

# Buscamos archivos que empiecen con "ejercicio" seguido de UN solo número
# y opcionalmente terminen en .pas
find . -type f -regextype posix-extended -regex '.*/ejercicio[0-9](\.pas)?' | while read -r file; do

    # Extraemos el directorio (ej: ./ejercicio01)
    dir=$(dirname "$file")
    # Extraemos el nombre del archivo (ej: ejercicio1.pas)
    base=$(basename "$file")

    # Usamos sed para insertar el 0 después de la palabra 'ejercicio'
    new_base=$(echo "$base" | sed -r 's/ejercicio([0-9])/ejercicio0\1/')

    # Renombramos
    echo "Renombrando: $file -> $dir/$new_base"
    mv "$file" "$dir/$new_base"
done

echo "¡Listo! Archivos normalizados."
