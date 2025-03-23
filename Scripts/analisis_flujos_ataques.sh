#!/bin/bash

# Archivo de salida para los resultados
archivo_resultados="resultados.txt"

# Limpiar el archivo de resultados anterior si existe
> "$archivo_resultados"

# Procesar todos los archivos que terminan en _alert_csv.txt en el directorio actual
for archivo_log in *_alert_csv.txt; do
    echo "Procesando archivo: $archivo_log" >> "$archivo_resultados"

    # Contador de flujos únicos y números de paquetes únicos en dirección C2S
    declare -A flujos_unicos
    declare -A paquetes_unicos_C2S

    echo "Flujos detectados en $archivo_log:" >> "$archivo_resultados"

    # Iterar sobre cada línea del archivo de log CSV
    while IFS=',' read -r fecha_hora num_paquete proto stream len dir src_ap dst_ap rule action msg class; do
        # Eliminar espacios en blanco al inicio y al final de los campos
        src_ap=$(echo $src_ap | xargs)
        dst_ap=$(echo $dst_ap | xargs)
        dir=$(echo $dir | xargs)
        num_paquete=$(echo $num_paquete | xargs)
        
        # Crear una clave única para el flujo basada en la dirección del flujo y direcciones IP y puertos
        if [[ "$dir" == "C2S" ]]; then
            flujo="$src_ap -> $dst_ap"
            flujo_inverso="$dst_ap -> $src_ap"
            
            # Contabilizar número de paquete único en dirección C2S
            paquetes_unicos_C2S["$num_paquete"]=1
        else
            flujo="$dst_ap -> $src_ap"
            flujo_inverso="$src_ap -> $dst_ap"
        fi
        
        # Si el flujo o su inverso es único, agregarlo al array y mostrarlo
        if [[ -z "${flujos_unicos[$flujo]}" && -z "${flujos_unicos[$flujo_inverso]}" ]]; then
            flujos_unicos["$flujo"]=1
            echo "$flujo" >> "$archivo_resultados"
        fi

    done < "$archivo_log"

    # Contar el número de flujos únicos
    num_flujos=$(echo ${#flujos_unicos[@]})

    # Contar el número de paquetes únicos en dirección C2S
    num_paquetes_C2S=$(echo ${#paquetes_unicos_C2S[@]})

    echo "Número de flujos con ataques $archivo_log: $num_flujos" >> "$archivo_resultados"
    echo "Número de mensajes con ataques $archivo_log: $num_paquetes_C2S" >> "$archivo_resultados"
    echo "----------------------------------------" >> "$archivo_resultados"

    # Limpiar las variables para el siguiente archivo
    unset flujos_unicos
    unset paquetes_unicos_C2S

done

echo "Procesamiento de todos los archivos completado." >> "$archivo_resultados"




