#!/bin/bash

# Nombre del directorio de salida
output_dir="resultados_flujos"

# Crear el directorio si no existe
mkdir -p "$output_dir"

# Iterar sobre todos los archivos alert_csv.txt en el directorio actual
for input_file in *alert_csv.txt; do
  # Verificamos si el archivo existe
  if [[ -f "$input_file" ]]; then
    
    # Extraemos los flujos únicos y los normalizamos para considerar direcciones inversas como iguales
    unique_flows=$(awk -F',' '{ 
      # Eliminar espacios al inicio/final en cada campo (por si acaso)
      gsub(/^ +| +$/, "", $7); 
      gsub(/^ +| +$/, "", $8);
      
      # Separar la IP y puerto de origen/destino
      split($7, src, ":");
      split($8, dst, ":");
      
      # Crear flujo en ambas direcciones
      flow1 = src[1] ":" src[2] " -> " dst[1] ":" dst[2];
      flow2 = dst[1] ":" dst[2] " -> " src[1] ":" src[2];
      
      # Ordenar para evitar duplicados si las direcciones están al revés
      if (flow1 < flow2) {
        print flow1;
      } else {
        print flow2;
      }
    }' "$input_file" | sort | uniq)

    # Contamos el número de flujos distintos
    flow_count=$(echo "$unique_flows" | wc -l)

    # Definir el nombre del archivo de salida
    output_file="$output_dir/${input_file%.txt}_resultados.txt"

    # Escribir los resultados en el archivo de salida
    echo "Número total de flujos distintos en $input_file: $flow_count" > "$output_file"
    echo "$unique_flows" >> "$output_file"

    echo "Resultados guardados en $output_file"
  else
    echo "No se encontró el archivo $input_file"
  fi
done
