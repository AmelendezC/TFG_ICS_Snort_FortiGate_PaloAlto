import pandas as pd
import os

# Directorio donde están los archivos CSV generados
dir_path = "./"

# Archivo de salida para guardar los resultados
output_file = os.path.join(dir_path, "flowInd_summary.csv")

# Crear una lista para almacenar los resultados
results = []

# Recorrer todos los archivos CSV en el directorio
for file_name in os.listdir(dir_path):
    if file_name.endswith(".csv"):
        # Leer el archivo CSV en un DataFrame
        file_path = os.path.join(dir_path, file_name)
        try:
            df = pd.read_csv(file_path, delimiter='\t')

            # Verificar si la columna 'flowInd' existe
            if 'flowInd' in df.columns:
                # Contar los flowInd distintos
                unique_flowInd_count = df['flowInd'].nunique()
            else:
                print(f"Error: La columna 'flowInd' no se encuentra en {file_name}. Las columnas disponibles son: {df.columns.tolist()}")
                continue

            # Obtener el nombre del pcap original quitando la extensión '_flows.txt.csv'
            pcap_name = file_name.replace('_flows.txt.csv', '')

            # Almacenar el resultado
            results.append({
                "nombredelpcap": pcap_name,
                "nº de flujos": unique_flowInd_count
            })
        
        except Exception as e:
            print(f"Error al procesar {file_name}: {e}")

# Crear un DataFrame con los resultados
results_df = pd.DataFrame(results)

# Guardar el DataFrame en un archivo CSV
results_df.to_csv(output_file, index=False)

print(f"Resumen de flowInd únicos guardado en {output_file}")

