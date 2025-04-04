FROM odoo:17.0

ARG LOCALE=es_CL.UTF-8
ENV LANGUAGE=${LOCALE}
ENV LC_ALL=${LOCALE}
ENV LANG=${LOCALE}

USER 0
RUN apt-get -y update && apt-get install -y --no-install-recommends locales netcat-openbsd curl \
    && locale-gen ${LOCALE} \
    && apt-get clean

# Copiar código local y configuraciones
COPY ./addons /mnt/extra-addons
COPY ./entrypoint.sh /app/entrypoint.sh
COPY requirements.txt /tmp/requirements.txt

# Dar permisos de ejecución al entrypoint
RUN chmod +x /app/entrypoint.sh

# Instalar dependencias Python si hay
RUN pip3 install -r /tmp/requirements.txt || true

WORKDIR /app

HEALTHCHECK CMD curl --fail http://localhost:8069/web/login || exit 1

# Usar script como entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
