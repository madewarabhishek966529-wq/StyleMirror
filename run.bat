@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   StyleMirror - Auto Full-Stack Launcher
echo ===================================================

:: Check if backend is already listening on port 8000
netstat -ano | findstr /R ":8000.*LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] FastAPI backend is already running on port 8000.
) else (
    echo [..] Starting StyleMirror FastAPI backend in background...
    set "PYTHONPATH=%~dp0backend"
    start "StyleMirror Backend" /b python -m uvicorn app.main:app --app-dir "%~dp0backend" --host 0.0.0.0 --port 8000
    timeout /t 2 /nobreak >nul
    echo [OK] Backend started on http://127.0.0.1:8000
)

echo [..] Starting Flutter app...
flutter run %*

