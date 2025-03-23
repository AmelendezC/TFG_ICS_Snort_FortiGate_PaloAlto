#!/bin/bash

# Directorio donde se guardarán los ficheros desagrupados
OUTPUT_DIR="desagrupados"

# Crear el directorio de salida si no existe
mkdir -p "$OUTPUT_DIR"

# Procesar cada fichero .log en el directorio actual
for LOG_FILE in *.log; do
  # Comprobamos si existen archivos .log en el directorio
  if [[ ! -f "$LOG_FILE" ]]; then
    echo "No se encontraron ficheros .log en el directorio."
    exit 1
  fi

  # Nombre del fichero desagrupado
  OUTPUT_FILE="$OUTPUT_DIR/desagrupado_$(basename "$LOG_FILE")"

  # Procesamos cada línea del fichero de log
  while IFS= read -r line; do
    # Extraemos el valor de repeatcnt
    repeatcnt=$(echo "$line" | grep -oP 'repeatcnt="\K[0-9]+')

    # Si repeatcnt es mayor que 1, repetimos la línea el número de veces que indique repeatcnt
    if [[ "$repeatcnt" -gt 1 ]]; then
      for ((i=1; i<=repeatcnt; i++)); do
        echo "$line" >> "$OUTPUT_FILE"
      done
    else
      echo "$line" >> "$OUTPUT_FILE"
    fi
  done < "$LOG_FILE"

  echo "Proceso completado para $LOG_FILE. Las alertas desagrupadas se han guardado en $OUTPUT_FILE."

done
