FROM odoo:17

# Copia todo el proyecto primero (por contexto de build)
COPY . /opt/odoo-build

# Entra al directorio temporal
WORKDIR /opt/odoo-build

# Asegura que el submódulo esté inicializado (en caso de que venga de Railway o CI)
RUN git submodule update --init --recursive || echo "Continuando sin submódulos"

# Copia el core de Odoo desde el submódulo
COPY ./odoo /usr/lib/python3/dist-packages/odoo

# Copia los módulos personalizados
COPY ./addons /mnt/extra-addons

# (Opcional) Instala requerimientos adicionales
# RUN pip install -r /usr/lib/python3/dist-packages/odoo/requirements.txt
