#!/bin/sh
set -e

echo "🎯 Entrando a entrypoint.sh..."

PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}
PGUSER=${PGUSER:-odoo}
PGPASSWORD=${PGPASSWORD:-odoo}
POSTGRES_DB=${POSTGRES_DB:-odoo_db}

# Esperar a PostgreSQL
echo "🔄 Esperando a PostgreSQL en $PGHOST:$PGPORT..."
while ! nc -z "$PGHOST" "$PGPORT" 2>/dev/null; do
  sleep 1
done
echo "✅ PostgreSQL disponible"

# 🧹 Limpiar filestore y addons cache
echo "🧹 Limpiando filestore y cache de addons..."
rm -rf /root/.local/share/Odoo/filestore/*
rm -rf /var/lib/odoo/.local/share/Odoo/filestore/*
rm -rf /mnt/extra-addons/__pycache__ /mnt/extra-addons/*/__pycache__

# 💣 Borrar y recrear base de datos
echo "💣 Borrando base de datos '$POSTGRES_DB' si existe..."
export PGPASSWORD=$PGPASSWORD
psql -h "$PGHOST" -U "$PGUSER" -c "DROP DATABASE IF EXISTS $POSTGRES_DB;" || true
psql -h "$PGHOST" -U "$PGUSER" -c "CREATE DATABASE $POSTGRES_DB;" || true

# 📄 Configuración dinámica
echo "⚙️ Generando archivo odoo.conf..."
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

# 🧱 Instalar módulos
echo "📦 Instalando módulos base + personalizados..."
odoo -c /etc/odoo/odoo.conf -i base,custom_user_menu -u custom_user_menu --log-level=info --dev=all

# 🚀 Ejecutar Odoo
echo "🚀 Iniciando Odoo..."
exec odoo -c /etc/odoo/odoo.conf