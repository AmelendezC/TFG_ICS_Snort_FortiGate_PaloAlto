#!/bin/bash

# Crear la carpeta de resultados si no existe
mkdir -p resultados_mensajes

# Aplicar permisos 777 a la carpeta
chmod 777 resultados_mensajes

# Verificar que existen archivos _alert_csv.txt en el directorio
shopt -s nullglob  # Activar el modo de que los globos vacíos se conviertan en un array vacío
archivos=(*_alert_csv.txt)

if [[ ${#archivos[@]} -eq 0 ]]; then
    echo "No se encontraron archivos *_alert_csv.txt en el directorio actual."
    exit 1
fi

# Procesar cada archivo _alert_csv.txt
for archivo in "${archivos[@]}"; do
    echo "Procesando el archivo: $archivo"
    
    # Crear un array temporal para almacenar los números de paquete únicos para cada archivo
    declare -A numeros_paquete_unicos

    # Leer el archivo línea por línea
    while IFS= read -r linea; do
        # Extraer el número de paquete (segundo campo en la línea)
        numero_paquete=$(echo "$linea" | cut -d',' -f2 | tr -d ' ')
        
        # Comprobar si el número de paquete es un número y almacenarlo
        if [[ "$numero_paquete" =~ ^[0-9]+$ ]]; then
            numeros_paquete_unicos["$numero_paquete"]=1
        fi
    done < "$archivo"

    # Generar el nombre del archivo de salida
    nombre_salida="resultados_mensajes/$(basename "$archivo" .txt)_resultado.txt"

    # Escribir los números de paquete únicos en el archivo de salida
    {
        echo "Números de paquete distintos encontrados en el archivo $archivo:"
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

