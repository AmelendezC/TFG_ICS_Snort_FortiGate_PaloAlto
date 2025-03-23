#!/bin/bash

# Crear la carpeta de resultados si no existe
mkdir -p resultados_mensajes_TP

# Aplicar permisos 777 a la carpeta
chmod 777 resultados_mensajes_TP

# Verificar que existen archivos _combined_alerts.txt en el directorio
shopt -s nullglob  # Activar el modo de que los globos vacíos se conviertan en un array vacío
archivos=(*_combined_alerts.txt)

if [[ ${#archivos[@]} -eq 0 ]]; then
    echo "No se encontraron archivos *_combined_alerts.txt en el directorio actual."
    exit 1
fi

# Lista de SIDs a excluir (predefinidos dentro del script)
sids="1917|24303|57155|40517|2002752|2002749|2009207|2009208|2009206|2012648|2100527"

# Procesar cada archivo _combined_alerts.txt
for archivo in "${archivos[@]}"; do
    echo "Procesando el archivo: $archivo"
    
    # Crear un array temporal para almacenar los números de paquete únicos para cada archivo
    declare -A numeros_paquete_unicos

    # Leer el archivo línea por línea
    while IFS= read -r linea; do
        # Comprobar si la línea contiene alguno de los SIDs a excluir
        if echo "$linea" | grep -Eq "\[1:($sids):"; then
            continue  # Si contiene un SID a excluir, saltar a la siguiente línea
        fi
        
        # Extraer el número de paquete (primer campo antes de la coma)
        numero_paquete=$(echo "$linea" | cut -d',' -f1 | tr -d ' ')
        
        # Comprobar si el número de paquete es un número y almacenarlo
        if [[ "$numero_paquete" =~ ^[0-9]+$ ]]; then
            numeros_paquete_unicos["$numero_paquete"]=1
        fi
    done < "$archivo"

    # Generar el nombre del archivo de salida
    nombre_salida="resultados_mensajes_TP/$(basename "$archivo" .txt)_resultado.txt"

    # Escribir los números de paquete únicos en el archivo de salida
    {
        echo "Números de paquete distintos encontrados en el archivo $archivo (excluyendo SIDs $sids):"
        for numero in "${!numeros_paquete_unicos[@]}"; do
            echo "$numero"
        done
        
        # Contar el total de números de paquete únicos
        total_numeros=${#numeros_paquete_unicos[@]}
        echo "Total de números de paquete distintos: $total_numeros"
    } > "$nombre_salida"

    echo "Resultados guardados en: $nombre_salida"

    # Limpiar el array asociativo para no acumular números de otros archivos
    unset numeros_paquete_unicos
done

echo "Procesamiento completado."
