#!/bin/bash
echo "=== 3. CONFIGURANDO CUPS PROFESIONAL ==="
apt-get update -y
apt-get install -y cups printer-driver-cups-pdf

echo " -> Habilitando accesos remotos..."
cupsctl --remote-admin --remote-any --share-printers

echo " -> Asignando permisos administrativos..."
usermod -aG lpadmin vagrant
usermod -aG lpadmin nuevo

echo " -> Configurando autenticación estricta en cupsd.conf..."
# Inyecta el bloque de seguridad para la impresora virtual si no existe
if ! grep -q "<Location /printers/PDF>" /etc/cups/cupsd.conf; then
    sed -i '/<Policy default>/i \
<Location /printers/PDF>\n  AuthType Default\n  Require user vagrant nuevo\n  Order deny,allow\n  Allow all\n</Location>\n' /etc/cups/cupsd.conf
fi

echo " -> Configurando directorios por usuario en cups-pdf.conf..."
# Asegura que Out apunte al HOME y comenta la carpeta ANONYMOUS
sed -i 's/^#Out ${HOME}\/PDF/Out ${HOME}\/PDF/' /etc/cups/cups-pdf.conf
sed -i 's/^AnonDirName/#AnonDirName/' /etc/cups/cups-pdf.conf

echo " -> Preparando carpeta de destino para el usuario 'nuevo'..."
mkdir -p /home/nuevo/PDF
chown -R nuevo:nuevo /home/nuevo
chmod 755 /home/nuevo
chmod 777 /home/nuevo/PDF

echo " -> Reiniciando servicio CUPS..."
systemctl restart cups
systemctl enable cups
echo "¡CUPS configurado con éxito y asegurado!"
