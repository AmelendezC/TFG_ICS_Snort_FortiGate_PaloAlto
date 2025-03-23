#!/bin/bash

# Directorio actual donde se encuentran los archivos _combined_alerts.txt
script_dir=$(dirname "$0")

# Archivo de resultados global
global_result_file="$script_dir/resultados_globales_def.txt"

# Archivo CSV para almacenar los resultados
csv_file="$script_dir/resultados_globales.csv"

# Crear o vaciar el archivo de resultados global y CSV
> "$global_result_file"
echo "Nombre del archivo, SIDs distintos sin repetir, Cantidad de SIDs distintos, Número total de alertas, SIDs que no aparecen en la lista, SIDs que aparecen en la lista" > "$csv_file"

# Lista de SIDs que se deben buscar
sid_list=("2002752" "2002749" "2009207" "2009208" "2009206" "2012648" "2100527" "527")

# Función para procesar cada archivo combinado
process_combined_file() {
    local combined_file="$1"
    local base_name=$(basename "$combined_file")

    echo "Procesando $combined_file..."

    # Escribir el nombre del archivo procesado en el archivo de resultados global
    echo "Resultados para $base_name:" >> "$global_result_file"
    echo "==================================" >> "$global_result_file"

    # 1. Identificar los SIDs distintos que aparecen en el archivo, separados por comas
    unique_sids=$(awk -F "," '{print $2}' "$combined_file" | sort | uniq | paste -sd "," -)
    echo "SIDs distintos que aparecen en el archivo: $unique_sids" >> "$global_result_file"

    # 2. Contar cuántos SIDs distintos aparecen
    total_distinct_sids=$(echo "$unique_sids" | tr -cd ',' | wc -c)
    total_distinct_sids=$((total_distinct_sids + 1)) # Agrega 1 ya que el conteo de comas es uno menos que el número de elementos
    echo "Cantidad de SIDs distintos: $total_distinct_sids" >> "$global_result_file"

    # 3. Contar el número total de alertas (número de líneas en el archivo)
    total_alerts=$(wc -l < "$combined_file")
    echo "Número total de alertas: $total_alerts" >> "$global_result_file"

    # 4. Qué SIDs no aparecen en la lista, pero sí aparecen en el archivo
    sids_not_in_list=()
    for sid in $(echo $unique_sids | tr ',' ' '); do
        if [[ ! " ${sid_list[@]} " =~ " $sid " ]]; then
            sids_not_in_list+=("$sid")
        fi
    done
    sids_not_in_list_str=$(IFS=, ; echo "${sids_not_in_list[*]}")
    echo "SIDs que no aparecen en la lista: $sids_not_in_list_str" >> "$global_result_file"

    # 5. Qué SIDs sí aparecen en la lista y en el archivo
    sids_in_list=()
    for sid in $(echo $unique_sids | tr ',' ' '); do
        if [[ " ${sid_list[@]} " =~ " $sid " ]]; then
            sids_in_list+=("$sid")
        fi
    done
    sids_in_list_str=$(IFS=, ; echo "${sids_in_list[*]}")
    echo "SIDs que aparecen en la lista: $sids_in_list_str" >> "$global_result_file"

    # Guardar los resultados en el archivo CSV
    echo "$base_name, \"$unique_sids\", $total_distinct_sids, $total_alerts, \"$sids_not_in_list_str\", \"$sids_in_list_str\"" >> "$csv_file"

    echo "----------------------------------" >> "$global_result_file"
    echo "" >> "$global_result_file"
}

# Procesar cada archivo _combined_alerts.txt en el directorio actual
for combined_file in "$script_dir"/*_combined_alerts.txt; do
    process_combined_file "$combined_file"
done

echo "Análisis completado para todos los archivos _combined_alerts.txt."
echo "Los resultados se han guardado en $global_result_file y $csv_file"

