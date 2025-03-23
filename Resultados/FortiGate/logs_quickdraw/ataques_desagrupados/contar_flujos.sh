#!/bin/bash

# Nombre del archivo CSV de salida
OUTPUT_FILE="resultados.csv"

# Crear el archivo CSV e incluir la cabecera
echo "nombre_del_fichero,num_flujos" > "$OUTPUT_FILE"

# Iterar sobre todos los archivos .log en el directorio actual
for LOG_FILE in *.log; do
  # Verificar si hay archivos .log en el directorio
  if [ ! -f "$LOG_FILE" ]; then
    echo "No se encontraron archivos .log en el directorio."
    exit 1
  fi

  # Extraer todos los sessionid distintos
  unique_sessionids=$(grep -o 'sessionid=[0-9]*' "$LOG_FILE" | cut -d'=' -f2 | sort | uniq)

  # Contar el número de sessionid únicos
  num_flows=$(echo "$unique_sessionids" | wc -l)

  # Guardar el resultado en el archivo CSV
  echo "$LOG_FILE,$num_flows" >> "$OUTPUT_FILE"
done

echo "Proceso completado. Los resultados se han guardado en $OUTPUT_FILE"
