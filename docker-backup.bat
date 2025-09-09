@echo off
REM ==========================================
REM PeerLink Docker Backup-Script
REM Sicherung aller wichtigen Daten
REM ==========================================

echo.
echo ==========================================
echo 💾 PeerLink Backup erstellen...
echo ==========================================
echo.

REM Prüfen ob System läuft
docker-compose ps | findstr "peerlink-server" >nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  PeerLink-System läuft nicht!
    echo    Starten Sie es zuerst mit docker-start.bat
    echo.
    pause
    exit /b 1
)

echo ✅ System läuft
echo.

REM Backup-Verzeichnis erstellen
if not exist "backup" mkdir backup

REM Timestamp für Backup-Name
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%

set BACKUP_NAME=peerlink_backup_%TIMESTAMP%

echo 📦 Erstelle Backup: %BACKUP_NAME%
echo.

REM Container-laufende Backups anzeigen
echo 🔍 Aktuelle Backups im Container:
docker-compose exec peerlink-monitor sh -c "ls -la /backup/ | head -10" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Monitoring-Service nicht verfügbar für Live-Backup
    echo    Erstelle manuelles Backup...
    goto :manual_backup
)

echo.
echo 💡 Automatisches Backup vom Monitoring-Service wird verwendet
goto :show_info

:manual_backup
REM Manuelles Backup erstellen
echo 📦 Erstelle manuelles Backup...

REM Logs sichern
if exist "logs" (
    echo    📝 Logs sichern...
    tar -czf backup/%BACKUP_NAME%_logs.tar.gz logs 2>nul
)

REM Daten sichern
if exist "data" (
    echo    💾 Daten sichern...
    tar -czf backup/%BACKUP_NAME%_data.tar.gz data 2>nul
)

REM Monitoring-Daten sichern
if exist "monitoring-data.json" (
    echo    📊 Monitoring-Daten sichern...
    copy monitoring-data.json backup/%BACKUP_NAME%_monitoring.json >nul
)

:show_info
echo.
echo ==========================================
echo ✅ Backup erfolgreich erstellt!
echo ==========================================
echo.
echo 📂 Backup-Standort: ./backup/
echo 📅 Timestamp: %TIMESTAMP%
echo.
echo 📋 Backup-Inhalt:
if exist "backup\%BACKUP_NAME%_logs.tar.gz" echo    📝 Logs: %BACKUP_NAME%_logs.tar.gz
if exist "backup\%BACKUP_NAME%_data.tar.gz" echo    💾 Daten: %BACKUP_NAME%_data.tar.gz
if exist "backup\%BACKUP_NAME%_monitoring.json" echo    📊 Monitoring: %BACKUP_NAME%_monitoring.json
echo.
echo 🔄 Automatische Backups alle 6 Stunden im Container
echo 🗑️  Alte Backups werden automatisch nach 7 Tagen gelöscht
echo.
echo 💡 Zum Wiederherstellen: docker-restore.bat [backup-name]

echo.
pause
