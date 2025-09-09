@echo off
REM ==========================================
REM PeerLink Docker Stop-Script
REM Sicher und sauber stoppen
REM ==========================================

echo.
echo ==========================================
echo 🛑 PeerLink Docker-System stoppen...
echo ==========================================
echo.

REM System stoppen
echo 🔄 Stoppe alle Container...
docker-compose down

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo ✅ PeerLink-System erfolgreich gestoppt!
    echo ==========================================
    echo.
    echo 💾 Ihre Daten bleiben sicher in den Volumes gespeichert:
    echo    📁 Logs:         ./logs/
    echo    📁 Daten:        ./data/
    echo    📁 Backups:      ./backup/
    echo    📄 Monitoring:   ./monitoring-data.json
    echo.
    echo 🚀 Zum Neustarten: docker-start.bat
    echo 🔄 Für Updates:    docker-update.bat

) else (
    echo.
    echo ❌ Fehler beim Stoppen des Systems!
    echo.
    echo 💡 Versuchen Sie manuell:
    echo    docker-compose down --remove-orphans
)

echo.
pause
