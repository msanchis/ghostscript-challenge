# Contenedor Docker para Procesamiento con Ghostscript

Este repositorio contiene un `Dockerfile` para construir una imagen Docker basada en Ubuntu 14.04 que incluye `ghostscript` y `netcat`. El propósito principal de este contenedor es ejecutar un script (`process.sh`) que utiliza Ghostscript para realizar tareas de procesamiento de archivos, como la generación de miniaturas de PDF.

## Contenido de la Imagen

*   **Imagen Base:** `ubuntu:14.04` (Trusty Tahr)
*   **Software Instalado:**
    *   `ghostscript`: Intérprete de PostScript y PDF.
    *   `netcat-traditional`: Utilidad de red para leer/escribir datos a través de conexiones de red.
*   **Script de Procesamiento:** `process.sh` (copiado en `/app/` dentro del contenedor).

## Propósito

El contenedor está diseñado para aislar el entorno necesario para ejecutar `ghostscript`. El `ENTRYPOINT` está configurado para ejecutar el script `process.sh`, que por defecto está diseñado para tomar un archivo PDF como entrada y generar una miniatura en formato JPEG de su primera página.

## Construcción de la Imagen

Para construir la imagen Docker localmente, navega al directorio que contiene el `Dockerfile` y `process.sh`, y ejecuta:

```bash
docker build -t mi-imagen-procesadora .
Puedes reemplazar `mi-imagen-procesadora` con el nombre y etiqueta que prefieras.

## Ejecución del Contenedor

Para ejecutar el contenedor y procesar un archivo PDF, necesitas montar el directorio que contiene el PDF en el directorio de trabajo del contenedor (`/app`) y pasar el nombre del archivo PDF como argumento al comando `docker run`.

**Ejemplo:**

Supongamos que tienes un archivo llamado `documento.pdf` en tu directorio actual (`/ruta/local/a/tus/pdfs`).

1.  **Generar miniatura con nombre por defecto (`documento_thumb.jpg`):**

    ```bash
    docker run --rm -v "/ruta/local/a/tus/pdfs:/app" mi-imagen-procesadora documento.pdf
    ```

2.  **Generar miniatura con nombre específico (`miniatura_salida.jpg`):**

    ```bash
    docker run --rm -v "/ruta/local/a/tus/pdfs:/app" mi-imagen-procesadora documento.pdf miniatura_salida.jpg
    ```

**Explicación de los comandos `docker run`:**

*   `--rm`: Elimina el contenedor automáticamente una vez que el script `process.sh` finaliza.
*   `-v "/ruta/local/a/tus/pdfs:/app"`: Monta el directorio local `/ruta/local/a/tus/pdfs` (donde se encuentra tu PDF) en el directorio `/app` dentro del contenedor. Esto permite que el script `process.sh` acceda al archivo de entrada y guarde el archivo de salida en tu directorio local. **Importante:** Reemplaza `/ruta/local/a/tus/pdfs` con la ruta real en tu sistema. Si estás en el mismo directorio que el PDF, puedes usar `$(pwd)` (Linux/macOS) o `%cd%` (Windows CMD).
*   `mi-imagen-procesadora`: El nombre de la imagen que construiste.
*   `documento.pdf`: El primer argumento pasado al script `process.sh` (el archivo PDF de entrada).
*   `miniatura_salida.jpg` (opcional): El segundo argumento pasado al script `process.sh` (el nombre deseado para el archivo de salida).

## Script `process.sh`

Este script es el punto de entrada del contenedor. Está diseñado para:

1.  Recibir la ruta a un archivo PDF como primer argumento.
2.  Opcionalmente, recibir un nombre de archivo de salida como segundo argumento.
3.  Utilizar `ghostscript` para generar una miniatura JPEG de la primera página del PDF.
4.  Guardar la miniatura en el directorio de trabajo (`/app`, que está montado desde tu sistema local).

Puedes modificar `process.sh` para adaptar el comportamiento del contenedor a tus necesidades específicas de procesamiento con Ghostscript o Netcat.
## Ejecución con Docker Compose

Se proporciona un archivo `docker-compose.yml` para simplificar la ejecución del contenedor, especialmente la gestión del montaje de volúmenes.

**Preparación:**

1.  Asegúrate de tener `docker-compose` instalado.
2.  Crea un directorio llamado `data` en la misma carpeta donde se encuentran `docker-compose.yml`, `Dockerfile` y `process.sh`:
    ```bash
    mkdir data
    ```
3.  Coloca los archivos PDF que deseas procesar dentro de este directorio `data`.

**Ejecución:**

Abre una terminal en el directorio que contiene el archivo `docker-compose.yml` y ejecuta los siguientes comandos:

1.  **Generar miniatura con nombre por defecto (`documento_thumb.jpg`):**
    *   Asegúrate de que `documento.pdf` está en el directorio `data`.
    ```bash
    docker-compose run --rm processor documento.pdf
    ```

2.  **Generar miniatura con nombre específico (`miniatura_salida.jpg`):**
    *   Asegúrate de que `documento.pdf` está en el directorio `data`.
    ```bash
    docker-compose run --rm processor documento.pdf miniatura_salida.jpg
    ```

**Explicación del comando `docker-compose run`:**

*   `docker-compose run`: Ejecuta un comando único para un servicio definido en `docker-compose.yml`.
*   `--rm`: Elimina el contenedor una vez que el script finaliza.
*   `processor`: Es el nombre del servicio definido en el archivo `docker-compose.yml`.
*   `documento.pdf` / `documento.pdf miniatura_salida.jpg`: Son los argumentos que se pasan al script `process.sh` dentro del contenedor.

La miniatura generada se guardará en el directorio `data` de tu máquina local, ya que está montado como volumen en el contenedor.
