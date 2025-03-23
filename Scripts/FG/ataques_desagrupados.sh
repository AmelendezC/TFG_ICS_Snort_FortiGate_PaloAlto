#!/bin/bash

# Nombre del directorio de salida
OUTPUT_DIR="ataques_desagrupados"

# Crear el directorio de salida si no existe
mkdir -p "$OUTPUT_DIR"

# Iterar sobre todos los archivos .log en el directorio actual
for LOG_FILE in *.log; do
  # Verificar si hay archivos .log en el directorio
  if [ -z "$LOG_FILE" ]; then
    echo "No se encontraron archivos .log en el directorio."
    exit 1
  fi

  # Nombre del archivo de salida basado en el nombre del archivo de log
  OUTPUT_FILE="$OUTPUT_DIR/${LOG_FILE%.log}_ataques_desagrupados.log"

  # Limpiar o crear el archivo de salida
  > "$OUTPUT_FILE"

  echo "Procesando archivo: $LOG_FILE"

  # Procesar el archivo de logs para extraer y desagrupar las alertas
  while IFS= read -r line; do
    # Filtrar solo las entradas de tipo "utm" (tráfico de ataques)
    if [[ "$line" == *'type="utm"'* ]]; then
      
      # Extraer el valor de "count=n" si existe
      count=$(echo "$line" | grep -o 'count=[0-9]*' | cut -d'=' -f2)

      # Si no hay "count=n", buscar el sufijo ", repeated n times"
      if [ -z "$count" ]; then
        count=$(echo "$line" | grep -o 'repeated [0-9]* times' | awk '{print $2}')
      fi

      # Si no se encuentra "count" ni "repeated n times", considerar que es 1
      if [ -z "$count" ]; then
        count=1
      fi

      # Desagrupar y escribir cada alerta en el archivo de salida
      for ((i = 1; i <= count; i++)); do
        echo "$line" >> "$OUTPUT_FILE"
      done

    fi
  done < "$LOG_FILE"

  echo "Resultados para $LOG_FILE guardados en $OUTPUT_FILE."
done

echo "Proceso completado. Los resultados se han guardado en la carpeta $OUTPUT_DIR"
