#!/bin/bash

# Crear carpeta para resultados si no existe
mkdir -p resultados_flujos
chmod 777 resultados_flujos

# Procesar todos los archivos que terminan en .txt en el directorio actual
for archivo_log in *_combined_alerts.txt; do
    echo "Procesando archivo: $archivo_log"

    # Extraer flujos únicos del archivo, normalizando para que A -> B sea igual que B -> A
    flujos_unicos=$(grep -oP '\d{1,3}(?:\.\d{1,3}){3}:\d{1,5} -> \d{1,3}(?:\.\d{1,3}){3}:\d{1,5}' "$archivo_log" \
        | awk -F ' -> ' '{if ($1 < $2) print $1 " -> " $2; else print $2 " -> " $1}' \
        | sort -u)

    # Contar el número de flujos únicos
    num_flujos=$(echo "$flujos_unicos" | wc -l)

    # Guardar los resultados en un archivo en la carpeta resultados_flujos
    echo "Número total de flujos distintos en $archivo_log: $num_flujos" > "resultados_flujos/${archivo_log}_resultados.txt"
    echo "$flujos_unicos" >> "resultados_flujos/${archivo_log}_resultados.txt"

    # Mostrar en pantalla los flujos únicos
    echo "Flujos únicos en $archivo_log:"
    echo "$flujos_unicos"
    echo "Resultados guardados en resultados_flujos/${archivo_log}_resultados.txt."
done

echo "Procesamiento completado."
