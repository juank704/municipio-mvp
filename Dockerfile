FROM odoo:17.0

ARG LOCALE=en_US.UTF-8
ENV LANGUAGE=${LOCALE}
ENV LC_ALL=${LOCALE}
ENV LANG=${LOCALE}

USER 0
RUN apt-get -y update && apt-get install -y --no-install-recommends locales netcat-openbsd curl \
    && locale-gen ${LOCALE} \
    && apt-get clean

# Copiar código local
COPY ./addons /mnt/extra-addons
COPY ./entrypoint.sh /app/entrypoint.sh
COPY ./odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /tmp/requirements.txt

# Instalar dependencias Python si hay
RUN pip3 install -r /tmp/requirements.txt || true

WORKDIR /app

HEALTHCHECK CMD curl --fail http://localhost:${PORT}/web/login || exit 1

ENTRYPOINT ["/bin/sh"]
CMD ["entrypoint.sh"]
