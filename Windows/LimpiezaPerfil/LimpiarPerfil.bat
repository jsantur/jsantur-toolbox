@echo off
:: =============================================================================
:: LANZADOR INVISIBLE PARA APLICACIÓN WPF
:: Ejecuta el script de PowerShell en segundo plano sin mostrar ninguna ventana.
:: =============================================================================
chcp 65001 >nul 2>&1

:: Ejecuta PowerShell de forma oculta (-WindowStyle Hidden), sin perfil 
:: para mayor velocidad (-NoProfile), y omitiendo restricciones (-ExecutionPolicy Bypass)
start "" powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "%~dp0AppLimpiadora.ps1"

exit