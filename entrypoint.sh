#!/bin/sh
set -e

echo "Waiting for database..."
while ! nc -z ${PGHOST} ${PGPORT} 2>&1; do
  sleep 1
done

echo "Database is now available"

# Crear el archivo odoo.conf con variables de entorno REALES de Railway
cat > /etc/odoo/odoo.conf <<EOF
[options]
db_host = ${PGHOST}
db_port = ${PGPORT}
db_user = ${PGUSER}
db_password = ${PGPASSWORD}
db_name = ${POSTGRES_DB}
addons_path = /mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons
admin_passwd = admin
EOF

exec odoo -c /etc/odoo/odoo.conf 2>&1
