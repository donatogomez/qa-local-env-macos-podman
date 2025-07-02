#!/bin/bash
clear
echo "=================================================="
echo "      VERIFICANDO PODMAN MACHINE"
echo "=================================================="
echo

# Crear máquina si no existe
if ! podman machine list --format "{{.Name}}" | grep -qi podman; then
    echo "[INFO] No se encontró una máquina de Podman. Ejecutando 'podman machine init'..."
    podman machine init
fi

# Iniciar máquina si no está corriendo
if ! podman machine info &> /dev/null; then
    echo "[INFO] Iniciando la máquina de Podman..."
    podman machine start
else
    echo "[INFO] Podman Machine ya está en ejecución."
fi

# Verificar conexión con Podman
echo "[INFO] Verificando conexión con Podman..."
if ! podman info &> /dev/null; then
    echo "[INFO] No se puede conectar. Intentando reiniciar Podman Machine..."
    podman machine stop
    sleep 3
    podman machine start
    sleep 5
fi

# Reintento final
if ! podman info &> /dev/null; then
    echo "❌ No se pudo recuperar la conexión con Podman."
    echo "Intenta reiniciar manualmente con:"
    echo "    podman machine stop && podman machine start"
    exit 1
fi

echo
echo "=================================================="
echo "     VERIFICANDO CONTENEDORES EN EJECUCIÓN"
echo "=================================================="
echo

CONTAINERS=$(podman ps -a --format "{{.Names}}")

if [ -z "$CONTAINERS" ]; then
    echo "[INFO] No hay contenedores en ejecución. Se iniciarán los nuevos."
else
    echo "[INFO] Contenedores en ejecución:"
    echo "$CONTAINERS"
    echo

    echo "=================================================="
    echo "  DETENIENDO Y ELIMINANDO CONTENEDORES"
    echo "=================================================="
    echo

    echo "[INFO] Deteniendo con podman-compose..."
    podman-compose down --volumes

    echo "[INFO] Eliminando contenedores restantes..."
    podman rm -a -f

    echo "[INFO] Limpiando redes y volúmenes..."
    podman network prune -f
    podman volume prune -f
fi

echo
echo "=================================================="
echo "        CARGANDO IMAGEN EN PODMAN"
echo "=================================================="
echo

if [ -f "../../webservicecourse.tar" ]; then
    podman load -i "../../webservicecourse.tar"
else
    echo "❌ ERROR: No se encontró 'webservicecourse.tar'."
    echo "Asegúrate de que el archivo está en la carpeta correcta."
    exit 1
fi

echo
echo "=================================================="
echo "       INICIANDO CONTENEDORES"
echo "=================================================="
echo

echo "[INFO] Verificando si hay contenedores antes de iniciarlos:"
podman ps -a --format "{{.Names}}"
echo

echo "[INFO] Iniciando los contenedores con Podman Compose..."
podman-compose up -d
echo

echo "=================================================="
echo "     CONTENEDORES DESPUÉS DE INICIAR"
echo "=================================================="
echo

podman ps -a --format "{{.Names}}"
echo

echo "=================================================="
echo " TODOS LOS SERVICIOS ESTÁN EN EJECUCIÓN"
echo "=================================================="
