--SENTENCIAS SQL DE EJEMPLO

--1 Extracción de las técnicas que generan un ID de alerta concreto
-- SELECT tecnica FROM alertas_ataque_X NATURAL JOIN caracterizacion_pcaps_ataque WHERE Y = ZZZ; 
SELECT ficheropcap,tecnica,sid FROM alertas_ataque_snort NATURAL JOIN caracterizacion_pcaps_ataque WHERE sid = 2002752;


--2. Extracción de las alertas totales que se generan para un ataque y RuleSet concreto (Snort): hay que tener en cuenta que el atributo “RULESET” de las alertas hace referencia al RuleSet en el que aparecen por primera vez.
-- SELECT * FROM alertas_ataque_snort WHERE ficheropcap=’YYY’ AND (RULESET=V OR RULESET=W); 
SELECT * FROM alertas_ataque_snort WHERE ficheropcap = 'T0866-RemoteAccess-VNC-FIXED_[2].pcapng' AND (ruleset = 4 OR ruleset = 5);


--3 Contador de flujos con ataque totales

SELECT 
    SUM(nflujosconataque) AS total_flujos_ataques
FROM 
    caracterizacion_pcaps_ataque;
--4 Por tactica
   
SELECT 
    tactica,
    SUM(nflujosconataque) AS total_flujos_ataques
FROM 
    caracterizacion_pcaps_ataque
GROUP BY 
    tactica
ORDER BY 
    total_flujos_ataques DESC;
   
--5. Extracción del número de técnicas detectables por red que pertenecen a una táctica concreta. 
   --SELECT COUNT(DISTINCT(tecnica)) FROM resumen WHERE detectablered=1 AND (tactica=’YYY’ OR tactica_adicional=’%YYY%’; 
SELECT COUNT(DISTINCT(tecnica)) FROM resumen WHERE detectablered=1 AND 
(tactica='Initial Access' OR tactica_adicional='LATERAL Movement'); 

--6 Flujos detectados por fortigate y palo alto por tactica
SELECT 
    cpa.tactica,
    COALESCE(SUM(COALESCE(df.nflujosconataquedetectados_total, 0)), 0) AS flujos_detectados_fortigate,
    COALESCE(SUM(COALESCE(dp.nflujosconataquedetectados_total, 0)), 0) AS flujos_detectados_paloalto
FROM 
    caracterizacion_pcaps_ataque cpa
LEFT JOIN 
    detecciones_fortigate df
    ON cpa.ficheropcap = df.ficheropcap
LEFT JOIN 
    detecciones_paloalto dp
    ON cpa.ficheropcap = dp.ficheropcap
GROUP BY 
    cpa.tactica
ORDER BY 
    cpa.tactica;
   
   
--7 Contar en cuantos ataques ha saltado el sid FP 2002752
SELECT 
    COUNT(*) AS cantidad_ataques
FROM 
    alertas_ataque_snort
WHERE 
    sid = 2002752
    AND ruleset = 4;

SELECT 
    t.tactica,
    COUNT(*) AS cantidad_ataques
FROM 
    alertas_ataque_snort AS a
JOIN 
    caracterizacion_pcaps_ataque AS t
    ON a.ficheropcap = t.ficheropcap
WHERE 
    a.sid = 2002752
    AND a.ruleset = 4
GROUP BY 
    t.tactica;






