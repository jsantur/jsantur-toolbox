@echo off
chcp 65001 >nul 2>&1
echo Ejecutando en modo visible para ver errores...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0LicenseInspector.ps1"
pause