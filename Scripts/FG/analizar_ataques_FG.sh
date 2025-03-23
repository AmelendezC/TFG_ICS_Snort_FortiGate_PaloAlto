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

# 1. Extraer una lista de los attackid distintos, separados por comas
distinct_attackids=$(tail -n +2 "$FILE" | cut -d',' -f1 | sort -u | tr '\n' ',' | sed 's/,$//')
echo "Lista de attackid distintos:"
echo "$distinct_attackids"

# 2. Contar el número de attackid distintos
count_distinct_attackids=$(echo "$distinct_attackids" | tr ',' '\n' | wc -l)
echo "Número de attackid distintos: $count_distinct_attackids"

# 3. Contar el número total de alertas (excluyendo la cabecera)
total_alertas=$(tail -n +2 "$FILE" | wc -l)
echo "Número total de alertas: $total_alertas"
