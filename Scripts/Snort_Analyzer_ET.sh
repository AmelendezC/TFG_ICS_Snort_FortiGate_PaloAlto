#!/bin/bash

# Directorio donde se almacenarán los resultados
output_dir="Resultados_quickdraw"

# Verificar si el directorio de resultados existe, si no, crearlo
if [ ! -d "$output_dir" ]; then
  mkdir "$output_dir"
  chmod 777 "$output_dir"
fi

# Analizar cada archivo pcap en el directorio actual
for pcap_file in *.pcapng; do
  if [ -f "$pcap_file" ]; then
    # Ejecutar Snort con el archivo pcap
    sudo snort -c /etc/snort/snort.conf -l "$output_dir" -r "$pcap_file"
    
    # Renombrar el archivo de alerta generado
    alert_file="$output_dir/snort.alert.fast"
    if [ -f "$alert_file" ]; then
	  chmod 766 "$alert_file"
      mv "$alert_file" "$output_dir/${pcap_file%.pcapng}.alert.fast"
      chmod 766 "$output_dir/${pcap_file%.pcapng}.alert.fast"
    fi
    
    # Esperar 10 segundos antes de analizar el siguiente archivo (puedes ajustar el tiempo según sea necesario)
    sleep 10
  fi
done

echo "Análisis completado."
