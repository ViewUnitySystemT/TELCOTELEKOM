@echo off
REM ==========================================
REM PeerLink - Produktions-Setup (3-Befehle)
REM Öffentliche Domain mit HTTPS/WSS + TURN
REM ==========================================

echo.
echo 🚀 PeerLink Produktions-Setup
echo =============================
echo.

REM Prüfe ob .env Datei existiert
if not exist .env (
    echo ❌ .env Datei nicht gefunden!
    echo.
    echo 📝 Erstelle .env aus env-example.txt...
    copy env-example.txt .env
    echo.
    echo ⚠️  WICHTIG: Bearbeite .env und setze deine Domain-Konfiguration:
    echo    - DOMAIN=deine-domain.com
    echo    - LE_EMAIL=deine-email@domain.com
    echo    - TURN_DOMAIN=turn.deine-domain.com
    echo    - TURN_PASSWORD=super-strong-secret
    echo.
    pause
    exit /b 1
)

echo ✅ .env Datei gefunden
echo.

REM Lade Umgebungsvariablen
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    if not "%%a"=="" if not "%%a:~0,1%"=="#" (
        set "%%a=%%b"
    )
)

echo 📋 Konfiguration:
echo    Domain: %DOMAIN%
echo    TURN Domain: %TURN_DOMAIN%
echo    Public URL: %PUBLIC_URL%
echo.

REM Prüfe DNS-Konfiguration
echo 🔍 Prüfe DNS-Konfiguration...
nslookup %DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ❌ DNS-Lookup für %DOMAIN% fehlgeschlagen!
    echo    Stelle sicher, dass A/AAAA Records auf deinen Server zeigen.
    pause
    exit /b 1
)

nslookup %TURN_DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ❌ DNS-Lookup für %TURN_DOMAIN% fehlgeschlagen!
    echo    Stelle sicher, dass A/AAAA Records auf deinen Server zeigen.
    pause
    exit /b 1
)

echo ✅ DNS-Konfiguration OK
echo.

REM Starte Docker Compose
echo 🐳 Starte Docker Compose...
docker compose -f docker-compose.prod.yml pull
if errorlevel 1 (
    echo ❌ Docker Compose Pull fehlgeschlagen!
    pause
    exit /b 1
)

docker compose -f docker-compose.prod.yml up -d
if errorlevel 1 (
    echo ❌ Docker Compose Start fehlgeschlagen!
    pause
    exit /b 1
)

echo ✅ Docker Compose gestartet
echo.

REM Kurzcheck
echo 🔍 Kurzcheck...
timeout /t 10 /nobreak >nul

echo 📡 Teste HTTPS-Verbindung...
curl -I https://%DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ⚠️  HTTPS-Test fehlgeschlagen (normal bei erstem Start)
    echo    Warte auf Let's Encrypt Zertifikat...
) else (
    echo ✅ HTTPS-Verbindung OK
)

echo.
echo 🎉 Setup abgeschlossen!
echo.
echo 📋 Services:
echo    - PeerLink App: https://%DOMAIN%
echo    - Traefik Dashboard: https://traefik.%DOMAIN%
echo    - LiveKit SFU: https://sfu.%DOMAIN%
echo    - TURN Server: %TURN_DOMAIN%:3478
echo.
echo 🔧 Nützliche Befehle:
echo    - Status: docker compose -f docker-compose.prod.yml ps
echo    - Logs: docker compose -f docker-compose.prod.yml logs -f
echo    - Stoppen: docker compose -f docker-compose.prod.yml down
echo.
pause
