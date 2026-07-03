@echo off
:: =============================================================================
:: LANZADOR INVISIBLE PARA APLICACIÓN WPF (CORREGIDO)
:: El parámetro -STA es OBLIGATORIO para que la interfaz gráfica funcione.
:: =============================================================================
chcp 65001 >nul 2>&1

:: Ejecutamos PowerShell en modo oculto, sin perfil, omitiendo restricciones y en modo STA
start "" /B powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0AppLimpiadora.ps1"

exit