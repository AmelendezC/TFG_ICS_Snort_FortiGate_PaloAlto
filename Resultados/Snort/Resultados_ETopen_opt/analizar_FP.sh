#!/bin/bash

# Verificar que se haya proporcionado el archivo de log y al menos un SID como argumento
if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <archivo_log> <SID1> [<SID2> ... <SIDn>]"
  exit 1
fi

# Obtener el archivo de log y los SIDs
archivo_log=$1
shift
sids=("$@")

# Inicializar contadores
lineas_total=0
declare -A paquetes_unicos

# Leer el archivo línea por línea
while IFS= read -r linea; do
  # Extraer el SID (segundo campo)
  sid=$(echo "$linea" | cut -d',' -f2 | tr -d ' ')
  
  # Verificar si el SID está en la lista proporcionada
  for sid_input in "${sids[@]}"; do
    if [ "$sid" == "$sid_input" ]; then
      # Incrementar el contador de líneas
      ((lineas_total++))
      
      # Extraer el número de paquete (primer campo, separado por comas)
      paquete=$(echo "$linea" | cut -d',' -f1 | tr -d ' ')
      
      # Agregar el número de paquete al array asociativo para asegurarse de que es único
      paquetes_unicos["$paquete"]=1
    fi
  done
done < "$archivo_log"

# Contar el número de paquetes únicos
num_paquetes=${#paquetes_unicos[@]}

# Mostrar resultados
echo "Número de líneas que contienen los SIDs proporcionados: $lineas_total"
echo "Número de paquetes únicos que contienen esos SIDs: $num_paquetes"

