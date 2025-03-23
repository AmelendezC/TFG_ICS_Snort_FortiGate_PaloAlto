#!/bin/bash

# Crear el directorio de salida para los archivos CSV
OUTPUT_DIR="csv_outputs"
mkdir -p "$OUTPUT_DIR"

# Función para extraer un campo de un log
extract_field() {
  local line="$1"
  local field="$2"
  echo "$line" | grep -o "$field=[^ ]*" | cut -d'=' -f2
}

# Función para obtener el valor de "repeated"
extract_repeated() {
  local line="$1"
  local repeated="1" # Valor por defecto si no se encuentra repetición

  if [[ "$line" == *"repeated"* ]]; then
    repeated=$(echo "$line" | grep -o 'repeated [0-9]* times' | awk '{print $2}')
  elif [[ "$line" == *"count="* ]]; then
    repeated=$(echo "$line" | grep -o 'count=[0-9]*' | cut -d'=' -f2)
  fi

  echo "$repeated"
}

# Iterar sobre todos los archivos .log en el directorio actual
for LOG_FILE in *.log; do
  # Nombre del archivo CSV de salida basado en el nombre del archivo de log
  OUTPUT_CSV="$OUTPUT_DIR/${LOG_FILE%.log}.csv"

  # Crear el archivo CSV e incluir la cabecera
  echo "attackid,sessionid,repeated,severity,attack,service,srcip,dstip,subtype,eventtype,url" > "$OUTPUT_CSV"

  # Procesar el archivo de logs
  while IFS= read -r line; do
    if [[ "$line" == *'type="utm"'* ]]; then
      # Extraer el campo attackid
      attackid=$(extract_field "$line" "attackid")

      # Continuar solo si existe attackid
      if [[ -n "$attackid" ]]; then
        # Extraer los otros campos necesarios
        sessionid=$(extract_field "$line" "sessionid")
        severity=$(extract_field "$line" "severity")
        attack=$(extract_field "$line" "attack")
        service=$(extract_field "$line" "service")
        srcip=$(extract_field "$line" "srcip")
        dstip=$(extract_field "$line" "dstip")
        subtype=$(extract_field "$line" "subtype")
        eventtype=$(extract_field "$line" "eventtype")
        url=$(extract_field "$line" "ref")
        
        # Obtener el número de repeticiones
        repeated=$(extract_repeated "$line")

        # Si algún campo no existe, asignar un valor por defecto
        sessionid=${sessionid:-"-"}
        severity=${severity:-"-"}
        attack=${attack:-"-"}
        service=${service:-"-"}
        srcip=${srcip:-"-"}
        dstip=${dstip:-"-"}
        subtype=${subtype:-"-"}
        eventtype=${eventtype:-"-"}
        url=${url:-"-"}

        # Añadir la fila al archivo CSV
        echo "$attackid,$sessionid,$repeated,$severity,$attack,$service,$srcip,$dstip,$subtype,$eventtype,$url" >> "$OUTPUT_CSV"
      fi
    fi
  done < "$LOG_FILE"

  echo "CSV generado: $OUTPUT_CSV"
done

echo "Proceso completado. Los archivos CSV se han guardado en la carpeta $OUTPUT_DIR"

