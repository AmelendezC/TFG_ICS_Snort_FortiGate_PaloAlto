#!/bin/bash

# Función para extraer los números de paquete de un archivo
extraer_numeros_paquete() {
    archivo=$1
    declare -A numeros_paquete_unicos

    # Leer el archivo línea por línea
    while IFS= read -r linea; do
        # Extraer el número de paquete (primer campo antes de la coma)
        numero_paquete=$(echo "$linea" | cut -d',' -f1 | tr -d ' ')
        
        # Comprobar si el número de paquete es un número y almacenarlo
        if [[ "$numero_paquete" =~ ^[0-9]+$ ]]; then
            numeros_paquete_unicos["$numero_paquete"]=1
        fi
    done < "$archivo"

    # Devolver los números de paquete únicos como una lista
    echo "${!numeros_paquete_unicos[@]}"
}

# Comparar los números de paquete entre dos archivos
comparar_archivos() {
    archivo1=$1
    archivo2=$2

    # Extraer los números de paquete únicos de ambos archivos
    numeros_paquete_archivo1=$(extraer_numeros_paquete "$archivo1")
    numeros_paquete_archivo2=$(extraer_numeros_paquete "$archivo2")

    # Unir ambos conjuntos de números de paquetes en un array
    declare -A numeros_paquete_unicos

    for numero in $numeros_paquete_archivo1; do
        numeros_paquete_unicos["$numero"]=1
    done

    for numero in $numeros_paquete_archivo2; do
        numeros_paquete_unicos["$numero"]=1
    done

    # Imprimir los números de paquetes únicos y su total
    echo "Números de paquete únicos entre $archivo1 y $archivo2:"
    printf "%s\n" "${!numeros_paquete_unicos[@]}"
    echo "Total de números de paquete distintos: ${#numeros_paquete_unicos[@]}"
}

# Verificar que se pasaron dos archivos como argumento
if [[ $# -ne 2 ]]; then
    echo "Uso: $0 <archivo1> <archivo2>"
    exit 1
fi

# Comparar los dos archivos pasados como argumento
comparar_archivos "$1" "$2"
