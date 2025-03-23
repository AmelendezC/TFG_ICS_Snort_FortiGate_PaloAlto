#!/bin/bash

# Verificar que se pasaron dos argumentos
if [[ $# -ne 2 ]]; then
    echo "Uso: $0 <archivo1> <archivo2>"
    exit 1
fi

archivo1="$1"
archivo2="$2"

# Verificar si los archivos existen
if [[ ! -f "$archivo1" || ! -f "$archivo2" ]]; then
    echo "Uno o ambos archivos no existen."
    exit 1
fi

# Crear un array para almacenar flujos únicos
declare -A flujos

# Función para procesar un archivo y extraer flujos únicos
procesar_archivo() {
    local archivo="$1"

    while IFS= read -r linea; do
        # Extraer flujos en formato "IP:puerto -> IP:puerto"
        flujos_unicos=$(echo "$linea" | grep -oP '\d{1,3}(?:\.\d{1,3}){3}:\d{1,5} -> \d{1,3}(?:\.\d{1,3}){3}:\d{1,5}' \
                         | awk -F ' -> ' '{if ($1 < $2) print $1 " -> " $2; else print $2 " -> " $1}' \
                         | sort -u)
        
        # Agregar flujos al array
        while read -r flujo; do
            if [[ -n "$flujo" ]]; then  # Verificar que el flujo no esté vacío
                flujos["$flujo"]=1
            fi
        done <<< "$flujos_unicos"

    done < "$archivo"
}

# Procesar ambos archivos
procesar_archivo "$archivo1"
num_flujos_archivo1=${#flujos[@]}

# Guardar una copia del estado del array antes de procesar el segundo archivo
flujos_originales=("${!flujos[@]}")

# Vaciar el array para almacenar flujos del segundo archivo
declare -A flujos_archivo2

# Procesar el segundo archivo
procesar_archivo "$archivo2"
num_flujos_archivo2=${#flujos[@]}

# Contar flujos únicos entre ambos archivos
declare -A flujos_totales

# Llenar flujos_totales con los flujos del primer archivo
for flujo in "${flujos_originales[@]}"; do
    flujos_totales["$flujo"]=1
done

# Agregar los flujos del segundo archivo
for flujo in "${!flujos[@]}"; do
    flujos_totales["$flujo"]=1
done

# Contar el número total de flujos distintos
num_flujos_totales=${#flujos_totales[@]}

# Mostrar los resultados
echo "Número total de flujos distintos en $archivo1: $num_flujos_archivo1"
echo "Número total de flujos distintos en $archivo2: $num_flujos_archivo2"
echo "Número total de flujos distintos entre ambos archivos: $num_flujos_totales"

echo ""  # Línea en blanco para separar resultados

# Mostrar flujos únicos
echo "Flujos distintos encontrados en ambos archivos:"
for flujo in "${!flujos_totales[@]}"; do
    echo "$flujo"
done

echo "Procesamiento completado."

