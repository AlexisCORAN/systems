#!/bin/bash
echo "=== 5. INSTALANDO Y CONFIGURANDO SERVIDOR WEB (APACHE) ==="

echo " -> Instalando apache2..."
apt-get update -y
apt-get install -y apache2

echo " -> Creando página web del laboratorio..."
# Aquí sí usamos un solo '>' porque queremos SOBRESCRIBIR la página por defecto de Apache
# para poner nuestra propia página HTML.
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Servidor Web - Laboratorio</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #f4f4f9; }
        .container { border: 1px solid #dcdcdc; padding: 40px; width: 60%; margin: auto; border-radius: 10px; background-color: #ffffff; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        p { font-size: 18px; color: #555555; }
        .ip-box { display: inline-block; background-color: #e74c3c; color: white; padding: 10px 20px; border-radius: 5px; font-weight: bold; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Servidor Apache Funcionando!</h1>
        <p>Bienvenido al servidor web oficial del laboratorio.</p>
        <p><strong>Dominio Local:</strong> red-interna</p>
        <div class="ip-box">IP del Servidor: 192.168.20.2</div>
    </div>
</body>
</html>
EOF

echo " -> Ajustando permisos de seguridad del directorio web..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo " -> Reiniciando el servicio Apache..."
systemctl restart apache2
systemctl enable apache2

echo "¡Servidor Apache configurado con éxito!"
