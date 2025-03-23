#!/bin/bash

# Directorio donde se guardarán los archivos de salida
OUTPUT_DIR="./traffic"

# Verifica si el directorio de salida existe, si no, créalo
mkdir -p "$OUTPUT_DIR"

# Procesa todos los archivos .log en el directorio actual
for LOG_FILE in *.log; do
  # Verifica si el archivo existe y es un archivo regular
  if [ -f "$LOG_FILE" ]; then
    # Define el nombre del archivo de salida en el directorio traffic
    OUTPUT_FILE="$OUTPUT_DIR/${LOG_FILE%.log}-traffic.log"
    
    # Extrae las líneas que contienen ambos criterios y guárdalas en el archivo de salida
    grep 'srcintf="port5"' "$LOG_FILE" | grep 'policytype="sniffer"' > "$OUTPUT_FILE"
    
    # Verifica si se encontraron coincidencias
    if [ -s "$OUTPUT_FILE" ]; then
      echo "Las líneas filtradas de $LOG_FILE se han guardado en: $OUTPUT_FILE"
    else
      echo "No se encontraron líneas que coincidan con los criterios especificados en $LOG_FILE."
      # Elimina el archivo de salida si está vacío
      rm "$OUTPUT_FILE"
    fi
  else
    echo "No se encontraron archivos .log en el directorio actual."
  fi
done
