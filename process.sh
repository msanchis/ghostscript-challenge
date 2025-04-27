#!/bin/bash

# Verifica si se proporcionó un nombre de archivo PDF como argumento
if [ -z "$1" ]; then
  echo "Error: Debes proporcionar la ruta al archivo PDF como argumento."
  echo "Uso: ./process.sh <archivo_entrada.pdf> [archivo_salida.jpg]"
  exit 1
fi

INPUT_PDF="$1"
# Define el nombre del archivo de salida. Si no se proporciona el segundo argumento,
# usa el nombre del PDF cambiando la extensión a _thumb.png
OUTPUT_THUMBNAIL="${2:-${INPUT_PDF%.pdf}_thumb.png}"
RESOLUTION=150 # Resolución en DPI para la miniatura (ajusta según necesites)

echo "Procesando PDF: $INPUT_PDF"
echo "Generando miniatura: $OUTPUT_THUMBNAIL"

# Comprueba si el archivo de entrada existe
if [ ! -f "$INPUT_PDF" ]; then
    echo "Error: El archivo de entrada '$INPUT_PDF' no existe."
    exit 1
fi

# Comando de Ghostscript para generar una miniatura PNG de la primera página
gs \
  -dBATCH \
  -dNOPAUSE \
  -sDEVICE=png16m \
  -sOutputFile="$OUTPUT_THUMBNAIL" \
  "$INPUT_PDF" 

# Verifica si Ghostscript se ejecutó correctamente
if [ $? -eq 0 ]; then
  echo "Miniatura generada exitosamente: $OUTPUT_THUMBNAIL"
  # Opcional: Puedes añadir aquí comandos de netcat si necesitas enviar la miniatura a algún lugar
  # Ejemplo: nc <host> <puerto> < "$OUTPUT_THUMBNAIL"
else
  echo "Error al generar la miniatura con Ghostscript."
  exit 1
fi

exit 0
