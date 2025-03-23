#!/bin/bash

# Directorio donde se guardarán los ficheros filtrados de ataques
OUTPUT_DIR="ataques"

# Nombre del fichero CSV de salida
OUTPUT_CSV="flujos_ataques.csv"

# Crear el directorio de salida si no existe
mkdir -p "$OUTPUT_DIR"

# Inicializar el fichero CSV con los encabezados
echo "nombre archivo,numero de flujos identificados" > "$OUTPUT_CSV"

# Procesar cada fichero .log en el directorio actual
for LOG_FILE in *.log; do
  # Comprobamos si existen archivos .log en el directorio
  if [[ ! -f "$LOG_FILE" ]]; then
    echo "No se encontraron ficheros .log en el directorio."
    exit 1
  fi

  # Nombre del fichero filtrado
  OUTPUT_FILE="$OUTPUT_DIR/ataques_$(basename "$LOG_FILE")"

  # Filtrar las líneas que contienen log_type="THREAT"
  grep 'log_type="THREAT"' "$LOG_FILE" > "$OUTPUT_FILE"

  # Comprobar si hay sessionid en el archivo filtrado
  if [[ -s "$OUTPUT_FILE" ]]; then
    # Extraer todos los sessionid únicos y contarlos
    sessionid_count=$(grep -oP 'sessionid="\K[0-9]+' "$OUTPUT_FILE" | sort -u | wc -l)
  else
    sessionid_count=0
  fi

  # Guardar el resultado en el CSV
  echo "$(basename "$LOG_FILE"),$sessionid_count" >> "$OUTPUT_CSV"

  echo "Proceso completado para $LOG_FILE. Los ataques se han guardado en $OUTPUT_FILE."
  echo "Número total de flujos identificados en ataques: $sessionid_count"
  echo ""

done

echo "Todos los resultados se han guardado en $OUTPUT_CSV."
