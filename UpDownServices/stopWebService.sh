#!/bin/bash
clear
echo "=================================================="
echo "     DETENIENDO CONTENEDORES Y PODMAN MACHINE"
echo "=================================================="
echo

# Verificar si la máquina de Podman está en ejecución
if ! podman machine info &> /dev/null; then
    echo "La máquina ya está detenida o no está disponible."
    echo "No hay contenedores que detener."
else
    echo "Buscando contenedores activos..."
    CONTAINERS=$(podman ps -a --format "{{.Names}}")

    if [ -z "$CONTAINERS" ]; then
        echo "No hay contenedores en ejecución."
    else
        echo "Contenedores en ejecución:"
        echo "$CONTAINERS"
        echo

        echo "Deteniendo contenedores con podman-compose..."
        podman-compose down --volumes

        echo "Eliminando contenedores restantes (si los hay)..."
        podman rm -a -f

        echo "Limpiando redes y volúmenes..."
        podman network prune -f
        podman volume prune -f
    fi

    echo
    echo "Deteniendo Podman Machine..."
    podman machine stop
fi

echo
echo "=================================================="
echo " WebService detenido correctamente"
echo "=================================================="
