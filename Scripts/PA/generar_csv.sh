#!/bin/bash

# Directorio donde se guardarán los ficheros CSV generados
OUTPUT_DIR="resultados_ataques"

# Crear el directorio de salida si no existe
mkdir -p "$OUTPUT_DIR"

# Procesar cada fichero de log en el directorio actual
for LOG_FILE in *.log; do
  # Comprobamos si existen archivos .log en el directorio actual
  if [[ ! -f "$LOG_FILE" ]]; then
    echo "No se encontraron ficheros de log en el directorio actual."
    exit 1
  fi

  # Definir el nombre del archivo CSV de salida basado en el nombre del archivo de log
  OUTPUT_CSV="$OUTPUT_DIR/$(basename "$LOG_FILE" .log).csv"

  # Inicializar el fichero CSV con los encabezados separados por tabulaciones
  echo -e "ID_regla\tsessionid\trepeatcnt\tseverity_number\tNombre_regla\tthread_category\tprot\tsrc_ip\tdst_ip\tlog_subtype\textra_data" > "$OUTPUT_CSV"

  # Extraer los campos necesarios y añadirlos al CSV
  while IFS= read -r line; do
    # Extraer el campo threat_id completo
    threat_id=$(echo "$line" | grep -oP 'threat_id="\K[^"]+')

    # Separar el ID del nombre de la regla
    ID_regla=$(echo "$threat_id" | grep -oP '\(\K[0-9]+')
    Nombre_regla=$(echo "$threat_id" | grep -oP '^.+(?=\(\d+\))')

    sessionid=$(echo "$line" | grep -oP 'sessionid="\K[^"]+')
    repeatcnt=$(echo "$line" | grep -oP 'repeatcnt="\K[^"]+')
    severity_number=$(echo "$line" | grep -oP 'severity_number="\K[^"]+')
    thread_category=$(echo "$line" | grep -oP 'thread_category="\K[^"]+')
    prot=$(echo "$line" | grep -oP 'proto="\K[^"]+')
    src_ip=$(echo "$line" | grep -oP 'src_ip="\K[^"]+')
    dst_ip=$(echo "$line" | grep -oP 'dst_ip="\K[^"]+')
    log_subtype=$(echo "$line" | grep -oP 'log_subtype="\K[^"]+')
    extra_data=$(echo "$line" | grep -oP 'extra_data="\K[^"]+')

    # Escribir los valores en el fichero CSV sin tabulación inicial
    echo -e "$ID_regla\t$sessionid\t$repeatcnt\t$severity_number\t$Nombre_regla\t$thread_category\t$prot\t$src_ip\t$dst_ip\t$log_subtype\t$extra_data" >> "$OUTPUT_CSV"
  done < "$LOG_FILE"

done

echo "Todos los archivos CSV se han generado en el directorio $OUTPUT_DIR."

