@echo off
REM ==========================================
REM PeerLink Windows Run-Script (Simple)
REM Startet nur den Node.js Server
REM ==========================================

if "%1"=="help" goto help
if "%1"=="-h" goto help
if "%1"=="--help" goto help

echo 🚀 Starte PeerLink Signaling Server...
echo.

REM Prüfe Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js ist nicht installiert.
    goto end
)

REM Prüfe ob Port frei ist
netstat -an | find "8080" >nul
if %ERRORLEVEL% EQU 0 (
    echo ⚠️  Port 8080 ist möglicherweise belegt. Versuche Server zu stoppen...
    taskkill /F /IM node.exe >nul 2>nul
    timeout /t 2 >nul
)

REM Server starten
start /B node server.js > signaling.log 2>&1

REM Kurz warten
timeout /t 3 >nul

REM Status prüfen
tasklist /FI "IMAGENAME eq node.exe" | find "node.exe" >nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ PeerLink Signaling Server erfolgreich gestartet!
    echo.
    echo 🌐 Öffne peerlink.html in deinem Browser
    echo 📡 WebSocket: ws://localhost:8080
    echo 📊 Monitoring: http://localhost:8080/monitoring
    echo 💚 Health Check: http://localhost:8080/health
    echo 📝 Logs: signaling.log
    echo.
    echo 🛑 Zum Stoppen: taskkill /F /IM node.exe
) else (
    echo ❌ Fehler beim Starten des Servers
    echo    Prüfe signaling.log für Details
)
goto end

:help
echo PeerLink Windows Run-Script
echo.
echo Verwendung:
echo   .\run-peerlink-simple.bat          - Starte den Server
echo   .\run-peerlink-simple.bat help     - Diese Hilfe anzeigen
echo.
echo Startet:
echo   - WebRTC Signaling Server (Port 8080)
echo   - Erstellt Log-Datei: signaling.log
goto end

:end
echo.
pause
