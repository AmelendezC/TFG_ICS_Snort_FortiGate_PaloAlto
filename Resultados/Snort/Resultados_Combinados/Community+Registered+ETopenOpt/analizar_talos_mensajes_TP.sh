#!/bin/bash

# Nombre del directorio de salida
output_dir="resultados_mensajes_TP"

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

    # Extraer y contar los números de paquete únicos (segunda columna en el archivo)
    unique_packets=$(echo "$filtered_lines" | awk -F',' '{print $2}' | sort -n | uniq)

    # Contamos el número de números de paquete distintos
    packet_count=$(echo "$unique_packets" | wc -l)

    # Definir el nombre del archivo de salida
    output_file="$output_dir/${input_file%.txt}_resultados_mensajes_sin_sids.txt"

    # Escribir los resultados en el archivo de salida con el formato requerido
    echo "Números de paquete distintos encontrados en el archivo $input_file:" > "$output_file"
    echo "$unique_packets" >> "$output_file"
    echo "Total de números de paquete distintos: $packet_count" >> "$output_file"

    echo "Resultados guardados en $output_file"
  else
    echo "No se encontró el archivo $input_file"
  fi
done
