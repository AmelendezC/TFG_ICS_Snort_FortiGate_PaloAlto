#!/bin/bash

# Verificar si se proporcionaron los argumentos necesarios
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 archivo_a_analizar.txt SID1 SID2 SID3 ... SIDn"
    exit 1
fi

# Archivo de texto a analizar (primer argumento)
combined_file="$1"
base_name=$(basename "$combined_file")

# Lista de SIDs a buscar (todos los argumentos después del primer)
shift
sid_list=("$@")

# Función para procesar el archivo combinado
process_combined_file() {
    local combined_file="$1"
    local base_name=$(basename "$combined_file")

    echo "Procesando $combined_file..."

    # Filtrar las líneas que contienen los SIDs proporcionados
    excluded_lines=$(grep -v -E "$(IFS='|'; echo "${sid_list[*]}")" "$combined_file")

    # Escribir el nombre del archivo procesado en la consola
    echo "Resultados para $base_name:"
    echo "=================================="

    # 1. Identificar los SIDs distintos que aparecen en el archivo, separados por comas
    unique_sids=$(echo "$excluded_lines" | awk -F "," '{print $2}' | sort | uniq | paste -sd "," -)
    echo "SIDs distintos que aparecen en el archivo (excluyendo los especificados): $unique_sids"

    # 2. Contar cuántos SIDs distintos aparecen
    total_distinct_sids=$(echo "$unique_sids" | tr -cd ',' | wc -c)
    total_distinct_sids=$((total_distinct_sids + 1)) # Agrega 1 ya que el conteo de comas es uno menos que el número de elementos
    echo "Cantidad de SIDs distintos: $total_distinct_sids"

    # 3. Contar el número total de alertas (número de líneas en el archivo después de excluir las líneas con los SIDs proporcionados)
    total_alerts=$(echo "$excluded_lines" | wc -l)
    echo "Número total de alertas (excluyendo los especificados): $total_alerts"

    # 4. Qué SIDs no aparecen en la lista, pero sí aparecen en el archivo
    sids_not_in_list=()
    for sid in $(echo $unique_sids | tr ',' ' '); do
        if [[ ! " ${sid_list[@]} " =~ " $sid " ]]; then
            sids_not_in_list+=("$sid")
        fi
    done
    sids_not_in_list_str=$(IFS=, ; echo "${sids_not_in_list[*]}")
    echo "SIDs que no aparecen en la lista: $sids_not_in_list_str"

    # 5. Qué SIDs sí aparecen en la lista y en el archivo (aunque ya están excluidos de los conteos)
    sids_in_list=()
    for sid in $(echo $unique_sids | tr ',' ' '); do
        if [[ " ${sid_list[@]} " =~ " $sid " ]]; then
            sids_in_list+=("$sid")
        fi
    done
    sids_in_list_str=$(IFS=, ; echo "${sids_in_list[*]}")
    echo "SIDs que aparecen en la lista: $sids_in_list_str"

    # 6. Contar el número total de flujos detectados (combinando direcciones opuestas)
    declare -A flows
    while IFS= read -r line; do
        src_ip_port=$(echo "$line" | awk -F "->" '{print $1}' | awk '{print $NF}')
        dst_ip_port=$(echo "$line" | awk -F "->" '{print $2}' | awk '{print $1}')
        flow="$src_ip_port->$dst_ip_port"
        reverse_flow="$dst_ip_port->$src_ip_port"

        if [[ -z "${flows[$flow]}" && -z "${flows[$reverse_flow]}" ]]; then
            flows["$flow"]=1
        fi
    done <<< "$excluded_lines"
    total_flows=${#flows[@]}
    echo "Nº total de flujos detectados (excluyendo los especificados): $total_flows"

    # 7. Contar el número de mensajes detectados (números de paquetes distintos)
    unique_packets=$(echo "$excluded_lines" | awk -F "," '{print $1}' | sort | uniq | wc -l)
    echo "Nº de mensajes detectados (excluyendo los especificados): $unique_packets"

    # 8. Número de instancias (igual al número total de alertas después de exclusión)
    echo "Nº de instancias (excluyendo los especificados): $total_alerts"

    echo "----------------------------------"
    echo ""
}

# Procesar el archivo proporcionado como argumento
process_combined_file "$combined_file"

echo "Análisis completado para el archivo $combined_file."

