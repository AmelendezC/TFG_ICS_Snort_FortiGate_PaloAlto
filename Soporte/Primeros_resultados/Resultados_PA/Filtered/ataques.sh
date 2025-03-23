#!/bin/bash

# Definir el patrón a buscar
PATTERN_THREAT='log_type="THREAT"'

# Crear el directorio "Attacks" si no existe
mkdir -p Attacks

# Iterar sobre cada archivo de log en el directorio actual
for LOG_FILE in *.log; do
  # Verificar si el archivo existe y es un archivo regular
  if [ -f "$LOG_FILE" ]; then
    # Remover _filtered de LOG_FILE y añadir _attacks.log
    OUTPUT_FILE="Attacks/${LOG_FILE/_filtered.log/_attacks.log}"
    
    # Extraer las líneas que contienen el patrón especificado y guardarlas en el nuevo archivo
    grep -E "$PATTERN_THREAT" "$LOG_FILE" > "$OUTPUT_FILE"
    
    # Mostrar un mensaje indicando que el archivo ha sido procesado
    echo "Procesado $LOG_FILE, creado $OUTPUT_FILE"
  fi
done
