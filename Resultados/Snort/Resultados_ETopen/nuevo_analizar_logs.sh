#!/bin/bash

# Directorio actual donde se encuentran los archivos _combined_alerts.txt
script_dir=$(dirname "$0")

# Archivo de resultados global
global_result_file="$script_dir/resultados_globales.txt"

# Crear o vaciar el archivo de resultados global
> "$global_result_file"

# Función para procesar cada archivo combinado
process_combined_file() {
    local combined_file="$1"
    local base_name=$(basename "$combined_file")

    echo "Procesando $combined_file..."

    # Escribir el nombre del archivo procesado en el archivo de resultados global
    echo "Resultados para $base_name:" >> "$global_result_file"
    echo "==================================" >> "$global_result_file"

    # 1. Identificar los SIDs distintos y cuántas veces se repiten
    echo "SIDs distintos y cuántas veces se repite cada uno:" >> "$global_result_file"
    awk -F "," '{print $2}' "$combined_file" | sort | uniq -c | sort -nr >> "$global_result_file"

    # 2. Contar el número total de alertas
    total_alerts=$(wc -l < "$combined_file")
    echo "Número total de alertas: $total_alerts" >> "$global_result_file"

    # 3. Contar el número de flujos detectados (bidireccionales)
    declare -A flows

    while IFS= read -r line; do
        # Extraer las direcciones IP y puertos
        src_ip_port=$(echo "$line" | awk -F "->" '{print $1}' | awk '{print $NF}')
        dst_ip_port=$(echo "$line" | awk -F "->" '{print $2}' | awk '{print $1}')

        # Crear un flujo y su inverso
        flow="$src_ip_port->$dst_ip_port"
        reverse_flow="$dst_ip_port->$src_ip_port"

        # Contar solo los flujos únicos, combinando bidireccionales
        if [[ -z "${flows[$flow]}" && -z "${flows[$reverse_flow]}" ]]; then
            flows["$flow"]=1
        fi
    done < "$combined_file"

    total_flows=${#flows[@]}
    echo "Número de flujos detectados: $total_flows" >> "$global_result_file"
    
    # 4. Contar el número de mensajes de red con ataques (diferentes números de paquete)
    echo "Contando el número de mensajes de red con ataques..." >> "$global_result_file"
    unique_packets=$(awk -F "," '{print $1}' "$combined_file" | sort | uniq | wc -l)
    echo "Número de mensajes de red con ataques: $unique_packets" >> "$global_result_file"

    echo "----------------------------------" >> "$global_result_file"
    echo "" >> "$global_result_file"
}

# Procesar cada archivo _combined_alerts.txt en el directorio actual
for combined_file in "$script_dir"/*_combined_alerts.txt; do
    process_combined_file "$combined_file"
done

echo "Análisis completado para todos los archivos _combined_alerts.txt."
echo "Los resultados se han guardado en $global_result_file"

