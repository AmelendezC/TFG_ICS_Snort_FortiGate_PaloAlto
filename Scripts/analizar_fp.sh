#!/bin/bash

# Verificar que se hayan proporcionado los argumentos correctos
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
declare -A flujos_unicos
declare -A paquetes_unicos

# Leer el archivo línea por línea
while IFS= read -r linea; do
  for sid in "${sids[@]}"; do
    # Verificar si la línea contiene el SID
    if echo "$linea" | grep -q ":$sid:"; then
      # Incrementar el contador de líneas
      ((lineas_total++))
      
      # Extraer el número de paquete (segundo campo, separado por comas)
      paquete=$(echo "$linea" | cut -d',' -f2 | tr -d ' ')
      
      # Agregar el número de paquete al array asociativo para asegurarse de que es único
      paquetes_unicos["$paquete"]=1

      # Extraer las direcciones IP y puertos de origen y destino
      flujo=$(echo "$linea" | cut -d',' -f7 | tr -d ' ')
      ip_origen=$(echo "$flujo" | cut -d':' -f1)
      puerto_origen=$(echo "$flujo" | cut -d':' -f2)
      
      flujo_destino=$(echo "$linea" | cut -d',' -f8 | tr -d ' ')
      ip_destino=$(echo "$flujo_destino" | cut -d':' -f1)
      puerto_destino=$(echo "$flujo_destino" | cut -d':' -f2)

      # Crear una cadena única que represente el flujo en ambas direcciones
      flujo_unico="${ip_origen}:${puerto_origen}-${ip_destino}:${puerto_destino}"
      flujo_reverso="${ip_destino}:${puerto_destino}-${ip_origen}:${puerto_origen}"

      # Verificar y agregar al array asociativo para asegurarse de que el flujo es único
      if [[ -z "${flujos_unicos[$flujo_unico]}" && -z "${flujos_unicos[$flujo_reverso]}" ]]; then
        flujos_unicos["$flujo_unico"]=1
      fi
    fi
  done
done < "$archivo_log"

# Contar el número de flujos únicos
num_flujos=${#flujos_unicos[@]}

# Contar el número de paquetes únicos
num_paquetes=${#paquetes_unicos[@]}

# Mostrar resultados
echo "Número de líneas que contienen los SIDs proporcionados: $lineas_total"
echo "Número de flujos únicos que contienen esos SIDs: $num_flujos"
echo "Número de paquetes únicos que contienen esos SIDs: $num_paquetes"


