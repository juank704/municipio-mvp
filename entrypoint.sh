#!/bin/sh
set -e

# Mostrar las variables que vamos a usar (debug)
echo "Variables de conexión:"
echo "  Host:     ${PGHOST:-<no definido>}"
echo "  Puerto:   ${PGPORT:-<no definido>}"
echo "  Usuario:  ${PGUSER:-<no definido>}"
echo "  Base de datos: ${POSTGRES_DB:-<no definido>}"

# Fallbacks por si Railway no las define (útil para desarrollo local)
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}
PGUSER=${PGUSER:-odoo}
PGPASSWORD=${PGPASSWORD:-odoo}
POSTGRES_DB=${POSTGRES_DB:-odoo}

# Esperar a que el servidor de Postgres esté disponible
echo "Esperando a PostgreSQL en ${PGHOST}:${PGPORT}..."
while ! nc -z "$PGHOST" "$PGPORT" 2>/dev/null; do
  sleep 1
done
echo "✅ PostgreSQL está disponible"

# Generar archivo de configuración dinámico
echo "Generando archivo odoo.conf..."
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

echo "Iniciando Odoo..."
exec odoo -c /etc/odoo/odoo.conf -i base 2>&1