@echo off
setlocal

REM ============================================================
REM OneDrive-safe launcher for Reset-ModifiedDate.ps1
REM Double-click to run, no PowerShell policy issues
REM ============================================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Reset-ModifiedDate.ps1"

pause