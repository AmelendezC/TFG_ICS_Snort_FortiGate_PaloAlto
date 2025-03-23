#!/bin/bash

MTU=65521
# Ejecución: ./convertir_pcap_a_pcapng.sh

# Directorio que contiene los archivos pcap (actual por defecto)
DIRECTORIO="."

# Recorre todos los archivos .pcap en el directorio
for archivo in "$DIRECTORIO"/*.pcap; do
    # Define el nombre del nuevo archivo pcapng
    nuevo_archivo="${archivo%.pcap}.pcapng"
    
    # Convierte el archivo
    editcap -s $MTU -F pcapng "$archivo" "$nuevo_archivo"
    
    echo "Convertido: $archivo a $nuevo_archivo"
done

