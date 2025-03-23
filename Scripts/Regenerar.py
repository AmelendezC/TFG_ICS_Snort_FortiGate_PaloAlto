import sys
from scapy.all import *

def modificar_pcap(pcap_filename):
    try:
        # Cargar el archivo PCAPNG original
        pcap_original = list(rdpcap(pcap_filename))  # Convertir a lista para concatenar

        # Verificar que el archivo contenga tráfico TCP
        primer_paquete = next((p for p in pcap_original if p.haslayer(IP) and p.haslayer(TCP)), None)
        if not primer_paquete:
            print("[ERROR] No se encontraron paquetes TCP en el archivo.")
            return

        # Extraer IPs, puertos y direcciones MAC si están disponibles
        ip_src = primer_paquete[IP].src
        ip_dst = primer_paquete[IP].dst
        sport = primer_paquete[TCP].sport
        dport = primer_paquete[TCP].dport

        mac_src = primer_paquete[Ether].src if primer_paquete.haslayer(Ether) else "00:11:22:33:44:55"
        mac_dst = primer_paquete[Ether].dst if primer_paquete.haslayer(Ether) else "66:77:88:99:AA:BB"

        # Crear los paquetes con capa Ethernet
        syn = Ether(src=mac_src, dst=mac_dst) / IP(src=ip_src, dst=ip_dst) / TCP(sport=sport, dport=dport, flags="S", seq=1000)
        synack = Ether(src=mac_dst, dst=mac_src) / IP(src=ip_dst, dst=ip_src) / TCP(sport=dport, dport=sport, flags="SA", seq=2000, ack=1001)
        ack = Ether(src=mac_src, dst=mac_dst) / IP(src=ip_src, dst=ip_dst) / TCP(sport=sport, dport=dport, flags="A", seq=1001, ack=2001)

        # Insertar el handshake antes de los paquetes originales
        nuevo_pcap = [syn, synack, ack] + pcap_original

        # Generar el nuevo nombre del archivo con _regenerado
        nuevo_nombre = pcap_filename.replace(".pcapng", "_regenerado.pcapng")

        # Guardar el nuevo PCAPNG
        wrpcap(nuevo_nombre, nuevo_pcap)
        print(f"[✔] Archivo modificado guardado como: {nuevo_nombre}")

    except Exception as e:
        print(f"[ERROR] No se pudo procesar el archivo: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python3 Regenerar.py archivo.pcapng")
    else:
        modificar_pcap(sys.argv[1])
