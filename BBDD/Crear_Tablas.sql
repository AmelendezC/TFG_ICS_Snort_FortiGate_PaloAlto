DROP TABLE IF EXISTS alertas_ataque_snort;
DROP TABLE IF EXISTS alertas_app_fortigate;
DROP TABLE IF EXISTS alertas_app_paloalto;
DROP TABLE IF EXISTS alertas_ataque_paloalto;
DROP TABLE IF EXISTS alertas_ataque_fortigate;
DROP TABLE IF EXISTS alertas_ataque_legitimo;
DROP TABLE IF EXISTS detecciones_fortigate;
DROP TABLE IF EXISTS detecciones_paloalto;
DROP TABLE IF EXISTS detecciones_snort;
DROP TABLE IF EXISTS caracterizacion_pcaps_legitimo;
DROP TABLE if exists caracterizacion_pcaps_ataque;
DROP TABLE if exists resumen;

--RESUMEN TABLA MAPEOS

CREATE TABLE resumen (
tactica varchar(1000),
tecnica varchar(1000),
idtecnica varchar(1000),
tactica_adicional varchar(1000),
tecnicaimplementada INTEGER,
detectablered INTEGER,
solodetectablered INTEGER,
detectableporpatrones varchar(10),
mecanismodeteccion varchar(1000),
PRIMARY KEY (tactica,tecnica)
);

--CARACTERIZACION DE ARCHIVOS PCAP

CREATE TABLE caracterizacion_pcaps_ataque (
    tactica VARCHAR(1000),
    idtactica VARCHAR(1000),
    tecnica VARCHAR(1000),
    idtecnica VARCHAR(1000),
    otratacticaaplicable VARCHAR(1000),
    ataque VARCHAR(1000),
    herramientav VARCHAR(1000),
    herramientaa VARCHAR(1000),
    protocolo VARCHAR(1000),
    ficheropcap VARCHAR(1000) PRIMARY KEY,
    ataquecolateral VARCHAR(1000),
    procesogeneracion VARCHAR(1000),
    validacionpcap VARCHAR(1000),
    analisisdeteccionespcap VARCHAR(1000),
    detectablepatrones VARCHAR(1000),
    mecanismodeteccion VARCHAR(1000),
    detallesimplementacionataque VARCHAR(1000),
    usadoparadetecciones VARCHAR(1000),
    ficheropcaptruncado VARCHAR(1000),
    deteccioncorreccionsyn VARCHAR(1000),
    error_tcp_replay VARCHAR(1000),
    Detectabilidad VARCHAR(1000),
    nivel_ataque_contexto VARCHAR(1000),
    justificacion_nivel_ataque_contexto VARCHAR(1000),
    nivel_ataque_osi VARCHAR(1000),
    tramas_4000 VARCHAR(1000),
    usado_analisis_nivel_flujos VARCHAR(10),
    nflujos INTEGER,
    nflujosconataque INTEGER,
    nmensajesconataque INTEGER,
    ninstanciastotales INTEGER,
    ninstanciasprincipales INTEGER,
    ninstanciascolaterales INTEGER
);

CREATE TABLE caracterizacion_pcaps_legitimo (
    ficheropcap  VARCHAR(1000) PRIMARY KEY,
    tipotrafico  VARCHAR(1000),
    fecha_generacion VARCHAR(1000),
    duracion_captura VARCHAR(1000),
    tamanoreal_Mb  VARCHAR(1000),
    nflujos INTEGER,
    ndirecciones  INTEGER
);

--ALERTAS CON LOS IDS

CREATE TABLE alertas_ataque_snort(
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap),
    sid  INTEGER,
    ruleset  INTEGER,
    TP_manual INTEGER,
    TP_automatico INTEGER
);

CREATE TABLE alertas_app_fortigate(
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap),
    appid INTEGER
);

CREATE TABLE alertas_app_paloalto(
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap),
    appid VARCHAR(1000)
);

CREATE TABLE alertas_ataque_paloalto (
   ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap),
    attackid INTEGER,
    TP_manual INTEGER
);

CREATE TABLE alertas_ataque_fortigate (
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap),
    attackid INTEGER,
    TP_manual INTEGER
);

CREATE TABLE alertas_ataque_legitimo (
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_legitimo(ficheropcap),
    sid INTEGER,
    ruleset INTEGER,
);

--DETECCIONES A NIVEL DE FLUJOS


CREATE TABLE detecciones_fortigate (
   ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap), 
    nflujosidentificados INTEGER, 
    nflujosconataquedetectados_ips INTEGER, 
    nflujosconataquedetectados_app_control INTEGER, 
    nflujosconataquedetectados_total INTEGER, 
    comentariosdetecciones varchar(4000)
 
);

CREATE TABLE detecciones_paloalto (
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap), 
    nflujosidentificados INTEGER, 
    nflujosconataquedetectados_ips INTEGER, 
    nflujosconataquedetectados_app_control INTEGER, 
    nflujosconataquedetectados_total INTEGER, 
    comentariosdetecciones varchar(4000)
 
);

CREATE TABLE detecciones_snort (
    ficheropcap varchar(1000) REFERENCES caracterizacion_pcaps_ataque(ficheropcap) ,
    n_flujos_detectados_snortv3 INTEGER,
    n_flujos_detectados_snortv2 INTEGER,
    n_flujos_ataques_totales_script1 INTEGER,
    n_mensajes_red_ataques_totales_script1 INTEGER,
    n_ataques_instancias_totales_script1 INTEGER,
    n_flujos_ataques_tp_manual1 INTEGER,
    n_mensajes_red_ataques_tp_manual1 INTEGER,
    n_ataques_instancias_tp_manual1 INTEGER,
    n_flujos_ataques_tp_automatico1 INTEGER,
    n_mensajes_red_ataques_tp_automatico1 INTEGER,
    n_ataques_instancias_tp_automatico1 INTEGER,
    n_total_alertas1 INTEGER,
    n_alertas_tp_manual1 INTEGER,
    n_flujos_ataques_talos_etopen_script2 INTEGER,
    n_mensajes_red_ataques_totales_script_talos_etopen2 INTEGER,
    n_ataques_instancias_talos2 INTEGER,
    n_ataques_instancias_etopen2 INTEGER,
    n_ataques_instancias_totales_manual2 INTEGER,
    n_flujos_ataques_tp_manual_rs2_2 INTEGER,
    n_mensajes_red_ataques_tp_manual2 INTEGER,
    n_ataques_instancias_tp_manual2 INTEGER,
    n_flujos_ataques_tp_automatico2 INTEGER,
    n_mensajes_red_ataques_tp_automatico2 INTEGER,
    n_ataques_instancias_tp_talos_automatico2 INTEGER,
    n_ataques_instancias_tp_etopen_automatico2 INTEGER,
    n_ataques_instancias_tp_totales_automatico_manual2 INTEGER,
    n_total_alertas2 INTEGER,
    n_alertas_tp_manual2 INTEGER,
    n_flujos_ataques_talos_etopen_script3 INTEGER,
    n_mensajes_red_ataques_totales_script_talos_etopen3 INTEGER,
    n_ataques_instancias_talos_community_registered3 INTEGER,
    n_ataques_instancias_etopen3 INTEGER,
    n_ataques_instancias_totales_manual3 INTEGER,
    n_flujos_ataques_tp_manual3 INTEGER,
    n_mensajes_red_ataques_tp_manual3 INTEGER,
    n_ataques_instancias_tp_manual3 INTEGER,
    n_flujos_ataques_tp_automatico3 INTEGER,
    n_mensajes_red_ataques_tp_automatico3 INTEGER,
    n_ataques_instancias_tp_talos_automatico3 INTEGER,
    n_ataques_instancias_tp_etopen_automatico3 INTEGER,
    n_ataques_instancias_tp_totales_automatico_manual3 INTEGER,
    n_total_alertas3 INTEGER,
    n_alertas_tp_manual3 INTEGER,
    n_flujos_ataques_talos_etopen_script4 INTEGER,
    n_mensajes_red_ataques_totales_script_talos_etopen4 INTEGER,
    n_ataques_instancias_talos_community_registered4 INTEGER,
    n_ataques_instancias_etopen4 INTEGER,
    n_ataques_instancias_totales_manual4 INTEGER,
    n_flujos_ataques_tp_manual4 INTEGER,
    n_mensajes_red_ataques_tp_manual4 INTEGER,
    n_ataques_instancias_tp_manual4 INTEGER,
    n_flujos_ataques_tp_automatico4 INTEGER,
    n_mensajes_red_ataques_tp_automatico4 INTEGER,
    n_ataques_instancias_tp_talos_automatico4 INTEGER,
    n_ataques_instancias_tp_etopen_automatico4 INTEGER,
    n_ataques_instancias_tp_totales_automatico_manual4 INTEGER,
    n_total_alertas4 INTEGER,
    n_alertas_tp_manual4 INTEGER,
    n_flujos_ataques_totales_script5 INTEGER,
    n_mensajes_red_ataques_totales_script5 INTEGER,
    n_ataques_instancias_totales_script5 INTEGER,
    n_flujos_ataques_tp_manual5 INTEGER,
    n_mensajes_red_ataques_tp_manual5 INTEGER,
    n_ataques_instancias_tp_manual5 INTEGER,
    n_flujos_ataques_tp_automatico5 INTEGER,
    n_mensajes_red_ataques_tp_automatico5 INTEGER,
    n_ataques_instancias_tp_automatico5 INTEGER,
    n_total_alertas5 INTEGER,
    n_alertas_tp_manual5 INTEGER,
    aclaraciones_detecciones_snort VARCHAR(1000)
);

--SHUTDOWN;



