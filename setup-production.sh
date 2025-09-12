#!/bin/bash

# ==========================================
# PeerLink - Produktions-Setup (3-Befehle)
# Öffentliche Domain mit HTTPS/WSS + TURN
# ==========================================

echo ""
echo "🚀 PeerLink Produktions-Setup"
echo "============================="
echo ""

# Prüfe ob .env Datei existiert
if [ ! -f .env ]; then
    echo "❌ .env Datei nicht gefunden!"
    echo ""
    echo "📝 Erstelle .env aus env-example.txt..."
    cp env-example.txt .env
    echo ""
    echo "⚠️  WICHTIG: Bearbeite .env und setze deine Domain-Konfiguration:"
    echo "   - DOMAIN=deine-domain.com"
    echo "   - LE_EMAIL=deine-email@domain.com"
    echo "   - TURN_DOMAIN=turn.deine-domain.com"
    echo "   - TURN_PASSWORD=super-strong-secret"
    echo ""
    read -p "Drücke Enter nach der Konfiguration..."
    exit 1
fi

echo "✅ .env Datei gefunden"
echo ""

# Lade Umgebungsvariablen
source .env

echo "📋 Konfiguration:"
echo "   Domain: $DOMAIN"
echo "   TURN Domain: $TURN_DOMAIN"
echo "   Public URL: $PUBLIC_URL"
echo ""

# Prüfe DNS-Konfiguration
echo "🔍 Prüfe DNS-Konfiguration..."
if ! nslookup $DOMAIN >/dev/null 2>&1; then
    echo "❌ DNS-Lookup für $DOMAIN fehlgeschlagen!"
    echo "   Stelle sicher, dass A/AAAA Records auf deinen Server zeigen."
    exit 1
fi

if ! nslookup $TURN_DOMAIN >/dev/null 2>&1; then
    echo "❌ DNS-Lookup für $TURN_DOMAIN fehlgeschlagen!"
    echo "   Stelle sicher, dass A/AAAA Records auf deinen Server zeigen."
    exit 1
fi

echo "✅ DNS-Konfiguration OK"
echo ""

# Starte Docker Compose
echo "🐳 Starte Docker Compose..."
if ! docker compose -f docker-compose.prod.yml pull; then
    echo "❌ Docker Compose Pull fehlgeschlagen!"
    exit 1
fi

if ! docker compose -f docker-compose.prod.yml up -d; then
    echo "❌ Docker Compose Start fehlgeschlagen!"
    exit 1
fi

echo "✅ Docker Compose gestartet"
echo ""

# Kurzcheck
echo "🔍 Kurzcheck..."
sleep 10

echo "📡 Teste HTTPS-Verbindung..."
if ! curl -I https://$DOMAIN >/dev/null 2>&1; then
    echo "⚠️  HTTPS-Test fehlgeschlagen (normal bei erstem Start)"
    echo "   Warte auf Let's Encrypt Zertifikat..."
else
    echo "✅ HTTPS-Verbindung OK"
fi

echo ""
echo "🎉 Setup abgeschlossen!"
echo ""
echo "📋 Services:"
echo "   - PeerLink App: https://$DOMAIN"
echo "   - Traefik Dashboard: https://traefik.$DOMAIN"
echo "   - LiveKit SFU: https://sfu.$DOMAIN"
echo "   - TURN Server: $TURN_DOMAIN:3478"
echo ""
echo "🔧 Nützliche Befehle:"
echo "   - Status: docker compose -f docker-compose.prod.yml ps"
echo "   - Logs: docker compose -f docker-compose.prod.yml logs -f"
echo "   - Stoppen: docker compose -f docker-compose.prod.yml down"
echo ""
