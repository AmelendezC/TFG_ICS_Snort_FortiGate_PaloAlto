#!/bin/bash

# Directorio donde se encuentran los archivos pcapng
pcap_dir="."

# Directorio donde se guardarán los resultados
output_dir="Resultados_TALOS_3000"
current_dir=$(basename "$(pwd)")


# Archivo donde se escribirán los resultados
output_file="$output_dir/Resultados_${current_dir}.txt"


# Ubicación del ejecutable de Snort y archivo de configuración
snort_exec="/usr/local/snort/bin/snort"
snort_conf="/usr/local/snort/etc/snort/snort.lua"

# Verificar si el directorio de salida existe y tiene permisos adecuados
if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"  # Crear directorio si no existe
    echo "Directorio $output_dir creado."
else
    echo "Directorio $output_dir ya existe."
fi

# Asegurar permisos de escritura en el directorio de salida
chmod 777 "$output_dir"

# Ejecutar Snort para analizar los archivos pcapng y guardar los resultados en Resultados.txt
echo "Iniciando análisis con Snort..."

# Ejecutar Snort con --pcap-dir para analizar recursivamente el directorio
"$snort_exec" --talos -c "$snort_conf" --pcap-dir "$pcap_dir" > "$output_file" 2>&1

echo "Análisis completado. Resultados guardados en: $output_file"



