#!/bin/bash

# Verificar si se pasaron suficientes argumentos
if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <sid1> <sid2> ... <sidN>"
    exit 1
fi

# Crear carpeta para resultados si no existe
mkdir -p resultados_flujos_TP
chmod 777 resultados_flujos_TP

# Crear una expresión regular para excluir los SIDs proporcionados como argumentos
exclude_sids=$(printf "|%s" "$@")
exclude_sids=${exclude_sids:1}  # Eliminar el primer "|"

# Procesar todos los archivos que terminan en _combined_alerts.txt en el directorio actual
for archivo_log in *_combined_alerts.txt; do
    echo "Procesando archivo: $archivo_log"

    # Extraer flujos únicos del archivo, excluyendo líneas que contengan los SIDs especificados
    flujos_unicos=$(grep -Pv "(\[.*:($exclude_sids):.*\])" "$archivo_log" \
        | grep -oP '\d{1,3}(?:\.\d{1,3}){3}:\d{1,5} -> \d{1,3}(?:\.\d{1,3}){3}:\d{1,5}' \
        | awk -F ' -> ' '{if ($1 < $2) print $1 " -> " $2; else print $2 " -> " $1}' \
        | sort -u)

    # Contar el número de flujos únicos
    num_flujos=$(echo "$flujos_unicos" | wc -l)

    # Guardar los resultados en un archivo en la carpeta resultados_flujos_TP
    echo "Número total de flujos distintos en $archivo_log (sin los SIDs $@): $num_flujos" > "resultados_flujos_TP/${archivo_log}_resultados.txt"
    echo "$flujos_unicos" >> "resultados_flujos_TP/${archivo_log}_resultados.txt"

    # Mostrar en pantalla los flujos únicos
    echo "Flujos únicos en $archivo_log (excluyendo SIDs $@):"
    echo "$flujos_unicos"
    echo "Resultados guardados en resultados_flujos_TP/${archivo_log}_resultados.txt."
done

echo "Procesamiento completado."
