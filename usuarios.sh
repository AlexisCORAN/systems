#!/bin/bash
echo "=== 1. CREANDO USUARIOS DEL SISTEMA ==="

# Validamos si el usuario 'nuevo' no existe
if ! id -u nuevo >/dev/null 2>&1; then
    # -m crea la carpeta /home/nuevo obligatoria para CUPS-PDF
    # -s /bin/bash le da un entorno válido para autenticarse
    useradd -m -s /bin/bash nuevo
    
    # Asignamos la contraseña '123456' a nivel de sistema operativo (Para CUPS)
    echo "nuevo:123456" | chpasswd
    
    echo " -> Usuario 'nuevo' creado exitosamente con carpeta personal."
else
    echo " -> El usuario 'nuevo' ya existe en el sistema."
fi
