@echo off
chcp 65001 >nul 2>&1

:: Verificar si ya tenemos permisos de administrador
net session >nul 2>&1

:: Si no tenemos permisos (errorlevel 1), solicitarlos
if %errorLevel% == 0 (
    goto :RunApp
) else (
    goto :Elevate
)

:Elevate
:: Crear un pequeño script temporal para solicitar UAC y lanzar la app oculta
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\ElevateLicenseInspector.vbs"
echo UAC.ShellExecute "powershell.exe", "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -STA -File ""%~dp0LicenseInspector.ps1""", "", "runas", 0 >> "%temp%\ElevateLicenseInspector.vbs"
cscript //nologo "%temp%\ElevateLicenseInspector.vbs"
del "%temp%\ElevateLicenseInspector.vbs"
exit

:RunApp
:: Ejecutar la aplicación con permisos de administrador de forma oculta
powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0LicenseInspector.ps1"
exit