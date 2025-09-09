@echo off
REM ==========================================
REM PeerLink Docker Status-Script
REM Vollständiger System-Status
REM ==========================================

echo.
echo ==========================================
echo 📊 PeerLink System-Status
echo ==========================================
echo.

echo 🔍 Docker-Container Status:
docker-compose ps
echo.

echo 💾 Volume-Status:
echo 📁 Logs:       .\logs\
if exist "logs" (
    dir /b logs 2>nul | find /c "." >nul
    if %ERRORLEVEL% EQU 0 (
        echo    ✅ Enthält Dateien
    ) else (
        echo    📭 Leer
    )
) else (
    echo    ❌ Verzeichnis nicht gefunden
)

echo 📁 Daten:      .\data\
if exist "data" (
    dir /b data 2>nul | find /c "." >nul
    if %ERRORLEVEL% EQU 0 (
        echo    ✅ Enthält Dateien
    ) else (
        echo    📭 Leer
    )
) else (
    echo    ❌ Verzeichnis nicht gefunden
)

echo 📁 Backups:    .\backup\
if exist "backup" (
    dir /b backup 2>nul | find /c "." >nul
    if %ERRORLEVEL% EQU 0 (
        for /f %%c in ('dir /b backup ^| find /c "."') do set COUNT=%%c
        echo    ✅ %COUNT% Backup-Dateien
    ) else (
        echo    📭 Keine Backups
    )
) else (
    echo    ❌ Verzeichnis nicht gefunden
)

echo 📄 Monitoring: .\monitoring-data.json
if exist "monitoring-data.json" (
    for %%A in (monitoring-data.json) do echo    ✅ %%~zA Bytes
) else (
    echo    ❌ Datei nicht gefunden
)

echo.
echo 🌐 Netzwerk-Status:
curl -s -o /dev/null -w "HTTP-Status: %%{http_code}\n" http://localhost:8080/health 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Server nicht erreichbar
)

echo.
echo 💽 Speicher-Status:
docker system df 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker-Statistiken nicht verfügbar
)

echo.
echo ==========================================
echo 💡 Verfügbare Befehle:
echo ==========================================
echo 🚀 Starten:    docker-start.bat
echo 🛑 Stoppen:    docker-stop.bat
echo 💾 Backup:     docker-backup.bat
echo 🔄 Restore:    docker-restore.bat [name]
echo 🔄 Update:     docker-update.bat
echo 📊 Status:     docker-status.bat (dieses Script)
echo.

pause
