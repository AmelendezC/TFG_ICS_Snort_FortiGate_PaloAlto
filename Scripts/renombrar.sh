#!/bin/bash

# Directorio base desde el cual comenzar a buscar
base_dir="/opt/pcaps-nuevos/ics/Archivos_pcap_TFG_Anterior"

# Verifica si el directorio base existe
if [ ! -d "$base_dir" ]; then
  echo "El directorio base '$base_dir' no existe."
  exit 1
fi

# Encuentra y renombra todos los archivos .pcapng recursivamente
find "$base_dir" -type f -name "*.pcapng" | while read -r file; do
  # Obtener el directorio y el nombre base del archivo (sin la extensión)
  dir=$(dirname "$file")
  base=$(basename "$file" .pcapng)
  # Crear el nuevo nombre de archivo
  new_name="${dir}/${base}_[1].pcapng"
  # Renombrar el archivo
  mv "$file" "$new_name"
  echo "Renombrado: $file -> $new_name"
done

echo "Todos los archivos .pcapng han sido renombrados."
