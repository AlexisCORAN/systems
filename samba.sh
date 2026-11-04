#!/bin/bash
echo "=== 2. CONFIGURANDO SAMBA ==="
apt-get update -y
apt-get install -y samba

echo " -> Asignando contraseña de red al usuario..."
(echo "123456"; echo "123456") | smbpasswd -s -a nuevo

echo " -> Creando la estructura de carpetas compartidas..."
mkdir -p /home/compartido/1
mkdir -p /home/compartido/2
mkdir -p /home/compartido/3
chown -R nuevo:nuevo /home/compartido
chmod -R 0770 /home/compartido

echo " -> Inyectando configuraciones en smb.conf..."
if ! grep -q "\[Compartido\]" /etc/samba/smb.conf; then
cat <<EOF >> /etc/samba/smb.conf

[Compartido]
    path = /home/compartido
    valid users = nuevo
    guest ok = no
    writable = yes
    browseable = yes
    create mask = 0770
    directory mask = 0770

[PDF_Impresos]
    path = /home/nuevo/PDF
    valid users = nuevo
    guest ok = no
    writable = yes
    browseable = yes
EOF
    echo " -> Recursos [Compartido] y [PDF_Impresos] inyectados."
fi

echo " -> Reiniciando servicio Samba..."
systemctl restart smbd
systemctl enable smbd
echo "¡Samba configurado con éxito!"
