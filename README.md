# QA Local Environment for macOS with Podman

Este repositorio proporciona un entorno de servicios para pruebas locales de QA en macOS, utilizando **Podman** como alternativa ligera a Docker. Los scripts incluidos permiten instalar dependencias automáticamente y gestionar contenedores con facilidad mediante `podman-compose`.

---

## 📦 Servicios incluidos (`docker-compose.yml`)

* **MariaDB** – Base de datos relacional.
* **Adminer** – Interfaz web para explorar la base de datos.
* **App** – Servicio web cargado desde una imagen local (`webservicecourse.tar`).

---

## 🛠️ Requisitos

* macOS (preferiblemente reciente)
* [Homebrew](https://brew.sh/) (si no está, el script lo instala)
* Conexión a Internet (para instalar dependencias la primera vez)
* Archivo `webservicecourse.tar` (no incluido)

---

## 🚀 Instalación de dependencias

Desde el directorio raíz del repositorio:

```bash
python3 scripts/install_dependencies.py
```

Este script se encargará de instalar:

* Homebrew (si no está instalado)
* Python 3
* Podman
* pipx
* `podman-compose` (vía pipx)

También se asegura de que `$HOME/.local/bin` esté en tu `PATH` si es necesario.

---

## ▶️ Levantar los servicios

```bash
cd UpDownServices
./startWebService_mac.sh
```

> Asegúrate de tener el archivo `webservicecourse.tar` en el directorio raíz del proyecto (o ajusta la ruta en el script).

Esto:

1. Verifica que Podman Machine esté creada y en ejecución.
2. Detiene y elimina contenedores anteriores.
3. Carga la imagen `webservicecourse`.
4. Ejecuta `podman-compose up -d` para levantar los servicios.

---

## ⏹️ Detener los servicios

```bash
./stopWebService_mac.sh
```

Esto detiene los contenedores, los elimina, limpia redes y volúmenes, y detiene la Podman Machine.

---

## 🔁 Reiniciar todo el entorno

```bash
./restartWebService_mac.sh
```

---

## 📂 Estructura del repositorio

```plaintext
qa-local-env-macos-podman/
├── UpDownServices/
│   ├── docker-compose.yml
│   ├── startWebService_mac.sh
│   ├── stopWebService_mac.sh
│   └── restartWebService_mac.sh
├── scripts/
│   └── install_dependencies.py
├── .gitignore
└── README.md
```

---

## ✅ Ventajas de usar Podman

* No requiere permisos de root.
* Compatible con `docker-compose` mediante `podman-compose`.
* Se integra bien con entornos sin Docker Desktop (por ejemplo, M1/M2 sin licencia empresarial de Docker).

---

## 🧪 Casos de uso

Este entorno es útil para:

* Cursos de QA que requieren backend simulado localmente.
* Testing manual o automatizado contra servicios de base de datos y API.
* Equipos que no usan Docker pero necesitan contenedores livianos y reproducibles.

---

## ⚠️ Notas

* El archivo `webservicecourse.tar` **no está incluido** por razones de tamaño/licencia. Debes colocarlo manualmente en la carpeta raíz del proyecto o modificar la ruta en `startWebService_mac.sh`.
* Este entorno está optimizado para macOS. No está garantizado su funcionamiento en Linux o Windows sin adaptaciones.

---

## 👨‍💻 Autor

Adaptado por **Donato** para entornos macOS a partir de un curso de QA originalmente diseñado para Windows.
Especial agradecimiento a quienes fomentan soluciones multiplataforma y libres de dependencias propietarias innecesarias.

---

## 📄 Licencia

MIT
