#!/bin/bash

# Comprobar si se han pasado suficientes argumentos
if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <appid1> [<appid2> ...] <archivo_csv>"
  exit 1
fi

# El último argumento es el archivo CSV
file_path="${!#}"

# Comprobar si el archivo CSV existe
if [[ ! -f "$file_path" ]]; then
  echo "El archivo $file_path no existe. Por favor, verifica la ruta."
  exit 1
fi

# Obtener los appid a filtrar como un array
appid_filtro="${@:1:$#-1}"

# Usar awk para procesar el archivo CSV
awk -v filtros="$appid_filtro" '
  BEGIN {
    # Convertir los appid a filtrar en un array
    split(filtros, appid_filtros, " ")
    for (i in appid_filtros) {
      filtro_map[appid_filtros[i]] = 1  # Guardar cada appid a filtrar en un mapa
    }
  }
  NR > 1 {
    # Si el appid de la línea está en el mapa de filtros, saltar esa línea
    if ($1 in filtro_map) {
      next
    }

    # Si la línea no se filtra, almacenar los appid y sessionid
    appids[$1] = 1
    sessionids[$2] = 1
  }
  END {
    # Mostrar los appid distintos que no fueron filtrados
    printf "Distintos appid (sin contar los appid filtrados): "
    for (appid in appids) {
      printf "%s ", appid
    }
    print ""

    # Mostrar el número total de sessionid únicos
    print "Nº total de distintos sessionid: " length(sessionids)
  }
' "$file_path"





