SNORT:

snort_talos_analyze.sh: Este script ejecuta Snort para analizar archivos pcapng en un directorio específico. Si no existe, crea un directorio para guardar los resultados del análisis. Los resultados se guardan en un archivo de texto en dicho directorio. El script asegura los permisos adecuados y utiliza un archivo de configuración específico de Snort.


Snort_Analyzer_ET.sh: Este script analiza archivos pcapng en el directorio actual utilizando Snort y guarda los resultados en un directorio llamado Resultados_quickdraw o ETopen. Si el directorio no existe, lo crea. Luego, por cada archivo pcapng:

Ejecuta Snort para analizarlo.

Renombra el archivo de alerta generado por Snort y ajusta sus permisos.

Espera 10 segundos antes de analizar el siguiente archivo.

Al finalizar, muestra un mensaje indicando que el análisis está completo.


Snort_Analyze_3200.sh: Este script analiza archivos pcapng con Snort, guarda los resultados en el directorio Resultados_TALOS_3200, y renombra los archivos de alerta generados. Si el directorio no existe, lo crea. Luego, para cada archivo pcap, ejecuta Snort, guarda las alertas con el nombre del archivo pcap y espera 10 segundos antes de continuar con el siguiente análisis. Al finalizar, muestra un mensaje de éxito.

analizar_snort2.sh:  Este script procesa archivos PCAPNG en el directorio del script utilizando Snort, y genera archivos combinados con alertas. Aquí te resumo sus acciones:

Configura directorios y verifica archivos PCAPNG: Crea un directorio de resultados si no existe y verifica que haya archivos PCAPNG en el directorio.

Función process_pcap:

Ejecuta Snort para generar dos archivos de alerta: alert y snort.alert.fast.

Si ambos archivos existen, los combina extrayendo información de cada línea (como Packet ID, SID y Timestamp) y guarda el resultado en un archivo combinado.

Procesamiento de todos los archivos PCAPNG: Para cada archivo PCAPNG, llama a la función process_pcap y guarda los resultados combinados en el directorio de resultados.

Limpieza: Elimina los archivos temporales generados por Snort al finalizar el análisis de cada archivo.


analizar_logs.sh: Este script procesa archivos _combined_alerts.txt en el directorio actual y genera un archivo de resultados global. Aquí te dejo un resumen de sus pasos:

Configuración inicial: Crea o vacía el archivo de resultados global (resultados_globales.txt).

Función process_combined_file:

SIDs distintos: Extrae y cuenta los distintos SIDs en cada archivo y cuántas veces se repiten.

Número total de alertas: Cuenta el número total de alertas en el archivo.

Flujos detectados: Extrae las direcciones IP y puertos, cuenta los flujos únicos (bidireccionales), y muestra el total.

Procesamiento de archivos: El script procesa cada archivo _combined_alerts.txt en el directorio y guarda los resultados de cada uno en el archivo global.

Finalización: Una vez procesados todos los archivos, muestra un mensaje indicando que el análisis ha finalizado y guarda los resultados en resultados_globales.txt.

En resumen, el script analiza y genera estadísticas sobre SIDs, alertas y flujos a partir de los archivos _combined_alerts.txt, y guarda un informe global.



analizar_FP_legitimo.sh:  Este script calcula el porcentaje de alertas que contienen los SIDs proporcionados como argumentos, para cada archivo _combined_alerts.txt en el directorio actual. Aquí tienes un resumen de su funcionamiento:

Verificación de argumentos: El script asegura que se proporcionen al menos un SID como argumento. Si no es así, muestra un mensaje de uso y termina.

Inicialización de archivo CSV: Crea un archivo CSV llamado resultado.csv con una cabecera que incluye el nombre del archivo y el porcentaje de alertas con los SIDs.

Procesamiento de archivos:

Para cada archivo _combined_alerts.txt, lee línea por línea, cuenta el total de alertas y cuántas tienen alguno de los SIDs proporcionados.

Si se encuentra un SID que coincida con los proporcionados, incrementa el contador de alertas correspondientes.

Cálculo del porcentaje: Calcula el porcentaje de alertas con los SIDs y lo guarda en el archivo CSV.

Resultado: Al final, muestra un mensaje indicando que el análisis ha terminado y que los resultados se guardaron en el archivo resultado.csv.

analizar_fp.sh: Este script analiza un archivo de log proporcionado, buscando las alertas que contienen los SIDs especificados, y cuenta el número de líneas, flujos y paquetes únicos relacionados con esos SIDs. Aquí tienes un resumen de sus pasos:

Verificación de argumentos: Asegura que se proporcione un archivo de log y al menos un SID. Si no se cumplen los requisitos, muestra un mensaje de uso y termina.

Inicialización de variables:

lineas_total: Cuenta las líneas que contienen los SIDs especificados.

flujos_unicos: Un array asociativo que guarda flujos únicos (considerando direcciones IP y puertos).

paquetes_unicos: Un array asociativo que guarda paquetes únicos.

Lectura del archivo de log: Lee el archivo línea por línea, buscando las líneas que contienen los SIDs proporcionados:

Para cada línea que contenga un SID, incrementa el contador de líneas.

Extrae el número de paquete, direcciones IP, y puertos de origen y destino.

Asegura que los flujos (bidireccionales) sean únicos.

Cálculos:

Cuenta el número de flujos únicos.

Cuenta el número de paquetes únicos.

Resultados: Al final, muestra el número total de líneas que contienen los SIDs, flujos únicos y paquetes únicos.


Analisis_generar_csv.sh: Este script procesa archivos _combined_alerts.txt para analizar los SIDs y generar un resumen en dos archivos:

Resultados en archivo de texto:

Extrae los SIDs únicos.

Compara con una lista de SIDs predeterminada.

Cuenta alertas y SIDs no presentes en la lista.

CSV:

Guarda: nombre del archivo, SIDs distintos, total de alertas, SIDs no en la lista, y SIDs en la lista.

Salida: Resultados en resultados_globales_def.txt (texto) y resultados_globales.csv (CSV).


analisis_flujos_TP_SNORT3.sh: Este script procesa un archivo de log para contar flujos y paquetes únicos en direcciones C2S, excluyendo ciertos SIDs especificados por el usuario.

Funciones:
sid_excluido(): Verifica si un SID debe ser excluido.

Proceso:

Excluye líneas con los SIDs proporcionados.

Cuenta flujos únicos y paquetes únicos en la dirección C2S (cliente a servidor).

Muestra las instancias (líneas) procesadas sin los SIDs excluidos.

Salida:
Flujos detectados, paquetes únicos, y el número de instancias procesadas sin los SIDs excluidos


analisis_flujos_TP.sh: Este script realiza un análisis de flujos y paquetes en un archivo de log, filtrando aquellos que contienen SIDs que no deben ser procesados. Aquí te doy un resumen de cómo funciona:

Objetivo:
Procesar un archivo de log y contar flujos y paquetes que no contengan ciertos SIDs excluidos y que vayan en dirección C2S (Cliente a Servidor).

Para cada flujo C2S:

Cuenta flujos y paquetes únicos.

Excluye los SIDs proporcionados por el usuario.

Funcionamiento:
Entrada:

Archivo de log.

Lista de SIDs a excluir.

Procesamiento:

El script lee el archivo de log línea por línea.

Extrae el SID de cada línea y lo compara con los SIDs excluidos.

Si el SID no está excluido, cuenta:

Flujos únicos (C2S).

Paquetes únicos (C2S).

Líneas procesadas que no contienen SIDs excluidos y son en dirección C2S.

Salida:

Muestra los flujos únicos, paquetes únicos, y el número de instancias procesadas para cada archivo de log.


COMPROBACION FLUJOS TCP SYN Y MTU


verificar_MTU.py: Este script en Python verifica si los paquetes en archivos .pcapng superan el tamaño máximo de MTU (65521 bytes).

Funcionamiento:
Define el tamaño de MTU.

Escanea archivos .pcapng en el directorio donde está el script.

Usa pyshark para analizar cada archivo:

Si un paquete excede el tamaño de MTU, imprime un mensaje.

Si todo está bien, indica que el archivo cumple el límite.

Salida:
Informa si los archivos están dentro del límite o si hay paquetes que lo exceden.


txt_to_csv.py:  Este script en Python convierte archivos de texto filtrados a formato Excel.

Resumen:
Directorios y Archivos:

El script busca archivos con el patrón filtrado_*.txt en el directorio especificado.

Procesamiento:

Para cada archivo encontrado, extrae el nombre base del archivo (sin el prefijo filtrado_).

Lee los archivos CSV con un delimitador \t (tabulador) usando pandas.

Convierte estos archivos a formato Excel .xlsx y guarda con el nombre csv_<nombre_base>.xlsx.

Salida:

Cada archivo convertido genera un archivo Excel con el nombre adecuado.

Imprime un mensaje de confirmación tras cada conversión.


Flows_a_csv.py: Este script en Python convierte archivos .txt en archivos .csv delimitados por tabulaciones.

Resumen:
Búsqueda de Archivos:

Busca todos los archivos con el patrón *_flows.txt en el directorio actual.

Procesamiento:

Para cada archivo .txt, lo lee como un DataFrame de pandas usando un delimitador tabulador (\t).

Conversión a CSV:

Genera un archivo .csv reemplazando la extensión .txt por .csv.

Guarda el DataFrame como un archivo CSV usando un delimitador tabulador (\t).

Salida:

Imprime un mensaje de confirmación indicando que el archivo fue convertido correctamente.


checkSYN.py: Este código procesa archivos Excel que contienen flujos de red, filtra los que cumplen ciertas condiciones, verifica si el flag TCP es válido, y guarda los resultados en un archivo Excel, agregando información sobre los flujos truncados.


convertir_pcapng_a_pcapng_y_truncar_MTU: Convierte el archivo en formato pcap y trunca sus paquetes a una MTU Indicada.


FORTIGATE


get_appid_FG.sh: Este script en Bash realiza lo siguiente:

Verifica si se ha proporcionado un archivo CSV como argumento al script. Si no se proporciona, muestra un mensaje de uso y termina.

Comprueba si el archivo CSV existe. Si no existe, muestra un mensaje de error y termina.

Extrae la primera columna del archivo CSV (se asume que los datos están separados por comas y/o espacios), elimina la primera línea (cabecera) usando tail -n +2, ordena los valores de la columna de manera única y finalmente los imprime como una lista separada por comas.


generar_csv.sh: El script procesa archivos .log, extrae campos específicos de las líneas que contienen type="utm", y genera archivos .csv con los datos extraídos. Los archivos CSV se guardan en un directorio llamado csv_outputs


extraer_trafico.sh: Este script procesa archivos .log en el directorio actual, filtra las líneas que contienen srcintf="port5" y policytype="sniffer", y guarda las líneas resultantes en nuevos archivos .log en un directorio llamado traffic. Si no se encuentran coincidencias, el archivo de salida se elimina.


ataques_desagrupados.sh: Este script procesa archivos .log, extrae y desagrupa las alertas de tráfico de ataques (de tipo "utm"), y maneja casos donde hay un campo count o repeated n times. Desagrupa las alertas de acuerdo con el valor de count, duplicando las alertas según el número especificado. Los resultados se guardan en archivos .log dentro del directorio ataques_desagrupados.


analizar_ataques_FG.sh: Este script realiza las siguientes tareas sobre un archivo CSV pasado como argumento:

Extrae una lista de attackid distintos y los muestra, separados por comas.

Cuenta el número de attackid distintos y lo imprime.

Cuenta el número total de alertas, excluyendo la cabecera, y lo muestra.

El script verifica que el archivo exista y que se haya proporcionado un argumento. Si el archivo no existe, muestra un mensaje de error y termina la ejecución.


analizar_app.sh: Este script realiza las siguientes tareas sobre los archivos .log en el directorio actual:

Crea un directorio de salida llamado csv_app_ctrl si no existe, para almacenar los archivos CSV generados.

Procesa cada archivo de log, extrayendo información relevante de las líneas que contienen subtype="app-ctrl". Los campos extraídos son:

appid, sessionid, app, msg, apprisk, srcip, dstip, DeviceID

Los datos extraídos se escriben en un archivo CSV correspondiente, con una cabecera que incluye los nombres de los campos.

Genera un archivo CSV por cada archivo de log procesado, guardándolos en el directorio csv_app_ctrl.





PALO ALTO

ataques.sh: Este script realiza las siguientes tareas:

Crea un directorio llamado ataques si no existe, para almacenar los archivos filtrados con los ataques.

Inicializa un archivo CSV (flujos_ataques.csv) con encabezados que incluyen el nombre del archivo y el número de flujos identificados (basados en sessionid).

Filtra los archivos .log en el directorio actual buscando líneas que contengan log_type="THREAT", lo que indica que son registros de ataque.

Guarda los resultados filtrados en un archivo dentro del directorio ataques, nombrado según el archivo de log original.

Cuenta los flujos únicos de ataques (basado en sessionid) en el archivo filtrado y guarda ese conteo en el archivo CSV.

Muestra el número total de flujos identificados para cada archivo de log y guarda toda la información en el CSV para referencia posterior.

desagrupar.sh: Este script realiza las siguientes tareas:

Crea un directorio llamado desagrupados si no existe para almacenar los archivos de log desagrupados.

Itera sobre todos los archivos .log en el directorio actual.

Lee cada línea del archivo `.log para procesarla:

Si la línea contiene un valor repeatcnt, que indica cuántas veces debe repetirse la misma entrada, el script repite la línea ese número de veces.

Si el repeatcnt es igual a 1, simplemente guarda la línea tal como está.

Guarda el archivo desagrupado en el directorio desagrupados, con un nombre basado en el archivo original, precedido por desagrupado_.

Muestra un mensaje para cada archivo de log procesado indicando que las alertas desagrupadas se han guardado correctamente.

extraer_trafico.sh: Este script está diseñado para filtrar y procesar archivos .log que contienen datos de tráfico de red. A continuación, te explico las funciones principales y el flujo de trabajo del script:

Objetivos del script:
Filtrar tráfico específico: Busca líneas que contengan las cadenas 'inbound_iface="ethernet1/4"' y 'zone="ZONE3"'.

Generar archivos filtrados: Los archivos filtrados se guardan en el directorio filtrados.

Contar flujos: Cuenta el número de flujos identificados, basándose en el número único de sessionid que se encuentran en las líneas filtradas.

Generar un archivo CSV: Los resultados se guardan en un archivo CSV llamado resultado_flujos.csv, donde se registran el nombre del archivo log y el número de flujos identificados.

generar_csv.sh: Este script de Bash está diseñado para procesar archivos .log y extraer información específica de cada línea de log, luego generar archivos .csv con los datos extraídos. Cada archivo CSV tiene una estructura definida con los campos relevantes para los eventos de seguridad, y el directorio de salida donde se guardan los CSV generados es resultados_ataques.


OTROS

fragmentar.sh: Este script en Bash fragmenta archivos .pcapng utilizando tcprewrite y un archivo de configuración frag.cfg, generando archivos de salida con el sufijo -fragmentado.pcapng.

flujos_TCP_ICMP_UDP.sh: Este script en Bash cuenta los flujos TCP, UDP e ICMP de archivos .pcapng usando tshark, calcula el número total de flujos para cada archivo y guarda los resultados en un archivo CSV llamado resultados_flujos_totales.csv.


renombrar.sh: Este script busca archivos .pcapng en el directorio especificado y sus subdirectorios. Para cada archivo encontrado, renombra el archivo agregando _[1] antes de la extensión. Si el directorio base no existe, muestra un error. Al final, muestra un mensaje indicando que todos los archivos han sido renombrados.

Regenerar.py: Este script en Python usa la librería Scapy para modificar archivos .pcapng. Realiza lo siguiente:

Carga un archivo .pcapng y verifica si contiene tráfico TCP.

Si contiene tráfico TCP, extrae las direcciones IP, puertos y direcciones MAC del primer paquete TCP.

Regenera el handshake TCP (SYN, SYN-ACK, ACK) con las direcciones y puertos extraídos y lo inserta antes de los paquetes originales.

Guarda el nuevo archivo .pcapng con el nombre modificado, agregando _regenerado al nombre original.

El archivo resultante contiene el tráfico original con un nuevo handshake TCP al principio.

