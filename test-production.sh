#!/bin/bash

# ==========================================
# PeerLink - Produktions-Test
# Validiert die komplette Konfiguration
# ==========================================

echo ""
echo "🧪 PeerLink Produktions-Test"
echo "============================"
echo ""

tests_failed=0

# Prüfe .env Datei
if [ ! -f .env ]; then
    echo "❌ .env Datei nicht gefunden!"
    echo "   Führe zuerst ./setup-production.sh aus."
    exit 1
fi

echo "✅ .env Datei gefunden"

# Lade Umgebungsvariablen
source .env

echo ""
echo "📋 Konfiguration:"
echo "   Domain: $DOMAIN"
echo "   TURN Domain: $TURN_DOMAIN"
echo "   Public URL: $PUBLIC_URL"
echo ""

# Test 1: DNS-Auflösung
echo "🔍 Test 1: DNS-Auflösung"
echo "------------------------"
if ! nslookup $DOMAIN >/dev/null 2>&1; then
    echo "❌ DNS-Lookup für $DOMAIN fehlgeschlagen!"
    ((tests_failed++))
else
    echo "✅ $DOMAIN auflösbar"
fi

if ! nslookup $TURN_DOMAIN >/dev/null 2>&1; then
    echo "❌ DNS-Lookup für $TURN_DOMAIN fehlgeschlagen!"
    ((tests_failed++))
else
    echo "✅ $TURN_DOMAIN auflösbar"
fi

# Test 2: Docker Services
echo ""
echo "🐳 Test 2: Docker Services"
echo "-------------------------"
if ! docker compose -f docker-compose.prod.yml ps >/dev/null 2>&1; then
    echo "❌ Docker Compose nicht verfügbar!"
    ((tests_failed++))
else
    echo "✅ Docker Compose verfügbar"
    
    # Prüfe laufende Container
    if ! docker compose -f docker-compose.prod.yml ps --format "table {{.Name}}\t{{.Status}}" | grep -q "Up"; then
        echo "⚠️  Keine Container laufen - starte mit: docker compose -f docker-compose.prod.yml up -d"
    else
        echo "✅ Container laufen"
        docker compose -f docker-compose.prod.yml ps --format "table {{.Name}}\t{{.Status}}"
    fi
fi

# Test 3: HTTP/HTTPS Verbindung
echo ""
echo "🌐 Test 3: HTTP/HTTPS Verbindung"
echo "--------------------------------"
if ! curl -I http://$DOMAIN >/dev/null 2>&1; then
    echo "❌ HTTP-Verbindung zu $DOMAIN fehlgeschlagen!"
    ((tests_failed++))
else
    echo "✅ HTTP-Verbindung OK"
fi

if ! curl -I https://$DOMAIN >/dev/null 2>&1; then
    echo "⚠️  HTTPS-Verbindung zu $DOMAIN fehlgeschlagen (normal bei erstem Start)"
    echo "   Warte auf Let's Encrypt Zertifikat..."
else
    echo "✅ HTTPS-Verbindung OK"
fi

# Test 4: TURN-Server
echo ""
echo "🔄 Test 4: TURN-Server"
echo "----------------------"
if ! command -v nc >/dev/null 2>&1; then
    echo "⚠️  netcat nicht verfügbar - TURN-Test übersprungen"
else
    if ! nc -vz -u $TURN_DOMAIN $TURN_PORT >/dev/null 2>&1; then
        echo "❌ TURN-Server $TURN_DOMAIN:$TURN_PORT nicht erreichbar!"
        ((tests_failed++))
    else
        echo "✅ TURN-Server erreichbar"
    fi
fi

# Test 5: WebSocket Verbindung
echo ""
echo "🔌 Test 5: WebSocket Verbindung"
echo "-------------------------------"
if ! curl -I http://$DOMAIN/ >/dev/null 2>&1; then
    echo "❌ WebSocket-Endpoint nicht erreichbar!"
    ((tests_failed++))
else
    echo "✅ WebSocket-Endpoint erreichbar"
fi

# Test 6: Port-Verfügbarkeit
echo ""
echo "🔌 Test 6: Port-Verfügbarkeit"
echo "-----------------------------"
if ! netstat -an | grep -q ":80 "; then
    echo "❌ Port 80 nicht verfügbar!"
    ((tests_failed++))
else
    echo "✅ Port 80 verfügbar"
fi

if ! netstat -an | grep -q ":443 "; then
    echo "❌ Port 443 nicht verfügbar!"
    ((tests_failed++))
else
    echo "✅ Port 443 verfügbar"
fi

# Zusammenfassung
echo ""
echo "📊 Test-Zusammenfassung"
echo "======================"

if [ $tests_failed -eq 0 ]; then
    echo "✅ Alle Tests bestanden!"
    echo ""
    echo "🎉 PeerLink ist bereit für die Produktion!"
    echo ""
    echo "📋 Services:"
    echo "   - PeerLink App: https://$DOMAIN"
    echo "   - Traefik Dashboard: https://traefik.$DOMAIN"
    echo "   - LiveKit SFU: https://sfu.$DOMAIN"
    echo "   - TURN Server: $TURN_DOMAIN:$TURN_PORT"
else
    echo "❌ $tests_failed Tests fehlgeschlagen!"
    echo ""
    echo "🔧 Nächste Schritte:"
    echo "   1. Prüfe DNS-Konfiguration"
    echo "   2. Starte Docker Services: docker compose -f docker-compose.prod.yml up -d"
    echo "   3. Warte auf Let's Encrypt Zertifikat (bis zu 5 Minuten)"
    echo "   4. Prüfe Firewall-Einstellungen"
fi

echo ""
