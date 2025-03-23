#!/bin/bash

# Función para extraer flujos de ambos archivos y devolver flujos únicos
extraer_flujos() {
    declare -A flujos_unicos

    for archivo in "$@"; do
        while IFS= read -r linea; do
            # Buscar flujos TCP/UDP que sigan el formato "IP:Puerto -> IP:Puerto"
            flujo_tcp_udp=$(echo "$linea" | grep -oP '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:\d+)[[:space:]]*->\s*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:\d+)')
            
            if [[ -n "$flujo_tcp_udp" ]]; then
                # Almacenar el flujo TCP/UDP en un array asociativo (como clave)
                flujos_unicos["$flujo_tcp_udp"]=1
            fi
            
            # Buscar flujos ICMP del tipo "IP origen -> IP destino"
            flujo_icmp=$(echo "$linea" | grep -oP '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)[[:space:]]*->\s*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
            
            if [[ -n "$flujo_icmp" ]]; then
                # Almacenar el flujo ICMP en un array asociativo (como clave)
                flujos_unicos["$flujo_icmp"]=1
            fi
        done < "$archivo"
    done

    # Devolver el número total de flujos únicos y los flujos
    total_flujos=${#flujos_unicos[@]}
    echo "Número total de flujos distintos: $total_flujos"
    echo "Flujos totales únicos:"
    printf "%s\n" "${!flujos_unicos[@]}"
}

# Verificar que se pasaron al menos dos archivos como argumento
if [[ $# -lt 2 ]]; then
    echo "Uso: $0 <archivo1> <archivo2> [archivo3 ...]"
    exit 1
fi

# Comparar los archivos pasados como argumento y mostrar flujos únicos
extraer_flujos "$@"

