#!/bin/bash

# Verificar que se hayan pasado el archivo de log y los SIDs como argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 nombre_archivo_log SID1 [SID2 ... SIDn]"
    exit 1
fi

# Archivo de log proporcionado como primer argumento
archivo_log="$1"
shift

# Convertir los SIDs a un array (el resto de los argumentos)
sids_excluir=("$@")

# Función para verificar si un SID está en la lista de exclusión
function sid_excluido() {
    local sid="$1"
    for sid_excluido in "${sids_excluir[@]}"; do
        if [[ "$sid" == "$sid_excluido" ]]; then
            return 0
        fi
    done
    return 1
}

echo "Procesando archivo: $archivo_log"

# Contador de flujos únicos, números de paquetes únicos en dirección C2S y contador de líneas procesadas
declare -A flujos_unicos
declare -A paquetes_unicos_C2S
contador_instancias=0  # Contador de líneas que no contienen los SIDs excluidos y van de C2S

echo "Flujos detectados en $archivo_log:"

# Iterar sobre cada línea del archivo de log CSV
while IFS=',' read -r fecha_hora num_paquete proto stream len dir src_ap dst_ap rule action msg class; do
    # Eliminar espacios en blanco al inicio y al final de los campos
    src_ap=$(echo $src_ap | xargs)
    dst_ap=$(echo $dst_ap | xargs)
    dir=$(echo $dir | xargs)
    num_paquete=$(echo $num_paquete | xargs)
    rule=$(echo $rule | xargs)

    # Extraer el SID del campo rule (asumiendo que el formato es 1:1917:16)
    sid=$(echo "$rule" | cut -d':' -f2)

    # Verificar si el SID está en la lista de exclusión
    if sid_excluido "$sid"; then
        # Si el SID está en la lista de exclusión, omitimos este flujo y mensaje
        continue
    fi

    # Verificar si la dirección es C2S antes de contar la instancia
    if [[ "$dir" == "C2S" ]]; then
        # Incrementar el contador de líneas que no contienen SIDs excluidos y van de C2S
        ((contador_instancias++))
        
        # Crear una clave única para el flujo basada en la dirección del flujo y direcciones IP y puertos
        flujo="$src_ap -> $dst_ap"
        flujo_inverso="$dst_ap -> $src_ap"
        
        # Contabilizar número de paquete único en dirección C2S
        paquetes_unicos_C2S["$num_paquete"]=1

        # Si el flujo o su inverso es único, agregarlo al array y mostrarlo
        if [[ -z "${flujos_unicos[$flujo]}" && -z "${flujos_unicos[$flujo_inverso]}" ]]; then
            flujos_unicos["$flujo"]=1
            echo "$flujo"
        fi
    fi
done < "$archivo_log"

# Contar el número de flujos únicos
num_flujos=$(echo ${#flujos_unicos[@]})

# Contar el número de paquetes únicos en dirección C2S
num_paquetes_C2S=$(echo ${#paquetes_unicos_C2S[@]})

echo "Número de flujos con ataques $archivo_log: $num_flujos"
echo "Número de mensajes con ataques $archivo_log: $num_paquetes_C2S"
echo "Número de instancias (líneas) procesadas sin los SIDs excluidos y que van de C2S: $contador_instancias"
echo "----------------------------------------"

echo "Procesamiento de $archivo_log completado."
