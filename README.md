
# Trabajo de Fin de Grado Andrés Meléndez Casado
````
    __  _________________  ______   ___  _______________     ________ __    _______________
   /  |/  /  _/_  __/ __ \/ ____/  /   |/_  __/_  __( _ )   / ____/ //_/   /  _/ ____/ ___/
  / /|_/ // /  / / / /_/ / __/    / /| | / /   / / / __ \/|/ /   / ,<      / // /    \__ \ 
 / /  / // /  / / / _, _/ /___   / ___ |/ /   / / / /_/  </ /___/ /| |   _/ // /___ ___/ / 
/_/  /_/___/ /_/ /_/ |_/_____/  /_/  |_/_/   /_/  \____/\/\____/_/ |_|  /___/\____//____/  
                                                                                           
                                                                                          
`````                                                                                                                                                                   
Este estudio tiene como objetivo analizar la capacidad de detección de los sistemas IDS Snort, FortiGate y Palo Alto NFGW. Para ello, se ha implementado un banco de ataques que incluye tanto escenarios generados en este trabajo como ataques documentados en estudios previos.

El repositorio contiene todas las herramientas desarrolladas y utilizadas en la investigación. En él se pueden encontrar los archivos .log generados tras el análisis de cada captura de tráfico, así como hojas de cálculo en Excel donde se reflejan los resultados obtenidos. Además, incluye los scripts empleados para la automatización y simplificación del proceso de análisis.

Este repositorio constituye un complemento adicional al Trabajo de Fin de Grado titulado "Análisis de la capacidad de detección de los IDS Snort, FortiGate y Palo Alto NFGW en entornos ICS bajo la matriz MITRE ATT&CK".

Podemos encontrar distintos directorios:
````
BBDD -> Archivos necesarios para iniciar la BBDD. Incluye guía de puesta en marcha.
Dataset -> Banco de ataques completos. Incluye tanto los ataques implentados como los que no. Se encuentran ordenados por dataset. Para saber cuales se han implementado, consultar tabla de detecciones y memoria (Apartado Documentaion)
Documentacion -> Contiene memoria del trabajo, junto con la tabla de detecciones
Estudio-FG -> Primeros análisis con FG. 
Estudio-PA -> Primeros análisis con PA.
Resultados -> Fichero de resultados con los distintos IDS
Scripts -> Archivos para la automatización de varias tareas. Contiene herramientas para regenerar ataques, extraccion de datos a partir de ficheros log, etc.
Soporte -> Pequeño studio realizado junto con el equipo de soporte acerca de problemas de detecciones en algunos ataques.
Reglas Snort.tar.gz -> Conjuntos de reglas utilizados para el IDS Snort


