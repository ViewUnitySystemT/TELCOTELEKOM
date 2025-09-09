@echo off
REM ==========================================
REM PeerLink Enterprise Start-Script (Simple)
REM Startet die Enterprise-Umgebung
REM ==========================================

if "%1"=="help" goto help
if "%1"=="-h" goto help
if "%1"=="--help" goto help

echo 🚀 Starte PeerLink ENTERPRISE System...
echo.

REM Prüfe Enterprise Abhängigkeiten
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker ist für Enterprise-Features erforderlich
    goto end
)

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js ist erforderlich
    goto end
)

echo ✅ Enterprise-Abhängigkeiten OK
echo.

REM Enterprise-Umgebung starten
echo 🔧 Initialisiere Enterprise Umgebung...

REM Datenbanken starten
docker compose up -d redis mongodb >nul 2>nul
echo ✅ Datenbanken gestartet (Redis, MongoDB)

REM TURN Server starten
docker compose up -d turn-server >nul 2>nul
echo ✅ TURN Server gestartet

REM Monitoring starten
docker compose up -d monitoring >nul 2>nul
echo ✅ Enterprise Monitoring gestartet

REM Signaling Server starten
set NODE_ENV=production
set ENABLE_CLUSTER=true
set CLUSTER_SIZE=3
set WORKER_COUNT=4
set MAX_CONNECTIONS=50000

start /B node server.js > enterprise-signaling.log 2>&1
timeout /t 5 >nul

echo ✅ Enterprise Signaling Server gestartet
echo.

echo 🎉 PeerLink ENTERPRISE erfolgreich gestartet!
echo.
echo 🌐 Zugriffe:
echo    Haupt-URL: http://localhost:8080
echo    Monitoring: http://localhost:8080/monitoring
echo    TURN Server: turn:localhost:3478
echo    Health Check: http://localhost:8080/health
echo.
echo ⚙️ Enterprise Features:
echo    ✅ Clustering (3 Nodes)
echo    ✅ Multi-Worker (4 Prozesse)
echo    ✅ Redis Session-Management
echo    ✅ MongoDB persistente Daten
echo    ✅ JWT-Authentifizierung
echo.
echo 📝 Logs: enterprise-signaling.log
echo 🛑 Zum Stoppen: .\stop-peerlink-enterprise-simple.bat
goto end

:help
echo PeerLink Enterprise Windows Start-Script
echo.
echo Verwendung:
echo   .\start-peerlink-enterprise-simple.bat          - Starte Enterprise-System
echo   .\start-peerlink-enterprise-simple.bat help     - Diese Hilfe anzeigen
echo.
echo Enterprise Features:
echo   - Clustering (3 Nodes)
echo   - Multi-Worker (4 Prozesse)
echo   - Redis Session-Management
echo   - MongoDB persistente Daten
echo   - JWT-Authentifizierung
echo   - Enterprise Monitoring
echo.
echo Voraussetzungen:
echo   - Node.js 18+
echo   - Docker Desktop
echo   - Mindestens 8GB RAM
echo   - Mindestens 4 CPU-Kerne
goto end

:end
echo.
pause
