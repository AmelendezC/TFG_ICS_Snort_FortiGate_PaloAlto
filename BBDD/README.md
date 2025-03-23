En cuanto a los resultados obtenidos, se ha generado una tabla con las detecciones de cada IDS. Sin embargo, 
tras su elaboración, se han identificado algunas limitaciones. Debido al gran tamaño de las tablas, la consulta de 
datos resultaba ineficiente. Para mejorar este aspecto, se han simplificado las columnas de las tablas y los 
resultados se han transferido a una base de datos HyperSQL (HSQL). Se detallará la estructura 
adoptada para las tablas, así como la implementación de la base de datos y las consultas SQL utilizadas para 
obtener los resultados.


 ------- SECCIÓN A: FICHEROS INVOLUCRADOS -------
 
 1 - Scripts SQL
  --> Crear_Tablas.sql: Contiene la contstrucción de las Tablas
  --> Sentencias_ejemplo.sql: Contienen sentencias SQL de ejemplo. 
 2 - CSVs (Directorio "/Tablas")
  --> alertas_ataque_fortigate.csv, alertas_ataque_snort.csv, alertas_ataque_paloalto.csv 
  --> caracterizacion_pcaps_ataque.csv, caracterizacion_pcaps_legitimo.csv 
  --> deteccion_snort.csv, deteccion_fortigate.csv, deteccion_paloalto.csv
  --> alertas_legitimo_snort.csv
  --> Adicionalmente dispone de los ficheros Excel originales a partir de los cuales se extraen los CSV finales. Ocasionalmente podría experimentar errores de formato según condiciones de sistema operativo, tecnología de BBDD empleada, etc., por lo que se recomienda tener estos ficheros en caso de problema. Con el uso de los scripts puede obtener los CSV a partir de estos ficheros en formato Excel.
           
 Puede acceder a los siguientes enlaces para indagar en el funcionamiento concreto de la BBDD:
 - Puesta en Marcha y Prueba: https://youtu.be/1rHq3DemWE0
