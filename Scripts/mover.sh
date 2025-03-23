#!/bin/bash

# Verifica si se ha proporcionado el directorio base
if [ -z "$1" ]; then
  echo "Uso: $0 <directorio_base>"
  exit 1
fi

# Directorio base desde el cual comenzar a buscar
base_dir="$1"

# Directorio destino
dest_dir="/opt/pcaps-nuevos/ics"

# Verifica si el directorio base existe
if [ ! -d "$base_dir" ]; then
  echo "El directorio base '$base_dir' no existe."
  exit 1
fi

# Verifica si el directorio destino existe, si no, lo crea
if [ ! -d "$dest_dir" ]; then
  echo "El directorio destino '$dest_dir' no existe."
  exit 1
fi

# Encuentra y mueve todos los archivos .pcapng recursivamente
find "$base_dir" -type f -name "*.pcapng" | while read -r file; do
  # Mueve el archivo al directorio destino
  mv "$file" "$dest_dir"
  echo "Movido: $file -> $dest_dir"
done

echo "Todos los archivos .pcapng han sido movidos a '$dest_dir'."

