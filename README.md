# 🏛️ Odoo Municipio MVP

Este proyecto es un MVP construido con **Odoo 17 Community Edition**, pensado para gestionar servicios municipales como:

- Proyectos
- Partes de horas (timesheets)
- Empleados
- Roles personalizados

---

## 🚀 Despliegue en Railway

Haz clic en el botón para desplegar este proyecto directamente en Railway:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/TU_USUARIO/municipio-mvp)

> ⚠️ Reemplaza `TU_USUARIO` con tu usuario real de GitHub en la URL si vas a compartir este botón.

---

## 📁 Estructura del proyecto

municipio-mvp/
├── Dockerfile            # Construye tu propia imagen de Odoo
├── docker-compose.yml    # Define servicios: Odoo + PostgreSQL
├── .dockerignore         # Evita subir archivos innecesarios al build
├── .gitmodules           # Referencia al submódulo de Odoo
├── odoo/                 # Submódulo del core de Odoo
├── addons/               # Tus módulos personalizados
└── README.md
---

## 🧪 Clonación correcta del proyecto

Como se usa un submódulo Git para Odoo, **clona así**:

```bash
git clone --recurse-submodules https://github.com/juank704/municipio-mvp.git