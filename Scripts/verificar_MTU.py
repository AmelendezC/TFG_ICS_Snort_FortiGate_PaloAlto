import os
import pyshark

# Define el tamaño máximo de MTU
MTU = 65521

# Directorio actual donde se encuentran los archivos pcapng
pcap_directory = os.path.dirname(os.path.abspath(__file__))

def check_mtu(pcap_file):
    try:
        # Usar un contexto para asegurar que el archivo se cierra correctamente
        with pyshark.FileCapture(pcap_file) as cap:
            for packet in cap:
                if hasattr(packet, 'length') and int(packet.length) > MTU:
                    print(f"Paquete excede MTU en {pcap_file}: Tamaño {packet.length} bytes")
                    return False
        print(f"Archivo {pcap_file} está dentro del límite de MTU.")
        return True
    except Exception as e:
        print(f"Error al analizar {pcap_file}: {e}")
        return False

# Buscar todos los archivos pcapng en el directorio actual
for filename in os.listdir(pcap_directory):
    if filename.endswith('.pcapng'):
        file_path = os.path.join(pcap_directory, filename)
        check_mtu(file_path)
