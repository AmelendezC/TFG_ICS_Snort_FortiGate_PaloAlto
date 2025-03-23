#!/bin/bash

# Obtener el directorio donde se encuentra el script
script_dir=$(dirname "$0")

# Directorio donde se guardarán los resultados
result_dir="$script_dir/Resultados_QuickDraw"

# Crear el directorio de resultados si no existe
mkdir -p "$result_dir"
chmod 777 "$result_dir"

# Verificar que hay al menos un archivo PCAPNG en el directorio
pcap_files=("$script_dir"/*.pcapng)
if [ ${#pcap_files[@]} -eq 0 ]; then
    echo "No se encontraron archivos PCAPNG en el directorio."
    exit 1
fi

# Configuración de Snort
snort_conf="/etc/snort/snort.conf"
snort_output_dir="$script_dir"  # Directorio de salida para Snort (el mismo que script_dir)

# Función para procesar un archivo PCAPNG
process_pcap() {
    local pcap_file="$1"
    local base_name=$(basename "$pcap_file" .pcapng)
    
    # Definir los nombres de los archivos de salida
    alert_file="$snort_output_dir/alert"
    fast_file="$snort_output_dir/snort.alert.fast"
    combined_file="$snort_output_dir/${base_name}_combined_alerts.txt"

    echo "Procesando $pcap_file..."

    # 1. Ejecutar Snort para generar el archivo alert
    snort -c "$snort_conf" -l "$snort_output_dir" -r "$pcap_file" -A test

	sleep 7
    
    # Verificar si el archivo alert se generó
    if [[ ! -f "$alert_file" ]]; then
        echo "Error: No se generó el archivo alert para $pcap_file."
        return 1
    fi

    # 2. Ejecutar Snort para generar el archivo snort.alert.fast
    snort -c "$snort_conf" -l "$snort_output_dir" -r "$pcap_file" 
	
	sleep 7
    
    # Verificar si el archivo alert.fast se generó
    if [[ ! -f "$fast_file" ]]; then
        echo "Error: No se generó el archivo alert.fast para $pcap_file."
        return 1
    fi

    # 3. Combinar alert y snort.alert.fast
    if [[ -f "$alert_file" && -f "$fast_file" ]]; then
        # Crear o vaciar el archivo de salida combinado
        > "$combined_file"

        # Leer ambos archivos línea por línea y combinar
        exec 3<"$fast_file"
        while IFS= read -r test_line && IFS= read -r fast_line <&3
        do
            # Extraer el Packet ID, SID, y el timestamp de alert (eliminando GID y revisión)
            packet_id=$(echo "$test_line" | awk '{print $1}')
            sid=$(echo "$test_line" | awk '{print $3}')
            timestamp=$(echo "$test_line" | awk '{print $2}')

            # Combinar Packet ID, SID, y Timestamp, y añadir la línea de alert_fast
            echo "$packet_id,$sid,$timestamp $fast_line" >> "$combined_file"

        done < "$alert_file"

        echo "El archivo combinado se ha guardado en $combined_file"
    else
        echo "Error: No se encontraron los archivos de salida alert o snort.alert.fast."
        return 1
    fi

    # Mover el archivo combinado al directorio de resultados
    mv "$combined_file" "$result_dir"

    # Limpiar los archivos de salida de Snort
    rm -f "$alert_file" "$fast_file"
}

# Procesar cada archivo PCAPNG en el directorio actual
for pcap_file in "$script_dir"/*.pcapng; do
    process_pcap "$pcap_file"
done

echo "Análisis completado para todos los archivos PCAPNG."


