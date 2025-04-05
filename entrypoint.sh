#!/bin/sh
set -e

echo "🎯 Entrando a entrypoint.sh..."

# Fallbacks
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}
PGUSER=${PGUSER:-odoo}
PGPASSWORD=${PGPASSWORD:-odoo}
POSTGRES_DB=${POSTGRES_DB:-odoo_db}

echo "🔄 Esperando a PostgreSQL en $PGHOST:$PGPORT..."
while ! nc -z "$PGHOST" "$PGPORT" 2>/dev/null; do
  sleep 1
done
echo "✅ PostgreSQL listo"

# 🧼 Limpiar filestore
echo "🧹 Eliminando filestore..."
rm -rf /root/.local/share/Odoo/filestore/*
rm -rf /var/lib/odoo/.local/share/Odoo/filestore/*

# 💣 Borrar base de datos si existe y crear nueva
echo "🧨 Borrando base de datos antigua y creando nueva..."
export PGPASSWORD=$PGPASSWORD
psql -h "$PGHOST" -U "$PGUSER" -c "DROP DATABASE IF EXISTS $POSTGRES_DB;" || true
psql -h "$PGHOST" -U "$PGUSER" -c "CREATE DATABASE $POSTGRES_DB;" || true

# 📄 Config
echo "⚙️ Generando odoo.conf..."
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

# 📦 Instalar módulos
echo "📦 Instalando base + custom_user_menu..."
odoo -c /etc/odoo/odoo.conf -i base --log-level=info --dev=all

# 🚀 Iniciar Odoo
echo "🚀 Iniciando Odoo..."
exec odoo -c /etc/odoo/odoo.conf