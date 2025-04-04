#!/bin/sh
set -e

echo "Waiting for database..."
while ! nc -z ${ODOO_DATABASE_HOST} ${ODOO_DATABASE_PORT} 2>&1; do
  sleep 1
done

echo "Database is now available"

exec odoo -c /etc/odoo/odoo.conf 2>&1