#!/bin/bash

# REGLA 2: Fail-Fast. Si cualquier comando o sub-script falla, todo se detiene inmediatamente.
set -e

# REGLA 1: Validar que el script se ejecuta como superusuario (root)
if [ "$EUID" -ne 0 ]; then
    echo " [ERROR FATAL] Este script de despliegue debe ejecutarse con sudo."
    echo " Uso correcto: sudo ./deploy.sh"
    exit 1
fi

echo "==================================================="
echo "   INICIANDO DESPLIEGUE DEL LABORATORIO (UBUNTU)   "
echo "==================================================="

# REGLA 3: Garantizar permisos de ejecución a los sub-scripts antes de llamarlos
echo " -> Verificando permisos de los scripts..."
chmod +x usuarios.sh samba.sh cups.sh dhcp.sh

# EJECUCIÓN ORDENADA
echo ""
echo "[1/4] Ejecutando configuración de Usuarios..."
./usuarios.sh

echo ""
echo "[2/4] Ejecutando configuración de Samba..."
./samba.sh

echo ""
echo "[3/4] Ejecutando configuración de CUPS..."
./cups.sh

echo ""
echo "[4/4] Ejecutando configuración de DHCP..."
./dhcp.sh

echo ""
echo "[5/5] Ejecutando configuración de Apache..."
./apache.sh

echo ""
echo "==================================================="
echo " [ÉXITO] TODOS LOS SERVICIOS FUERON DESPLEGADOS.   "
echo "==================================================="
