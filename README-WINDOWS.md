# PeerLink - Windows Installation

Peer-to-Peer Kommunikation mit Text, Audio und Video - einfach und sicher

## 🚀 Schnellstart

### Voraussetzungen

Bevor du PeerLink startest, stelle sicher, dass folgende Software installiert ist:

1. **Node.js 18+**
   - Download: https://nodejs.org/
   - Nach Installation: `node --version` sollte 18+ zeigen

2. **Docker Desktop**
   - Download: https://www.docker.com/products/docker-desktop
   - Starte Docker Desktop nach der Installation

3. **Git** (optional)
   - Download: https://git-scm.com/downloads

### Installation

1. **Repository klonen oder Dateien herunterladen**
   ```bash
   git clone <repository-url>
   cd peerlink
   ```

2. **Abhängigkeiten installieren**
   ```bash
   .\start-peerlink.bat
   ```
   Das Skript prüft automatisch alle Voraussetzungen und installiert fehlende Komponenten.

## 🖥️ Verwendung

### System starten

```bash
.\start-peerlink.bat
```

Oder mit explizitem Befehl:
```bash
.\start-peerlink.bat start
```

### System stoppen

```bash
.\stop-peerlink.bat
```

### Weitere Befehle

```bash
# System neustarten
.\start-peerlink.bat restart

# Status aller Komponenten anzeigen
.\start-peerlink.bat status

# Logs des Signaling Servers anzeigen
.\start-peerlink.bat logs

# Hilfe anzeigen
.\start-peerlink.bat help
```

## 📋 System Komponenten

Nach dem Start läuft PeerLink mit folgenden Komponenten:

### Signaling Server (Node.js)
- **Port:** 8080
- **WebSocket:** `ws://localhost:8080`
- **Monitoring:** `http://localhost:8080/monitoring`
- **Health Check:** `http://localhost:8080/health`

### TURN/STUN Server (Docker)
- **TURN Server:** `turn:localhost:3478`
- **Username:** `peeruser`
- **Password:** `peerpass123`
- **STUN Server:** `stun:stun.l.google.com:19302`

### Monitoring Dashboard (Docker)
- **URL:** `http://localhost:8081`
- **Optional:** Wird automatisch gestartet, falls verfügbar

## 🌐 PeerLink verwenden

1. **Browser öffnen**
   - Gehe zu: `http://localhost:8080`
   - Oder öffne `index.html` direkt im Browser

2. **Erste Verbindung herstellen**
   - Gib einen Raum-Namen ein
   - Teile den Raum-Namen mit anderen Teilnehmern
   - Starte Text-, Audio- oder Video-Chat

## ⚙️ Konfiguration

### Umgebungsvariablen

Du kannst das System mit Umgebungsvariablen anpassen:

```bash
# Port für Signaling Server ändern
set PORT=3000

# Clustering aktivieren
set ENABLE_CLUSTER=true
set WORKER_COUNT=4

# Redis für Session-Management
set REDIS_URL=redis://localhost:6379

# MongoDB für persistente Daten
set MONGO_URL=mongodb://localhost:27017/peerlink
```

### Docker Container anpassen

Bearbeite `docker-compose.yml` für individuelle Konfigurationen:

```yaml
version: '3.8'
services:
  turn-server:
    image: peerlink/turn-server:latest
    ports:
      - "3478:3478"
    environment:
      - TURN_USERNAME=youruser
      - TURN_PASSWORD=yourpass
```

## 🔧 Fehlerbehebung

### Häufige Probleme

1. **Port 8080 belegt**
   ```bash
   # Prüfe welcher Prozess den Port verwendet
   netstat -ano | findstr :8080

   # Port freigeben oder anderen Port verwenden
   set PORT=3000
   ```

2. **Docker nicht verfügbar**
   - Stelle sicher, dass Docker Desktop läuft
   - Auf Windows: Docker Desktop muss gestartet sein

3. **Node.js Fehler**
   ```bash
   # Abhängigkeiten neu installieren
   rmdir /s /q node_modules
   npm install
   ```

4. **TURN Server nicht erreichbar**
   ```bash
   # Docker Container prüfen
   docker ps

   # Container Logs anzeigen
   docker logs peerlink-turn-server
   ```

### Logs und Debugging

```bash
# Signaling Server Logs
.\start-peerlink.bat logs

# Docker Container Logs
docker logs peerlink-turn-server
docker logs peerlink-monitoring

# System Status
.\start-peerlink.bat status
```

## 📊 Monitoring

PeerLink bietet integriertes Monitoring:

- **Health Checks:** `http://localhost:8080/health`
- **Monitoring Dashboard:** `http://localhost:8080/monitoring`
- **Container Status:** `docker ps`
- **System Logs:** `signaling.log`

## 🛑 System komplett stoppen

```bash
# Alle Komponenten stoppen
.\stop-peerlink.bat

# Docker Container bereinigen (optional)
docker system prune -f
```

## 🔒 Sicherheit

PeerLink implementiert mehrere Sicherheitsmaßnahmen:

- **HTTPS Strict Transport Security**
- **Content Security Policy**
- **X-Frame-Options**
- **Input Validation**
- **Rate Limiting**
- **IP-Blacklisting**

### Produktionsbetrieb

Für den Produktionsbetrieb:

1. **Reverse Proxy verwenden** (nginx/apache)
2. **SSL/TLS Zertifikate** installieren
3. **Firewall konfigurieren**
4. **Regelmäßige Updates** durchführen
5. **Monitoring einrichten**

## 📞 Support

Bei Problemen:

1. **Logs prüfen:** `.\start-peerlink.bat logs`
2. **Status prüfen:** `.\start-peerlink.bat status`
3. **Docker Container prüfen:** `docker ps -a`
4. **System neu starten:** `.\start-peerlink.bat restart`

## 📝 Lizenz

Dieses Projekt ist unter der MIT-Lizenz veröffentlicht.

---

**PeerLink** - Sichere P2P Kommunikation für alle
