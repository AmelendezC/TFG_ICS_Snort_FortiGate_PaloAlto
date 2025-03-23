#!/bin/bash

# Nombre del directorio de salida
output_dir="resultados_flujos_TP"

# Crear el directorio si no existe
mkdir -p "$output_dir"

# Lista de SIDs a excluir (separados por "|", que es el operador OR en grep)
sids="1917|24303|57155|40517|2002752|2002749|2009207|2009208|2009206|2012648|2100527"

# Iterar sobre todos los archivos alert_csv.txt en el directorio actual
for input_file in *alert_csv.txt; do
  # Verificamos si el archivo existe
  if [[ -f "$input_file" ]]; then
    
    # Filtrar las líneas que NO contienen ninguno de los SIDs
    filtered_lines=$(grep -vE "$sids" "$input_file")

    # Definir el nombre del archivo de salida
    output_file="$output_dir/${input_file%.txt}_resultados_sin_sids.txt"

    # Si no quedan líneas después de filtrar, escribir que no se encontraron flujos
    if [[ -z "$filtered_lines" ]]; then
      echo "Número total de flujos distintos en $input_file: 0" > "$output_file"
      echo "No se encontraron flujos sin los SIDs especificados." >> "$output_file"
    else
      # Extraemos los flujos únicos y los normalizamos para considerar direcciones inversas como iguales
      unique_flows=$(echo "$filtered_lines" | awk -F',' '{ 
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
      }' | sort | uniq)

      # Contamos el número de flujos distintos
      flow_count=$(echo "$unique_flows" | wc -l)

      # Escribir los resultados en el archivo de salida
      echo "Número total de flujos distintos en $input_file: $flow_count" > "$output_file"
      echo "$unique_flows" >> "$output_file"
    fi

    echo "Resultados guardados en $output_file"
  else
    echo "No se encontró el archivo $input_file"
  fi
done

