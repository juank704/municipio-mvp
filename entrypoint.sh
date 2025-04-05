#!/bin/sh
set -e

echo "🔁 Iniciando entrypoint Odoo"

# Variables de conexión
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}
PGUSER=${PGUSER:-odoo}
PGPASSWORD=${PGPASSWORD:-odoo}
POSTGRES_DB=${POSTGRES_DB:-odoo}

echo "🛠 Esperando PostgreSQL en ${PGHOST}:${PGPORT}..."
while ! nc -z "$PGHOST" "$PGPORT"; do
  sleep 1
done
echo "✅ PostgreSQL disponible"

# Generar odoo.conf
echo "📄 Generando configuración..."
cat > /etc/odoo/odoo.conf <<EOF
[options]
db_host = $PGHOST
db_port = $PGPORT
db_user = $PGUSER
db_password = $PGPASSWORD
db_name = $POSTGRES_DB
addons_path = /mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons
admin_passwd = admin
EOF

# 🧹 Limpiar filestore de Odoo (muy importante para evitar errores de assets)
echo "🧹 Limpiando filestore..."
rm -rf /root/.local/share/Odoo/filestore/*
rm -rf /var/lib/odoo/.local/share/Odoo/filestore/*

# 💣 Eliminar la base de datos (si quieres hacer una instalación limpia real)
# ⚠️ Solo si estás seguro que quieres borrar TODO
echo "⚠️ Eliminando base de datos $POSTGRES_DB..."
psql -h "$PGHOST" -U "$PGUSER" -c "DROP DATABASE IF EXISTS $POSTGRES_DB;" || true
psql -h "$PGHOST" -U "$PGUSER" -c "CREATE DATABASE $POSTGRES_DB;" || true

# 📦 Instalar módulos desde cero
echo "📦 Instalando Odoo con módulos personalizados..."
odoo -c /etc/odoo/odoo.conf -i base --dev=all --log-level=info

# 🚀 Iniciar servidor
echo "🚀 Iniciando Odoo..."
exec odoo -c /etc/odoo/odoo.conf
