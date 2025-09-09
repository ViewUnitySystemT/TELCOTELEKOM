@echo off
REM ==========================================
REM PeerLink Windows Start-Script (Vollständig)
REM Startet alle Komponenten des Systems
REM ==========================================

if "%1"=="help" goto help
if "%1"=="-h" goto help
if "%1"=="--help" goto help
if "%1"=="stop" goto stop_system
if "%1"=="restart" goto restart_system

echo 🚀 Starte PeerLink P2P Kommunikationssystem...
echo.

REM ==========================================
REM Schnellstart-Modus wenn Server bereits läuft
REM ==========================================

curl -s http://localhost:8080/ >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Server läuft bereits auf Port 8080
    echo.
    goto success
)

REM ==========================================
REM Abhängigkeitsprüfung
REM ==========================================

echo 📋 Prüfe Abhängigkeiten...

where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Docker ist nicht installiert.
    echo    Download: https://www.docker.com/products/docker-desktop
    goto end
)

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js ist nicht installiert.
    echo    Download: https://nodejs.org/
    goto end
)

echo ✅ Abhängigkeiten OK
echo.

REM ==========================================
REM Docker Services starten
REM ==========================================

echo 🔄 Starte Docker Services...

REM TURN/STUN Server
echo   📡 Starte TURN Server...
docker compose up -d turn-server >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ TURN Server gestartet
) else (
    echo   ⚠️  TURN Server nicht verfügbar
)

REM Monitoring
echo   📊 Starte Monitoring...
docker compose up -d monitoring >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ Monitoring gestartet
) else (
    echo   ⚠️  Monitoring nicht verfügbar
)

REM ==========================================
REM Signaling Server starten
REM ==========================================

echo 📡 Starte Signaling Server...

REM Port-Konflikte prüfen
netstat -an | find "8080" >nul
if %ERRORLEVEL% EQU 0 (
    echo   ⚠️  Port 8080 belegt - Stoppe bestehende Prozesse...
    taskkill /F /IM node.exe >nul 2>nul
    timeout /t 2 >nul
)

REM Server im Hintergrund starten
start /B node server.js > signaling.log 2>&1

REM Warten und Status prüfen
timeout /t 3 >nul

tasklist /FI "IMAGENAME eq node.exe" | find "node.exe" >nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ Signaling Server gestartet
    goto success
) else (
    echo   ❌ Signaling Server konnte nicht gestartet werden
    echo   Prüfe signaling.log für Details
    goto end
)

:success
echo.
echo 🎉 PeerLink System erfolgreich gestartet!
echo.
echo 🌐 Zugriff:
echo   📄 Hauptseite:    http://localhost:8080
echo   🔌 WebSocket:     ws://localhost:8080
echo   📊 Monitoring:    http://localhost:8080/monitoring
echo   💚 Health Check:  http://localhost:8080/health
echo.
echo 📝 Logs: signaling.log
echo.
echo 🛑 Zum Stoppen:
echo   .\start-peerlink-simple.bat stop
echo.
echo 💡 Tipp: Öffne peerlink.html in deinem Browser
goto end

:stop_system
echo 🛑 Stoppe PeerLink System...

REM Signaling Server stoppen
taskkill /F /IM node.exe >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Signaling Server gestoppt
) else (
    echo ⚠️  Kein Signaling Server gefunden
)

REM Docker Container stoppen
docker compose down >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Docker Services gestoppt
) else (
    echo ⚠️  Keine Docker Services gefunden
)

echo ✅ System vollständig gestoppt
goto end

:restart_system
echo 🔄 Neustart PeerLink System...
call :stop_system
echo.
timeout /t 3 >nul
REM Neustart durch erneuten Aufruf
.\start-peerlink-simple.bat

:help
echo PeerLink Windows Start-Script (Vollständig)
echo.
echo Verwendung:
echo   .\start-peerlink-simple.bat           - Starte das komplette System
echo   .\start-peerlink-simple.bat stop      - Stoppe das komplette System
echo   .\start-peerlink-simple.bat restart   - Neustart des Systems
echo   .\start-peerlink-simple.bat help      - Diese Hilfe anzeigen
echo.
echo Komponenten:
echo   ✅ WebRTC Signaling Server (Node.js)
echo   ✅ TURN/STUN Server (Docker)
echo   ✅ Monitoring Dashboard (Docker)
echo   ✅ Vollständige P2P-Kommunikation
echo.
echo Voraussetzungen:
echo   - Node.js 18+
echo   - Docker Desktop
echo   - Windows 10/11
echo.
echo Ports:
echo   - 8080: Signaling Server
echo   - 3478: TURN/STUN Server
echo   - 8081: Monitoring (optional)
goto end

:end
echo.
pause
