@echo off
chcp 65001 >nul 2>&1
title Script de Reinicializacao Automatica - Cinelandia [CORRIGIDO]
color 0A

echo ========================================
echo   REINICIALIZACAO AUTOMATICA ATIVA
echo ========================================
echo Horarios de reinicializacao:
echo - Horario 1: 06:00 (6:00 da manha)
echo - Horario 2: 20:10 (8:10 da noite)
echo.
echo Controles:
echo - Pressione 'R' para reinicializacao manual
echo - Pressione 'Q' para sair do script
echo.
echo Iniciando script corrigido...
echo.

REM Executa o script PowerShell corrigido
powershell.exe -ExecutionPolicy Bypass -File "%~dp0auto_restart.ps1"

echo.
echo Script encerrado.
pause