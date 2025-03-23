#!/bin/bash

# Nombre del archivo de salida
output_file="resultados_alertas_etopen.csv"

# Crear o vaciar el archivo de salida
echo "Archivo,Lineas" > $output_file

# Lista de SIDs a excluir
sids="1917|24303|57155|40517|2002752|2002749|2009207|2009208|2009206|2012648|2100527"

# Iterar sobre todos los archivos *_combined_alerts.txt en el directorio actual
for log_file in *_combined_alerts.txt; do
  if [[ -f "$log_file" ]]; then
    # Contar todas las líneas que no contienen los SIDs excluidos y eliminar líneas vacías
    line_count=$(grep -vE "\[1:($sids):" "$log_file" | grep -vE '^\s*$' | wc -l)
    
    # Añadir el resultado al archivo CSV
    echo "$log_file,$line_count" >> $output_file
  else
    echo "No se encontró el archivo $log_file"
  fi
done

echo "Resultados guardados en $output_file"
