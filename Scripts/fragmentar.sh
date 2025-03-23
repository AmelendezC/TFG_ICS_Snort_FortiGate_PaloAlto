#!/bin/bash

# Configura el nombre del archivo de configuración de fragroute
FRAGROUTE_CFG="frag.cfg"

# Verifica que el archivo de configuración de fragroute exista
if [[ ! -f "$FRAGROUTE_CFG" ]]; then
  echo "Error: Archivo de configuración $FRAGROUTE_CFG no encontrado."
  exit 1
fi

# Itera sobre cada archivo .pcapng en el directorio actual
for pcap_file in *.pcapng; do
  # Verifica que el archivo exista (evita errores si no hay archivos .pcapng)
  if [[ -f "$pcap_file" ]]; then
    # Define el nombre del archivo de salida
    output_file="${pcap_file%.pcapng}-fragmentado.pcapng"

    # Ejecuta tcprewrite con el archivo de configuración y el archivo de salida
    echo "Procesando $pcap_file..."
    tcprewrite --fragroute="$FRAGROUTE_CFG" -i "$pcap_file" -o "$output_file"

    # Verifica si tcprewrite se ejecutó correctamente
    if [[ $? -eq 0 ]]; then
      echo "Archivo fragmentado creado: $output_file"
    else
      echo "Error al procesar $pcap_file"
    fi
  fi
done

echo "Proceso completo."

