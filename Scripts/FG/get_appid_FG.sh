#!/bin/bash

# Verificar si se proporcionó un archivo como argumento
if [ $# -eq 0 ]; then
  echo "Uso: $0 <archivo.csv>"
  exit 1
fi

# Archivo CSV pasado como argumento
FILE="$1"

# Verificar si el archivo existe
if [ ! -f "$FILE" ]; then
  echo "El archivo $FILE no existe."
  exit 1
fi

# Extraer y mostrar los appid distintos, separados por comas
echo "Lista de appid distintos:"
tail -n +2 "$FILE" | awk -F'[,[:space:]]+' '{print $1}' | sort -u | paste -sd ',' -
