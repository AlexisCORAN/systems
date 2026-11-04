#!/bin/bash
echo "=== 4. INSTALANDO Y CONFIGURANDO SERVIDOR DHCP (ESTÁNDAR PROFESIONAL) ==="

echo " -> Instalando isc-dhcp-server..."
apt-get update -y
apt-get install -y isc-dhcp-server

echo " -> Configurando la interfaz enp0s8 mediante sed..."
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
# Usamos sed para buscar la línea INTERFACESv4 y reemplazar su valor limpiamente
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="enp0s8"/' /etc/default/isc-dhcp-server

echo " -> Inyectando configuración de red de forma segura..."
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

# Verificamos si la subred ya está configurada para no duplicar código
if ! grep -q "subnet 192.168.20.0" /etc/dhcp/dhcpd.conf; then
cat <<EOF >> /etc/dhcp/dhcpd.conf

# --- CONFIGURACIÓN DE CLASE ---
option domain-name "red-interna";
option domain-name-servers 8.8.8.8, 8.8.4.4;

default-lease-time 600;
max-lease-time 7200;

authoritative;

subnet 192.168.20.0 netmask 255.255.255.0 {
    range 192.168.20.100 192.168.20.200;
    option routers 192.168.20.2;
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.20.255;
}
EOF
    echo " -> Bloque de configuración inyectado al final del archivo original."
else
    echo " -> La subred ya existe en dhcpd.conf. Se omite la inyección."
fi

echo " -> Reiniciando el servicio DHCP..."
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server

echo "¡Servidor DHCP configurado con éxito!"
