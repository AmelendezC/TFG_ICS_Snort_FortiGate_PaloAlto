#!/bin/bash

# Directorio donde se guardarán los resultados
RESULTS_DIR="Resultados_TALOS_3200"

# Ruta al ejecutable de Snort
SNORT="/usr/local/snort/bin/snort"

# Crear el directorio si no existe y aplicar permisos 766
if [ ! -d "$RESULTS_DIR" ]; then
  mkdir "$RESULTS_DIR"
  chmod 777 "$RESULTS_DIR"

else
  chmod 777 "$RESULTS_DIR"

fi

# Iterar sobre todos los archivos pcap en el directorio actual
for pcap in *.pcapng; do
  if [ -f "$pcap" ]; then
    # Nombre del archivo sin extensión
    pcap_name=$(basename "$pcap" .pcapng)

    # Ejecutar Snort con el archivo pcap
    "$SNORT" --talos -c /usr/local/snort/etc/snort/snort.lua -r "$pcap" -l /home/kali/Desktop/ -A alert_fast

    # Renombrar el archivo de alerta generado y cambiar permisos
    if [ -f "/home/kali/Desktop/alert_fast.txt" ]; then
      chmod 766 "/home/kali/Desktop/alert_fast.txt"
      mv "/home/kali/Desktop/alert_fast.txt" "$RESULTS_DIR/${pcap_name}_alert_fast.txt"
      chmod 766 "$RESULTS_DIR/${pcap_name}_alert_fast.txt"
      echo "Análisis de $pcap completado. Resultados guardados en $RESULTS_DIR/${pcap_name}_alert_fast.txt"
    else
      echo "Error: No se encontró alert_fast.txt para $pcap"
    fi

    # Esperar un tiempo antes del próximo análisis (por ejemplo, 5 segundos)
    sleep 10
  fi
done

echo "Análisis completado."

