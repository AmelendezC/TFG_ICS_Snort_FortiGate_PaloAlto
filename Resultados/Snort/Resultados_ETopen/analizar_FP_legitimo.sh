#!/bin/bash

# Verificar que se hayan proporcionado al menos un SID como argumento
if [ "$#" -lt 1 ]; then
  echo "Uso: $0 <SID1> [<SID2> ... <SIDn>]"
  exit 1
fi

# Obtener los SIDs proporcionados
sids=("$@")

# Crear o vaciar el archivo CSV
output_csv="resultado.csv"
echo "Nombre del archivo,Porcentaje de Alertas con SIDs" > "$output_csv"

# Analizar todos los archivos _combined_alerts.txt en el directorio actual
for archivo_log in *_combined_alerts.txt; do
  # Inicializar contadores para cada archivo
  total_alertas=0
  alertas_con_sids=0

  # Leer el archivo línea por línea
  while IFS= read -r linea; do
    # Incrementar el contador de alertas totales
    ((total_alertas++))

    # Extraer el SID (segundo campo)
    sid=$(echo "$linea" | cut -d',' -f2 | tr -d ' ')

    # Verificar si el SID está en la lista proporcionada
    for sid_input in "${sids[@]}"; do
      if [ "$sid" == "$sid_input" ]; then
        # Incrementar el contador de alertas con SIDs si se encuentra el SID
        ((alertas_con_sids++))
        break  # Salir del bucle de SIDs, ya que hemos encontrado al menos uno
      fi
    done
  done < "$archivo_log"

  # Calcular el porcentaje de alertas que contienen alguno de los SIDs usando bc
  if [ "$total_alertas" -gt 0 ]; then
    porcentaje_alertas=$(echo "scale=4; ($alertas_con_sids / $total_alertas) * 100" | bc)
  else
    porcentaje_alertas=0
  fi

  # Agregar el nombre del archivo y el porcentaje al archivo CSV
  echo "$archivo_log,$porcentaje_alertas" >> "$output_csv"
done

# Mostrar mensaje de finalización
echo "El análisis ha finalizado. Los resultados se han guardado en $output_csv"

