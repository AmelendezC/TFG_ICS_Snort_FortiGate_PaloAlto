#!/bin/bash

# Definir los patrones a buscar
PATTERN_THREAT='log_type="THREAT"'

# Crear el directorio csv si no existe
mkdir -p csv

# Variables para contar los IDs de reglas únicos y el número total de alertas
declare -A unique_ids
total_alerts=0

# Iterar sobre cada archivo de log en el directorio actual
for LOG_FILE in *.log; do
  # Verificar si el archivo existe y es un archivo regular
  if [ -f "$LOG_FILE" ]; then
    # Derivar el nombre del archivo CSV
    OUTPUT_CSV="csv/${LOG_FILE/_attacks.log/.csv}"

    # Crear el archivo CSV y agregar el encabezado
    echo -e "ID_regla\tseverity\tseverity_number\tNombre_regla\tthread_category\tprot\tsrc_ip\tdst_ip\tlog_subtype\textra_data" > "$OUTPUT_CSV"

    # Extraer las líneas que contienen el patrón especificado y procesar los campos de interés
    grep -E "$PATTERN_THREAT" "$LOG_FILE" | while read -r line; do
      # Extraer los campos de interés
      ID_regla=$(echo "$line" | grep -o 'threat_id="[^"]*"' | cut -d'"' -f2)
      severity=$(echo "$line" | grep -o 'severity="[^"]*"' | cut -d'"' -f2)
      severity_number=$(echo "$line" | grep -o 'severity_number="[^"]*"' | cut -d'"' -f2)
      Nombre_regla=$(echo "$line" | grep -o 'threat_name="[^"]*"' | cut -d'"' -f2)
      thread_category=$(echo "$line" | grep -o 'thread_category="[^"]*"' | cut -d'"' -f2)
      prot=$(echo "$line" | grep -o 'proto="[^"]*"' | cut -d'"' -f2)
      src_ip=$(echo "$line" | grep -o 'src_ip="[^"]*"' | cut -d'"' -f2)
      dst_ip=$(echo "$line" | grep -o 'dst_ip="[^"]*"' | cut -d'"' -f2)
      log_subtype=$(echo "$line" | grep -o 'log_subtype="[^"]*"' | cut -d'"' -f2)
      extra_data=$(echo "$line" | grep -o 'extra_data="[^"]*"' | cut -d'"' -f2)

      # Agregar la línea al archivo CSV
      echo -e "$ID_regla\t$severity\t$severity_number\t$Nombre_regla\t$thread_category\t$prot\t$src_ip\t$dst_ip\t$log_subtype\t$extra_data" >> "$OUTPUT_CSV"

      # Incrementar el número total de alertas
      ((total_alerts++))

      # Agregar el ID_regla a la lista de IDs únicos
      unique_ids["$ID_regla"]=1
    done
  fi
done

# Mostrar el número de IDs de reglas únicos y el número total de alertas
echo "Número de IDs de reglas únicos: ${#unique_ids[@]}"
echo "Número total de alertas: $total_alerts"
