# Usa la imagen base de Ubuntu 14.04 (Trusty Tahr)
FROM ubuntu:14.04

# Etiqueta opcional para mantener información
LABEL maintainer="Tu Nombre <tu@email.com>"

# Actualiza la lista de paquetes e instala ghostscript y netcat
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ghostscript \
        netcat-traditional \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Establece un directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el script de procesamiento al directorio de trabajo
COPY process.sh .

# Asegúrate de que el script tenga permisos de ejecución
RUN chmod +x ./process.sh

# Define el script como el punto de entrada principal del contenedor.
# Esto significa que cuando ejecutes el contenedor, se ejecutará este script.
# Los argumentos pasados a `docker run` se añadirán después de ./process.sh
ENTRYPOINT ["./process.sh"]

# Opcional: Define un comando por defecto si no se pasan argumentos al ENTRYPOINT.
# En este caso, si ejecutas `docker run mi-imagen` sin argumentos,
# el script `process.sh` se ejecutará sin argumentos y mostrará su mensaje de uso.
CMD ["--help"]
