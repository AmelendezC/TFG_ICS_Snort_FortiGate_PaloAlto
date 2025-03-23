#!/bin/bash

# Obtener el directorio donde se encuentra el script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Archivo de salida de la tabla de detecciones
DETECTIONS_TABLE="$DIR/detections_table.csv"

# Inicializar la tabla de detecciones
echo "Nombre pcapng,nº entradas trafico legitimo,nº entradas de trafico de ataque,nº total de flujos identificados,nº de alertas" > "$DETECTIONS_TABLE"

# Procesar cada archivo .log en el directorio
for LOGFILE in "$DIR"/*.log; do
    # Verificar si existen archivos .log en el directorio
    if [[ ! -e "$LOGFILE" ]]; then
        echo "No se encontraron archivos .log en el directorio $DIR"
        exit 1
    fi

    # Archivo de salida para líneas extraídas
    OUTPUTFILE="${LOGFILE%.log}_filtered.log"
    ATTACKSFILE="${LOGFILE%.log}_attacks.log"

    # Extraer líneas con srcintf="port5" y policytype="sniffer"
    grep 'srcintf="port5"' "$LOGFILE" | grep 'policytype="sniffer"' > "$OUTPUTFILE"

    # Verificar tráfico legítimo y de ataques
    LEGIT_TRAFFIC=$(grep -c 'type="traffic".*subtype="sniffer"' "$LOGFILE")
    ATTACK_TRAFFIC=$(grep -c 'type="utm"' "$LOGFILE")

    # Calcular el número total de flujos identificados (diferentes sessionid)
    TOTAL_FLOWS=$(grep 'srcintf="port5"' "$LOGFILE" | grep 'policytype="sniffer"' | grep -o 'sessionid=[0-9]*' | sort | uniq | wc -l)

    # Calcular el número de alertas
    ALERTS=$(grep 'subtype="ips"' "$LOGFILE" | grep 'eventtype="signature"' | wc -l)

    # Extraer líneas con ataques basados en firmas
    grep 'attackid="ID_firma"' "$LOGFILE" > "$ATTACKSFILE"

    # Añadir resultados a la tabla de detecciones
    echo "$(basename "$LOGFILE"),$LEGIT_TRAFFIC,$ATTACK_TRAFFIC,$TOTAL_FLOWS,$ALERTS" >> "$DETECTIONS_TABLE"

    # Imprimir resultados en la consola
    echo "Procesando archivo: $LOGFILE"
    echo "Líneas extraídas con srcintf=\"port5\" y policytype=\"sniffer\" se han guardado en $OUTPUTFILE"
    echo "Número de entradas de tráfico legítimo: $LEGIT_TRAFFIC"
    echo "Número de entradas de tráfico de ataques: $ATTACK_TRAFFIC"
    echo "Nº Total de flujos identificados: $TOTAL_FLOWS"
    echo "Número de alertas: $ALERTS"
    echo "Líneas de ataques basados en firmas se han guardado en $ATTACKSFILE"
    echo "---------------------------------------------"
done
