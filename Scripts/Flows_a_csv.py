import pandas as pd
import glob
import os

# Directorio actual (donde está el script y los archivos .txt)
directorio = '.'

# Buscar todos los archivos _flowx.txt en el directorio actual
archivos_txt = glob.glob(os.path.join(directorio, '*_flows.txt'))



for archivo_txt in archivos_txt:
    # Leer el archivo .txt (ajusta el delimitador según sea necesario)
    df = pd.read_csv(archivo_txt, delimiter='\t')

    # Generar el nombre del archivo CSV
    archivo_csv = archivo_txt.replace('.txt', '.csv')

    # Guardar el DataFrame como un archivo CSV delimitado por tabulación
    df.to_csv(archivo_csv, sep='\t', index=False)

    print(f"Archivo convertido: {archivo_csv}")

