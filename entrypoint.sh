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