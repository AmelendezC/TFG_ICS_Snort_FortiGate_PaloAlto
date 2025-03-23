#!/bin/bash

# Directorio donde se guardarán los archivos CSV
output_dir="csv_app_ctrl"
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

# Función para extraer los campos solicitados
extract_fields() {
  log_file=$1
  csv_file="$output_dir/$(basename "$log_file" .log).csv"

  # Escribir la cabecera en el archivo CSV
  echo -e "appid\tsessionid\tapp\tmsg\tapprisk\tsrcip\tdstip\tDeviceID" > "$csv_file"

  # Leer cada línea del archivo log
  while IFS= read -r line; do
    # Verificar si la línea contiene subtype="app-ctrl"
    if echo "$line" | grep -q 'subtype="app-ctrl"'; then
      # Extraer los valores de los campos solicitados
      appid=$(echo "$line" | grep -oP '(?<=\bappid=)[^ ]*')
      sessionid=$(echo "$line" | grep -oP '(?<=\bsessionid=)[^ ]*')
      app=$(echo "$line" | grep -oP '(?<=\bapp=")[^"]*(?=")')
      msg=$(echo "$line" | grep -oP '(?<=\bmsg=")[^"]*(?=")')
      apprisk=$(echo "$line" | grep -oP '(?<=\bapprisk=")[^"]*(?=")')
      srcip=$(echo "$line" | grep -oP '(?<=\bsrcip=)[^ ]*')
      dstip=$(echo "$line" | grep -oP '(?<=\bdstip=)[^ ]*')
      DeviceID=$(echo "$line" | grep -oP '(?<=\bDeviceID=)[^"]*(?="|,)')

      # Asegurar que los valores no sean vacíos, si no, asignar una cadena vacía
      appid=${appid:-""}
      sessionid=${sessionid:-""}
      app=${app:-""}
      msg=${msg:-""}
      apprisk=${apprisk:-""}
      srcip=${srcip:-""}
      dstip=${dstip:-""}
      DeviceID=${DeviceID:-""}

      # Escribir los valores extraídos en una sola línea en el archivo CSV
      echo -e "$appid\t$sessionid\t$app\t$msg\t$apprisk\t$srcip\t$dstip\t$DeviceID" >> "$csv_file"
    fi
  done < "$log_file"
}

# Procesar todos los archivos de log en el directorio actual
for log_file in *.log; do
  if [ -f "$log_file" ]; then
    echo "Procesando $log_file..."
    extract_fields "$log_file"
  else
    echo "No se encontraron archivos de log."
  fi
done

echo "Proceso completado. Los archivos CSV se han guardado en el directorio $output_dir."

