FROM odoo:17

# Entra a un directorio temporal
WORKDIR /opt/odoo-build

# (Opcional) Inicializa submódulos si fuera necesario
RUN git submodule update --init --recursive || echo "Continuando sin submódulos"

# Copia el core de Odoo desde el submódulo
COPY ./odoo /usr/lib/python3/dist-packages/odoo

# Copia los módulos personalizados
COPY ./addons /mnt/extra-addons

# Copia el archivo de configuración
COPY ./odoo.conf /etc/odoo/odoo.conf

# (Opcional) instala requerimientos si tienes
# RUN pip install -r /usr/lib/python3/dist-packages/odoo/requirements.txt
