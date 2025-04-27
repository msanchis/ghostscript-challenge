# Usa la imagen base de Ubuntu 14.04 (Trusty Tahr)
FROM ubuntu:14.04

# Actualiza la lista de paquetes e instala ghostscript y netcat
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ghostscript \
        netcat-traditional \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Establece un directorio de trabajo dentro del contenedor
# WORKDIR /app

# Copia el script de procesamiento al directorio de trabajo
COPY process.sh .

# Asegúrate de que el script tenga permisos de ejecución
RUN chmod +x ./process.sh

# Define el script como el punto de entrada principal del contenedor.
# ¡Descomenta esta línea! Usa la ruta relativa al WORKDIR.
ENTRYPOINT ["./process.sh"]

# Define argumentos por defecto para el ENTRYPOINT.
# Si ejecutas 'docker-compose run --rm processor' sin argumentos extra,
# se ejecutará './process.sh' sin argumentos (mostrando su mensaje de uso).
# Si tu script maneja una opción como --help, podrías poner CMD ["--help"]
CMD []
