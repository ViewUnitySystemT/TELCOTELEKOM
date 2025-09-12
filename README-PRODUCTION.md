# PeerLink - Produktions-Setup

## 🚀 3-Befehle-Setup für öffentliche Domain

### Voraussetzungen

1. **Domain-Konfiguration**: A/AAAA Records für deine Domain und TURN-Subdomain
2. **Docker & Docker Compose** installiert
3. **Ports freigeben**: 80, 443, 3478, 49160-49200 (UDP), 7881 (UDP)

### Schritt 1: Domain-Konfiguration

```bash
# DNS-Records setzen:
# example.com → deine-server-ip
# turn.example.com → deine-server-ip
```

### Schritt 2: Umgebungsvariablen

```bash
# .env Datei erstellen (aus env-example.txt kopieren)
cp env-example.txt .env

# .env bearbeiten:
DOMAIN=example.com
LE_EMAIL=you@example.com
TURN_DOMAIN=turn.example.com
TURN_PASSWORD=super-strong-secret-change-this
```

### Schritt 3: Starten

**Windows:**
```cmd
setup-production.bat
```

**Linux/macOS:**
```bash
./setup-production.sh
```

**Manuell:**
```bash
# 1) DNS prüfen
nslookup example.com
nslookup turn.example.com

# 2) Compose starten
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d

# 3) Kurzcheck
curl -I https://example.com
```

## 📋 Services

Nach dem Setup sind folgende Services verfügbar:

- **PeerLink App**: `https://example.com`
- **Traefik Dashboard**: `https://traefik.example.com`
- **LiveKit SFU**: `https://sfu.example.com`
- **TURN Server**: `turn.example.com:3478`

## 🔧 Verwaltung

```bash
# Status prüfen
docker compose -f docker-compose.prod.yml ps

# Logs anzeigen
docker compose -f docker-compose.prod.yml logs -f

# Stoppen
docker compose -f docker-compose.prod.yml down

# Neu starten
docker compose -f docker-compose.prod.yml restart
```

## 🛠️ Konfiguration

### TURN-Server

Der TURN-Server läuft auf Port 3478 (UDP/TCP) und verwendet die Relay-Ports 49160-49200.

**TLS aktivieren:**
```yaml
# In docker-compose.prod.yml coturn service:
command:
  - --cert=/path/fullchain.pem
  - --pkey=/path/privkey.pem
  - --listening-port=${TURN_PORT}
  - --tls-listening-port=${TURNS_PORT}
```

### LiveKit SFU

Für größere Gruppen (>4 Teilnehmer) wird automatisch der LiveKit SFU verwendet.

**Konfiguration:**
- **WebSocket URL**: `wss://sfu.example.com`
- **API Key**: `mykey`
- **API Secret**: `mysecret`

### Traefik

Automatische HTTPS-Zertifikate via Let's Encrypt.

**Dashboard**: `https://traefik.example.com`

## 🔒 Sicherheit

- **HTTPS**: Automatische Let's Encrypt Zertifikate
- **WSS**: Verschlüsselte WebSocket-Verbindungen
- **TURN**: Authentifizierte TURN-Server
- **Rate Limiting**: Schutz vor Missbrauch
- **IP-Blacklist**: Blockierung schädlicher IPs

## 📊 Monitoring

- **Health Checks**: Automatische Überwachung aller Services
- **Backups**: Automatische Backups alle 6 Stunden
- **Logs**: Zentrale Log-Sammlung
- **Metriken**: Verbindungsstatistiken

## 🚨 Troubleshooting

### Let's Encrypt Zertifikat

```bash
# Zertifikat-Status prüfen
docker logs peerlink-traefik | grep acme

# Manuell erneuern
docker compose -f docker-compose.prod.yml restart traefik
```

### TURN-Server

```bash
# TURN-Server testen
nc -vz -u turn.example.com 3478

# Logs prüfen
docker logs peerlink-coturn
```

### WebSocket-Verbindung

```bash
# WebSocket-Test
wscat -c wss://example.com
```

## 🔄 Updates

```bash
# Images aktualisieren
docker compose -f docker-compose.prod.yml pull

# Services neu starten
docker compose -f docker-compose.prod.yml up -d
```

## 📈 Skalierung

### Horizontal Scaling

```yaml
# Mehrere PeerLink-Instanzen
peerlink-server:
  deploy:
    replicas: 3
```

### Load Balancer

```yaml
# Nginx Load Balancer vor Traefik
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
    - "443:443"
```

## 🆘 Support

Bei Problemen:

1. **Logs prüfen**: `docker compose -f docker-compose.prod.yml logs`
2. **Status prüfen**: `docker compose -f docker-compose.prod.yml ps`
3. **Health Checks**: `curl https://example.com/health`
4. **TURN-Test**: `nc -vz -u turn.example.com 3478`

---

**🎉 Viel Erfolg mit deiner PeerLink-Produktionsumgebung!**
