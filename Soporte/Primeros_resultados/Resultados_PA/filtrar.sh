#!/bin/bash

# Definir los patrones a buscar
PATTERN_IFACE='inbound_iface="ethernet1/4"'
PATTERN_ZONE='zone="ZONE3"'

# Crear el directorio "Filtered" si no existe
mkdir -p Filtered

# Iterar sobre cada archivo de log en el directorio actual
for LOG_FILE in *.log; do
  # Verificar si el archivo existe y es un archivo regular
  if [ -f "$LOG_FILE" ]; then
    # Crear el nombre del nuevo archivo de log con _filtered antes de la extensión .log
    OUTPUT_FILE="Filtered/${LOG_FILE%.log}_filtered.log"
    
    # Extraer las líneas que contienen los patrones especificados y guardarlas en el nuevo archivo
    grep -E "$PATTERN_IFACE" "$LOG_FILE" | grep -E "$PATTERN_ZONE" > "$OUTPUT_FILE"
    
    # Mostrar un mensaje indicando que el archivo ha sido procesado
    echo "Procesado $LOG_FILE, creado $OUTPUT_FILE"
  fi
done
