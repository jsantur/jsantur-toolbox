# 🧹 JSANTUR Toolbox

<p align="center">
  <a href="">
    <img src="./Recursos/jsanturToolbox.png" alt="Jsantur ToolBox" width="80%">
  </a>
</p>

> Mi espacio personal de scripts y herramientas de automatización para Windows.

---

## 👋 Bienvenido

Bienvenido a mi repositorio.

Aquí almaceno, organizo y mejoro mis scripts de **PowerShell**, **Batch** y otras utilidades diseñadas para automatizar tareas, optimizar Windows y simplificar procesos cotidianos, evitando depender de programas de terceros.

Todo el código está escrito siguiendo buenas prácticas:

- ✅ Código limpio y organizado.
- ✅ Comentarios explicativos.
- ✅ Fácil de modificar y reutilizar.
- ✅ Enfoque en rendimiento y simplicidad.

---

# ⭐ Proyecto Destacado

## 🪟 Limpieza de Perfil de Usuario

Aplicación gráfica desarrollada en **PowerShell + WPF** para limpiar el perfil del usuario de forma rápida, segura y moderna.

### ✨ Características

- 🎨 **Interfaz moderna**
  - Inspirada en macOS.
  - Fondo blanco.
  - Esquinas redondeadas.
  - Sombras suaves.
  - Sin consola negra visible.

- 🛡️ **Seguridad**
  - No elimina archivos permanentemente.
  - Todo el contenido se envía a la **Papelera de reciclaje**.

- 🧠 **Limpieza inteligente**
  - Conserva los accesos directos (`.lnk`) del Escritorio.
  - Respeta archivos ocultos y del sistema.

- ⚡ **Alto rendimiento**
  - Uso de **Runspaces (multihilo)**.
  - Limpieza de cientos de archivos sin bloquear la interfaz.

- 📊 **Retroalimentación visual**
  - Barra de progreso en tiempo real.
  - Notificaciones tipo **Toast** al finalizar.

---

## 📂 Estructura del repositorio

```text
jsantur-toolbox/
│
├── README.md
├── .gitignore
│
└── Windows/
    │
    └── LimpiezaPerfil/
        │
        ├── AppLimpiadora.ps1
        ├── Lanzador.bat
        ├── Diagnosticar.bat
        └── clearjs.ico
```

---

# 🚀 Cómo utilizar

1. Descarga o clona este repositorio.

2. Navega hasta el proyecto que deseas utilizar.

3. Ejecuta:

### ✔ Modo normal

```text
Lanzador.bat
```

Oculta la consola y abre directamente la interfaz gráfica.

### 🛠 Modo diagnóstico

```text
Diagnosticar.bat
```

Muestra la consola para visualizar posibles errores durante la ejecución.

### 📦 Compilar como EXE (Opcional)

Si deseas distribuir la aplicación como ejecutable, puedes compilar el archivo `.ps1` utilizando:

- **Win-PS2EXE**

---

# 🛠 Tecnologías

| Tecnología | Uso |
|------------|-----|
| PowerShell | Automatización y lógica |
| WPF + XAML | Interfaces gráficas |
| Batch (.bat) | Lanzadores rápidos |

---

# 📌 Objetivo del proyecto

Crear herramientas que permitan:

- Automatizar tareas repetitivas.
- Optimizar Windows.
- Mejorar la productividad.
- Evitar software innecesario.
- Compartir scripts útiles y fáciles de adaptar.

---

# 🤝 Contribuciones

Las sugerencias, mejoras y reportes de errores son siempre bienvenidos.

Si encuentras un problema o tienes una idea para mejorar algún script, no dudes en abrir un **Issue** o enviar un **Pull Request**.

---

# 📄 Licencia

Este proyecto se distribuye bajo la licencia **MIT**, salvo que se indique lo contrario en algún proyecto específico.

---

<div align="center">

### ☕ Hecho con pasión, PowerShell y mucho café.

**JSANTUR**

</div>
