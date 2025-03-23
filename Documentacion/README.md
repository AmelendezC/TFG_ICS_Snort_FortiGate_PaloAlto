````
 _____ ___  ______ _       ___     ______ _____    ______ _____ _____ _____ _____  _____ _____ _____ _   _  _____ _____ 
|_   _/ _ \ | ___ \ |     / _ \    |  _  \  ___|   |  _  \  ___|_   _|  ___/  __ \/  __ \_   _|  _  | \ | ||  ___/  ___|
  | |/ /_\ \| |_/ / |    / /_\ \   | | | | |__     | | | | |__   | | | |__ | /  \/| /  \/ | | | | | |  \| || |__ \ `--. 
  | ||  _  || ___ \ |    |  _  |   | | | |  __|    | | | |  __|  | | |  __|| |    | |     | | | | | | . ` ||  __| `--. \
  | || | | || |_/ / |____| | | |   | |/ /| |___    | |/ /| |___  | | | |___| \__/\| \__/\_| |_\ \_/ / |\  || |___/\__/ /
  \_/\_| |_/\____/\_____/\_| |_/   |___/ \____/    |___/ \____/  \_/ \____/ \____/ \____/\___/ \___/\_| \_/\____/\____/ 
                                                                                                                        
````

````
 ------------ SECCIÓN A.1: VISTA GENERAL HOJA DETECCIONES ------------
 
 Esta hoja concentra numerosos aspectos relacionados con el estudio, divididos en pestañas:
  -> (A.1) - Reglas Usadas: pestaña con un registro de versiones y agrupación de los paquetes de reglas, así como las versiones de los IDS.
  -> (A.2) - Configuración de FG / PA: pestaña con detalles de configuración que puedan afectar a las detecciones, e.g. umbrales de Denegación de Servicio y Fuerza Bruta. Viene acompañada de indicaciones.
  -> (B) -Detección_Ataques->SIDs : esta pestaña contiene dos aspectos de los ataques implementados.
                           --> Caracterización de pcaps: información variada acerca del ataque implementado, sin relación con los IDS
                           --> Resultados de Detecciones: resultados devueltos por los distintos IDS para cada uno de los ataques
  -> (C) - Detecciones - Tráfico Legítimo: similar a la pestaña (B), pero aplicada a las capturas de tráfico legítimo
  -> (D.0) - Análisis de Muestra: Esta hoja contiene información sobre la distribución de los ataques utilizados por táctica/técnica, así como el numero de ataques que se utilizan para los distintos análisis planteados.
  -> (D.1) - Análisis Resultados I - Snort: gráficas y análisis de resultados relativos al IDS Snort. Es posible encontrar información extraída de otras pestañas de esta misma hoja
  -> (D.2) - Análisis Resultados II - FortiGate: gráficas y análisis de resultados relativos al IDS FortiGate. Es posible encontrar información extraída de otras pestañas de esta misma hoja
  -> (D.3) - Análisis Resultados III - PaloAlto: gráficas y análisis de resultados relativos al IDS PaloAlto. Es posible encontrar información extraída de otras pestañas de esta misma hoja
  -> (D.4) - Análisis Resultados IV - Conjunto: gráficas y análisis de resultados relativos a todos los IDS. Es posible encontrar información extraída de otras pestañas de esta misma hoja
   -> (E) - Referencias: esta pestaña contiene un breve anexo con la leyenda de la procedencia de los pcaps. En la pestaña (B) existen varias columnas relacionadas con la caracterización de los pcaps con referencias como valores. Estas referencias se encuentran detalladas en esta pestaña



 ------------ SECCIÓN A.2: COLUMNAS PESTAÑA (B) HOJA DETECCIONES --------
 
 Para entender los datos insertados en la pestaña de ataques de la hoja de detecciones, se adjunta una lista de las columnas con su definición.

Táctica -> Nombre de la Táctica a la que pertenece el ataque
IDTáctica -> Identificador de la Táctica MITRE a la que pertenece al ataque
Técnica ->técnica a la que pertenece el ataque
ID Técnica -> ID de la técnica a la que pertenece el ataque
Subtécnica -> subtécnica a la que pertenece el ataque (puede no tener subtécnica asociada)
ID Subtécnica ->  ID de la subtécnica a la que pertenece el ataque (puede no tener subtécnica asociada)
Otras tácticas aplicables ->Otras táctica a las que puede pertenecer el ataque
Ataque -> Resumen breve del ataque
Software Simulación Víctima -> Software o herramienta utlizada en el equipo víctima para llevar a cabo el ataque
Disponibilidad -> Sistema operativo en el que está disponible el ataque. También indica si existe version de prueba para dicha herramienta
Software Atacante ->  Software o herramienta utlizada en el equipo atacante para llevar a cabo el ataque
Disponibilidad -> Sistema operativo en el que está disponible el ataque. También indica si existe version de prueba para dicha herramienta
Protocolo Base de Ataque -> Protocolo en el que se basa el ataque
Procedimiento -> Enlace en el que se indicael procedimiento seguido, o enlace a herramientas usadas para el ataque
Fichero pcap -> Nombre del fichero en formato pcap
Ataques Complementarios -> Descripción breve de ataques colaterales que se hayan realizado o que estén presentes
Proceso de Generación [n]/apartado -> Indica la ubicación en los documentos refereciados del procedimiento seguido para generar eñ tráfico de ataque
Validación Contenido del pcap en el Anexo B de [2] ->  Indica la ubicación en los documentos refereciados acerca de cuáles son los paquetes maliciosos generados en cada ataque
Análisis de detecciones del pcap [n]/apartado -> Indica el proceso de análisis para cada ataque. Puede estar en múltiples ubicaciones dentro de un documento o distintos documentos.
Mediante Patrones -> Indica si el ataque es detectable por patrones
Mecanismo de deteccion -> Descripción del procedimiento o regla que se podría elaborar para detectar el ataque
Detalles Implementacion del Ataque -> Indica si se ha implementado los mecanismos de deteccion anteriores para detectar el ataque
Usado para cálculo capacidad de detección por patrones -> Indica si el ataque ha sido utilizado para realizar los análisis de detecciones. Pueden existir ataque sque no se hayan utilizado debido a que no cumplen los requisitos establecidos
Fichero Formato PCAPNG Truncado MTU (Verificado) -> Nombre del archivo en formato pcapng. Además indicará si el paquete ha sido truncado en MTU
Detección Correccion SYN -> Indica si existen flujos TCP incompletos e indicará si ha sido resuelto
Error TCP Replay -> Indica errores que hayan surgido durante el comando TCPREPLAY
DETECTABILIDAD -> SI o NO dependiento de si el ataque puede ser detectado por un IDS
NIVEL DE ATAQUE (Contexto del ataque) -> LV1 o LV2 dependiendo de si se trata de un ataque independientemente del entorno en el que nos encontremos. O si es un ataque dependiente del contexto
JUSTIFICACION NIVEL DE ATAQUE -> Razonamiento que justifica el nivel de ataque establecido según el contexto.
NIVEL DE ATAQUE (Modelo OSI) -> L2 si se trata de un ataque de capa 2 del modelo OSI. O si se trata de un ataque de capa 3
CONTIENE PAQUETES CON TAMAÑO > 4000 BYTES (Necesita fragmentación) ->Indica si el ataque contiene paquetes mayores de 4000 bytes. Por lo tanto, el ataque necesitara ser fragmentado a través de fragroute
ARHIVO PCAP FRAGMENTADO -> Nombre del nuevo archivo pcapng con los paquetes fragmentados
Nº TOTAL DE FLUJOS: número total de flujos en el fichero pcap. Calculado haciendo uso de la herramienta tranalyzer, descartando aquellos flujos que no tienen una Cabecera asociada (descartando así la mayoría de flujos de capa <L3)
Nº DE FLUJOS CON ATAQUE/S: número de flujos que contienen paquetes vinculados al ataque implementado
 Nº DE FLUJOS CON ATAQUE/S COLATERALES: número total de flujos que contienen ataques colaterales
Nº DE MENSAJES DE RED CON ATAQUE/S: número de mensajes/paquetes que contienen al ataque implementado o parte de él.
Nº DE ATAQUES (INSTANCIAS) TOTALES: número total de instancias de ataque principales y colaterales. Una instancia es la unidad mínima de un ataque, pudiéndose tratar, por ejemplo, de un comando, una inyección SQL o un escaneo a un puerto concreto
Nº DE ATAQUES (INSTANCIAS) PRINCIPALES: número de instancias de ataque en la captura de paquetes
 Nº DE ATAQUES (INSTANCIAS) COLATERALES: número de instancias en la captura de paquetes que constituyen amenaza y pueden generar alertas pero no están relacionadas con el propio ataque en sí.
SIDs (sin repetición) -> SIDS que han salido en cada ataque
#SIDs -> Nº de SIDS detectados en elataque
Número total de alertas -> Numero total de alertas generado para cada ataque
SIDs en legítimo y ataque-> SIDS que han salido en el ataque, que han salido también el tráfico legítimo
SIDs sólo en ataque - SIDs TP ( Automático) -> Lista de SIDS que son TP en función de los SIDS que salen el el tráfico legítimo
#SIDs TP (Automático) -> Nº de SIDS tras la deteccion de TPs automaticos
Nº total de alertas TP (Automático) -> Nº de alertas TP en función de las alertas que aparecen en el tráfico legítimo
SIDs FP (Manual) -> Análisis manual que comprueba qué SIDS no están relacionados con el ataque. Es decir, son falsos positivos
SIDs FP (Automático) -> SIDs que aparecen en tráfico legítimo y que se usan para la metodología automática para calificar los SIDs del ataque como FP
SIDs FP -> Lista de SIDS que, comprobados automáticamente y manualmente, son falsos positivos
SIDs FP "No Relacionados" -> Lista de SIDS que pertenecen a ataques que no estan relacionados con el ataque principal
SIDs FP "Eventos de Red" -> Lista de SIDS que están asociados con actividades haituales en la red
SIDs TP "Todas las Alertas" (Manual) -> Lista comprobada manualmente de los SIDS que son TP
SIDs TP "Algunas Alertas" (Manual)-> SIDs que manualmente se ha comprobado que en ocasiones son TP y en otras FP
#SIDs TP (Manual) -> nº de SIDs diferentes que han sido calificados como TP para el método manual de identificación de alertas
Nº total de alertas TP (Manual) -> nº total de alertas TP generadas, atendiendo al procedimiento manual de identificación de alertas
Nº TOTAL DE FLUJOS DETECTADOS SNORTv3 -> número de flujos totales analizados por Snortv3
Nº TOTAL DE FLUJOS CON ATAQUE/S DETECTADOS Talos+ETopen Script -> Nº de flujos distintos detectados por TALOS Y ETOPEN siguiendo un procedimiento automatico
Nº DE MENSAJES DE RED CON ATAQUE/S TOTALES DETECTADOS (script) (talos+etopen) ->  Nº de mensajes distintos detectados por TALOS Y ETOPEN siguiendo un procedimiento automatico
Nº ATAQUES (INSTANCIAS) DETECTADOS POR TALOS (Community + registered) ->  número de instancias de ataque totales detectadas por el paquete de reglas de Talos respectivo
Nº ATAQUES (INSTANCIAS) DETECTADOS POR ETOPEN -> número de instancias de ataque totales detectadas por el paquete de reglas de ETOpen respectivo
Nº ATAQUES (INSTANCIAS) TOTALES DETECTADOS (Manual) -> Nº de instancias que se han detectado que so TP, Para este procedimiento, hay que tener en cuenta que un paquete uede generar multiples alertas. Por lo que se comprueba manualmente que varias alertas estan vinculadas a una instancias 
Nº TOTAL DE FLUJOS CON ATAQUE/S TP DETECTADOS (Manual) -> número de flujos con ataques manualmente calificados como TP detectados por el RuleSet
Nº TOTAL DE FLUJOS CON ATAQUE/S COLATERAL TP DETECTADOS (Manual) -> número de flujos con ataques manualmente calificados como TP detectados por el RuleSet
Nº DE MENSAJES DE RED CON ATAQUE/S TP DETECTADOS (Manual) -> número de mensajes de red con ataques manualmente calificados como TP detectados por el RuleSet
Nº ATAQUES (INSTANCIAS) TP DETECTADOS (Manual) ->  número de instancias de ataques TP filtrados manualmente detectadas entre número de instancias de ataques de la captura
Nº TOTAL DE FLUJOS CON ATAQUE/S TP DETECTADOS (Automático) -> número de flujos con ataques TP filtrados automáticamente detectados entre número de flujos con ataques de la captura
Nº DE MENSAJES DE RED CON ATAQUE/S TP DETECTADOS (Automático) -> número de mensajes con ataques automáticamente calificados como TP detectados por el RuleSet. Para el cálculo, se discriminan todas aquellas alertas cuyo SID se encuentre también en los SIDs de tráfico legítimo
Nº ATAQUES (INSTANCIAS) TP DETECTADOS POR TALOS (Automático) -> número de instancias de ataques automáticamente calificadas como TP detectadas por el paquete de reglas Talos respectivo. Para el cálculo, se discriminan todas aquellas alertas cuyo SID se encuentre también en los SIDs de tráfico legítimo
Nº ATAQUES (INSTANCIAS) TP DETECTADOS POR ETOPEN (Automático) -> número de instancias de ataques automáticamente calificadas como TP detectadas por el paquete de reglas ETOpen respectivo. Para el cálculo, se discriminan todas aquellas alertas cuyo SID se encuentre también en los SIDs de tráfico legítimo
Nº ATAQUES (INSTANCIAS) TP TOTALES DETECTADOS (Automático + Manual) ->  número de instancias de ataques automáticamente calificadas como TP detectadas en total. Para el cálculo, se discriminan todas aquellas alertas cuyo SID se encuentre también en los SIDs de tráfico legítimo así como se realiza una puesta en conjunto manual para asociar las alertas de cada paquete de reglas a una instancia.
% DETECCIÓN FLUJOS TP (Automático): para cada RS, número de flujos con ataques TP filtrados automáticamente detectados entre número de flujos con ataques de la captura
% DETECCIÓN FLUJOS TP (Manual): para cada RS, número de flujos con ataques TP filtrados manualmente detectados entre número de flujos con ataques de la captura
 % DETECCIÓN MENSAJES: para cada RS, número de mensajes con ataques detectados entre número de mensajes con ataques de la captura
% DETECCIÓN MENSAJES TP (Automático): para cada RS, número de mensajes con ataques TP filtrados automáticamente detectados entre número de mensajes con ataques de la captura
% DETECCIÓN MENSAJES TP (Manual): para cada RS, número de mensajes con ataques TP filtrados manualmente detectados entre número de mensajes con ataques de la captura
% DETECCIÓN INSTANCIAS: para el RS1, número de instancias de ataques detectadas entre número de instancias de ataques de la captura
% DETECCIÓN INSTANCIAS TP (Automático): para el RS1, número de instancias de ataques TP filtrados automáticamente detectas entre número de instancias de ataques de la captura
% DETECCIÓN INSTANCIAS (Manual): número de instancias de ataques detectadas calculadas manualmente entre número de instancias de ataques en la captura
% DETECCIÓN INSTANCIAS (Automático + Manual): número de instancias de ataques TP filtrados automáticamente y calculados manualmente entre número de instancias de ataques de la captura
% DETECCIÓN INSTANCIAS TP (Manual): para cada RS, número de instancias de ataques TP filtrados manualmente detectadas entre número de instancias de ataques de la captura
% DETECCIÓN EFICAZ FLUJOS (Manual): para cada RS, porcentaje de detección eficaz de flujos. Esto es el número de flujos detectados, ya sean principales o colaterales
% DETECCIÓN EFICAZ ATAQUES (Manual): para cada RS, porcentaje de detección del ataque. Esta celda valdrá 100% si el ataque contiene al menos una alerta válida (TP o colateral) o 0% en caso contrario
APPID (sin repetición) Appcontrol -> Lista de APPIDs qe aparecen en el fichero log y tienen relación con el ataque realziado
#APPID (Appcontrol) -> Número de APPIDs distintos 
Numero total de alertas Appcontrol -> Nº de alertas que han saltado en elAppcontrol
Attackids (sin repetición) (FIRMAS IPS) -> lista de Ids detectadas por el motor IPS
#Attackid (IPS) -> Numero de Attackids distintos que han saltado en el fichero log de cada ataque
Número total de alertas (IPS) -> Núnero de alertas que han saltado en el motor IPS
SIDs FP Dataset_Legítimo -> número de Attackids que aparecen tanto en la captura del ataque como en el dataset legitimo XX
#SIDs FP Dataset_Legítimo -> número de threat_ids que aparecen tanto en la captura del ataque como en el dataset legitimo XX
SIDs FP Totales -> Conjunto de Attackids que han sido identificados manualmente como FP
#SIDs FP Totales -> Número de attackids que son FP
Nº FLUJOS IDENTIFICADOS POR X -> número de sessionids diferentes que aparecen en el log generado para un ataque. Este parámetro sirve para identificar el número total de flujos detectados por X. Siendo X = PaloAlto o Fortigate
Nº FLUJOS DETECTADOS POR MOTOR IPS -> Número de SessionID distintos que ha identificado el motor IPS
Nº FLUJOS DETECTADOS  L2(APPLICATION CONTROL) -> Número de SessionID Distintos que ha detectado el motor de aplicaciones
Nº TOTAL DE FLUJOS con ataques (IPS+APPCTRL) -> Nº Total de flujos detectados en conjunto, teniendo en cuenta que un mismo SessionID puede aparecer en ambos módulos. 
% DETECCIÓN X (IPS) -> Porcentaje de detección de X únicamente teniendo en cuenta el motor IPS. Siendo X = PaloAlto o Fortigate
% DETECCIÓN X (IPS+APPCRTL) -> Porcentaje de detección de X teniendo en cuenta tanto el módulo de aplicación y el motor IPS. Con esta columna se hallaría el % de deteccion real de todo el dispositivo
% DETECION APP CTRL -> Porcentaje de deteccion teniendo en cuenta únicamente el motor de aplicaciones
COMENTARIOS y Aclaraciones -> Aclaraciones o descripciones acerca de la deteccion del ataque


------------ SECCIÓN A.3: COLUMNAS PESTAÑA (C) HOJA DETECCIONES ------------

Para entender la estructura de la pestaña dedicada al tráfico legítimo se explican las columnas que intervienen en ella

 -> Fichero pcap: nombre del fichero pcap correspondiente a la captura de tráfico legítimo
 -> Tipo de tráfico: clasifica la captura de tráfico (por lo general será REAL)
 -> Tamaño real del tráfico: tamaño del fichero PCAP
 -> Nº de flujos: número de flujos totales calculados con la herramienta tranalyzer del fichero PCAP
 -> Nº de Direcciones Distintas: nº de direcciones IP distintas que aparecen en la captura de paquetes
 -> SIDs en Tráfico Legítimo (RS1, RS2, RS3, RS4, FortiGate, PaloAlto): SIDs que ha generado el IDS correspondiente (para el RuleSet correspondiente en caso de Snort) para la detección del fichero PCAP
 -> #SIDs en Tráfico Legítimo (RS1, RS2, RS3, RS4, FortiGate, PaloAlto): Nº SIDs que ha generado el IDS correspondiente (para el RuleSet correspondiente en caso de Snort) para la detección del fichero PCAP
 -> Total number of alerts -> Nº total de alertas que aparecen por cada RS
````


