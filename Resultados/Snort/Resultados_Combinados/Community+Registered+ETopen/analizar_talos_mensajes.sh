#!/bin/bash

# Nombre del directorio de salida
output_dir="resultados_mensajes"

# Crear el directorio si no existe
mkdir -p "$output_dir"

# Iterar sobre todos los archivos alert_csv.txt en el directorio actual
for input_file in *alert_csv.txt; do
  # Verificamos si el archivo existe
  if [[ -f "$input_file" ]]; then
    
    # Extraer y contar los números de paquetes únicos (segunda columna en el archivo)
    unique_packets=$(awk -F',' '{print $2}' "$input_file" | sort -n | uniq)

    # Contamos el número de paquetes distintos
    packet_count=$(echo "$unique_packets" | wc -l)

    # Definir el nombre del archivo de salida
    output_file="$output_dir/${input_file%.txt}_resultados_paquetes.txt"

    # Escribir los resultados en el archivo de salida con el formato requerido
    echo "Números de paquete distintos encontrados en el archivo $input_file:" > "$output_file"
    echo "$unique_packets" >> "$output_file"
    echo "Total de números de paquete distintos: $packet_count" >> "$output_file"

    echo "Resultados guardados en $output_file"
  else
    echo "No se encontró el archivo $input_file"
  fi
done
