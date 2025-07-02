#!/bin/bash
clear
echo "=================================================="
echo "     REINICIANDO WEB SERVICE (Podman)"
echo "=================================================="
echo

# Ejecutar stop
echo "[INFO] Deteniendo contenedores y máquina Podman..."
./stopWebService_mac.sh

echo
echo "=================================================="
echo " ESPERANDO ANTES DE REINICIAR..."
echo "=================================================="
sleep 3

# Ejecutar start
echo "[INFO] Iniciando contenedores y máquina Podman..."
./startWebService_mac.sh
