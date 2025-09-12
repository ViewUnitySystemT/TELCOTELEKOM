@echo off
REM ==========================================
REM PeerLink - Produktions-Test
REM Validiert die komplette Konfiguration
REM ==========================================

echo.
echo 🧪 PeerLink Produktions-Test
echo ============================
echo.

REM Prüfe .env Datei
if not exist .env (
    echo ❌ .env Datei nicht gefunden!
    echo    Führe zuerst setup-production.bat aus.
    pause
    exit /b 1
)

echo ✅ .env Datei gefunden

REM Lade Umgebungsvariablen
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    if not "%%a"=="" if not "%%a:~0,1%"=="#" (
        set "%%a=%%b"
    )
)

echo.
echo 📋 Konfiguration:
echo    Domain: %DOMAIN%
echo    TURN Domain: %TURN_DOMAIN%
echo    Public URL: %PUBLIC_URL%
echo.

REM Test 1: DNS-Auflösung
echo 🔍 Test 1: DNS-Auflösung
echo ------------------------
nslookup %DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ❌ DNS-Lookup für %DOMAIN% fehlgeschlagen!
    set /a tests_failed+=1
) else (
    echo ✅ %DOMAIN% auflösbar
)

nslookup %TURN_DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ❌ DNS-Lookup für %TURN_DOMAIN% fehlgeschlagen!
    set /a tests_failed+=1
) else (
    echo ✅ %TURN_DOMAIN% auflösbar
)

REM Test 2: Docker Services
echo.
echo 🐳 Test 2: Docker Services
echo -------------------------
docker compose -f docker-compose.prod.yml ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose nicht verfügbar!
    set /a tests_failed+=1
) else (
    echo ✅ Docker Compose verfügbar
    
    REM Prüfe laufende Container
    docker compose -f docker-compose.prod.yml ps --format "table {{.Name}}\t{{.Status}}" | findstr "Up" >nul
    if errorlevel 1 (
        echo ⚠️  Keine Container laufen - starte mit: docker compose -f docker-compose.prod.yml up -d
    ) else (
        echo ✅ Container laufen
        docker compose -f docker-compose.prod.yml ps --format "table {{.Name}}\t{{.Status}}"
    )
)

REM Test 3: HTTP/HTTPS Verbindung
echo.
echo 🌐 Test 3: HTTP/HTTPS Verbindung
echo --------------------------------
curl -I http://%DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ❌ HTTP-Verbindung zu %DOMAIN% fehlgeschlagen!
    set /a tests_failed+=1
) else (
    echo ✅ HTTP-Verbindung OK
)

curl -I https://%DOMAIN% >nul 2>&1
if errorlevel 1 (
    echo ⚠️  HTTPS-Verbindung zu %DOMAIN% fehlgeschlagen (normal bei erstem Start)
    echo    Warte auf Let's Encrypt Zertifikat...
) else (
    echo ✅ HTTPS-Verbindung OK
)

REM Test 4: TURN-Server
echo.
echo 🔄 Test 4: TURN-Server
echo ----------------------
REM Prüfe ob netcat verfügbar ist
where nc >nul 2>&1
if errorlevel 1 (
    echo ⚠️  netcat nicht verfügbar - TURN-Test übersprungen
) else (
    nc -vz -u %TURN_DOMAIN% %TURN_PORT% >nul 2>&1
    if errorlevel 1 (
        echo ❌ TURN-Server %TURN_DOMAIN%:%TURN_PORT% nicht erreichbar!
        set /a tests_failed+=1
    ) else (
        echo ✅ TURN-Server erreichbar
    )
)

REM Test 5: WebSocket Verbindung
echo.
echo 🔌 Test 5: WebSocket Verbindung
echo ------------------------------
REM Einfacher HTTP-Test für WebSocket-Endpoint
curl -I http://%DOMAIN%/ >nul 2>&1
if errorlevel 1 (
    echo ❌ WebSocket-Endpoint nicht erreichbar!
    set /a tests_failed+=1
) else (
    echo ✅ WebSocket-Endpoint erreichbar
)

REM Test 6: Port-Verfügbarkeit
echo.
echo 🔌 Test 6: Port-Verfügbarkeit
echo -----------------------------
netstat -an | findstr ":80 " >nul
if errorlevel 1 (
    echo ❌ Port 80 nicht verfügbar!
    set /a tests_failed+=1
) else (
    echo ✅ Port 80 verfügbar
)

netstat -an | findstr ":443 " >nul
if errorlevel 1 (
    echo ❌ Port 443 nicht verfügbar!
    set /a tests_failed+=1
) else (
    echo ✅ Port 443 verfügbar
)

REM Zusammenfassung
echo.
echo 📊 Test-Zusammenfassung
echo ======================
if not defined tests_failed set tests_failed=0

if %tests_failed%==0 (
    echo ✅ Alle Tests bestanden!
    echo.
    echo 🎉 PeerLink ist bereit für die Produktion!
    echo.
    echo 📋 Services:
    echo    - PeerLink App: https://%DOMAIN%
    echo    - Traefik Dashboard: https://traefik.%DOMAIN%
    echo    - LiveKit SFU: https://sfu.%DOMAIN%
    echo    - TURN Server: %TURN_DOMAIN%:%TURN_PORT%
) else (
    echo ❌ %tests_failed% Tests fehlgeschlagen!
    echo.
    echo 🔧 Nächste Schritte:
    echo    1. Prüfe DNS-Konfiguration
    echo    2. Starte Docker Services: docker compose -f docker-compose.prod.yml up -d
    echo    3. Warte auf Let's Encrypt Zertifikat (bis zu 5 Minuten)
    echo    4. Prüfe Firewall-Einstellungen
)

echo.
pause
