#!/bin/bash

# Nombre del archivo CSV de salida
OUTPUT_FILE="resultados_flujos_totales.csv"

# Crear el archivo CSV e incluir la cabecera
echo "archivo,num_flujos_totales" > "$OUTPUT_FILE"

# Iterar sobre todos los archivos .pcapng en el directorio actual
for PCAP_FILE in *.pcapng; do
  # Verificar si hay archivos .pcapng en el directorio
  if [ ! -f "$PCAP_FILE" ]; then
    echo "No se encontraron archivos .pcapng en el directorio."
    exit 1
  fi

  echo "Procesando archivo: $PCAP_FILE"

  # Contar el número de flujos TCP
  tcp_flows=$(tshark -r "$PCAP_FILE" -q -z conv,tcp | grep "^[0-9]" | wc -l)

  # Contar el número de flujos UDP
  udp_flows=$(tshark -r "$PCAP_FILE" -q -z conv,udp | grep "^[0-9]" | wc -l)

  # Contar el número de flujos ICMP
  icmp_flows=$(tshark -r "$PCAP_FILE" -q -z conv,icmp | grep "^[0-9]" | wc -l)

  # Calcular el número total de flujos
  total_flows=$((tcp_flows + udp_flows + icmp_flows))

  # Guardar los resultados en el archivo CSV
  echo "$PCAP_FILE,$total_flows" >> "$OUTPUT_FILE"

  echo "Resultados para $PCAP_FILE guardados en $OUTPUT_FILE"
done

echo "Proceso completado. Los resultados se han guardado en $OUTPUT_FILE"
