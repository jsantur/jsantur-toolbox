🧹 JSANTUR Toolbox ✨
Mi espacio personal de scripts y herramientas de automatización para Windows.

👋 Bienvenido
Bienvenido a mi rincón de código. Aquí almaceno, organizo y mejoro mis scripts de PowerShell, Batch y otras utilidades diseñadas para hacer la vida más fácil, optimizar sistemas y automatizar tareas tediosas sin tener que descargar programas de terceros dudosos.

Todo el código está comentado, es limpio y está pensado para ser reutilizado y adaptable.

🖼️ Vista Previa del Proyecto Estrella
Interfaz gráfica de Limpieza de Perfil
Interfaz de usuario moderna y minimalista, construida con WPF en PowerShell.
⭐ Proyectos Destacados
🪟 Limpieza de Perfil de Usuario
Una utilidad gráfica avanzada que automatiza la limpieza de las carpetas personales (Documentos, Descargas, Imágenes, etc.).

¿Por qué es especial?

Diseño Nativo: Inspirado en macOS. Fondo blanco, esquinas redondeadas, sombras suaves y sin ventanas negras de consola.
Seguridad Total: No elimina nada permanentemente. Todo se envía a la Papelera de Reciclaje.
Inteligente: En el Escritorio respeta los accesos directos (.lnk) y los archivos ocultos del sistema.
Rendimiento: Usa programación Multi-hilo (Runspaces). Limpia cientos de archivos al instante sin congelar la interfaz.
Feedback Visual: Barra de progreso real y notificaciones del sistema (SMS/Toast) al finalizar.
📁 Estructura del Repositorio
La carpeta está organizada por sistema operativo y por proyectos para mantenerlo todo limpio:

jsantur-toolbox/│├── README.md                   <-- ¡Estás aquí!├── .gitignore                  <-- Archivos que GitHub debe ignorar (ej. .exe)│└── Windows/                    <-- Scripts para el ecosistema Windows    └── LimpiezaPerfil/         <-- Herramienta de limpieza WPF        ├── AppLimpiadora.ps1   <-- Código fuente de la interfaz        ├── Lanzador.bat        <-- Ejecutable invisible (Modo normal)        ├── Diagnosticar.bat    <-- Ejecutable con consola (Modo debug)        └── clearjs.ico         <-- Icono personalizado del .exe
🚀 ¿Cómo usar los scripts?
La mayoría de mis scripts están diseñados para ser "Plug & Play" (Conectar y usar):

Ve a la carpeta del script que necesites.
Recomendado: Haz doble clic en el archivo Lanzador.bat (esto oculta la consola de fondo para una experiencia limpia).
Si algo falla: Usa el archivo Diagnosticar.bat para ver los errores en pantalla y poder solucionarlos.
(Opcional) Si prefieres compilar el .ps1 en un .exe con icono propio, usa la herramienta Win-PS2EXE.
🛠️ Stack Tecnológico
PowerShell Para la lógica y automatización del sistema.
Windows WPF y XAML para las interfaces gráficas modernas.
Batch Para lanzadores rápidos y silentes.
<div align="center">
<sub>Hecho con ❤️ y mucho café por <strong>JSANTUR</strong></sub>
</div>
```
