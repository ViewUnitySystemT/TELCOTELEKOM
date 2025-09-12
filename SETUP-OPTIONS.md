# PeerLink - Setup-Optionen Übersicht

## 🎯 **Verfügbare Konfigurationen**

### 1. **Lokale Entwicklung** 
```bash
docker compose up -d
```
- Nur PeerLink Server
- Lokale Traefik-Konfiguration
- Keine HTTPS/TURN

### 2. **Produktion mit LiveKit SFU** ⭐ **EMPFOHLEN**
```bash
docker compose -f docker-compose.prod.yml up -d
```
- ✅ HTTPS/WSS mit Let's Encrypt
- ✅ Coturn TURN-Server
- ✅ LiveKit SFU für große Gruppen
- ✅ Automatische Backups
- ✅ Monitoring

### 3. **Produktion mit Mediasoup SFU** 🔧 **FÜR ENTWICKLER**
```bash
docker compose -f docker-compose.mediasoup.yml up -d
```
- ✅ HTTPS/WSS mit Let's Encrypt
- ✅ Coturn TURN-Server
- ✅ Mediasoup SFU (maximale Kontrolle)
- ✅ Redis für Clustering
- ✅ RTP-Ports 40000-40100

---

## 🚀 **3-Befehle-Setup (Alle Optionen)**

### **Option A: LiveKit (Schnell & Pragmatisch)**

```bash
# 1. DNS konfigurieren
# example.com → deine-server-ip
# turn.example.com → deine-server-ip

# 2. Umgebung einrichten
cp env-example.txt .env
# Bearbeite .env mit deiner Domain

# 3. Starten
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

### **Option B: Mediasoup (Maximale Kontrolle)**

```bash
# 1. DNS konfigurieren
# example.com → deine-server-ip
# turn.example.com → deine-server-ip

# 2. Umgebung einrichten
cp env-example.txt .env
# Bearbeite .env mit deiner Domain
# Füge hinzu: PUBLIC_IP=deine-öffentliche-ip

# 3. Starten
docker compose -f docker-compose.mediasoup.yml pull
docker compose -f docker-compose.mediasoup.yml up -d
```

---

## 📋 **Service-Übersicht**

| Service | LiveKit | Mediasoup | Ports | Beschreibung |
|---------|:-------:|:---------:|:-----:|--------------|
| **PeerLink App** | ✅ | ✅ | 8080 | Hauptanwendung |
| **Traefik** | ✅ | ✅ | 80, 443 | Reverse Proxy + HTTPS |
| **Coturn TURN** | ✅ | ✅ | 3478, 49160-49200 | NAT-Traversal |
| **LiveKit SFU** | ✅ | ❌ | 7881 | SFU für große Gruppen |
| **Mediasoup SFU** | ❌ | ✅ | 40000-40100 | SFU mit voller Kontrolle |
| **Redis** | ❌ | ✅ | 6379 | Clustering & Caching |

---

## 🔧 **Konfigurations-Dateien**

### **Umgebungsvariablen**
- `env-example.txt` - Template für alle Optionen
- `.env` - Deine spezifische Konfiguration

### **Docker-Compose-Dateien**
- `docker-compose.yml` - Lokale Entwicklung
- `docker-compose.prod.yml` - Produktion mit LiveKit
- `docker-compose.mediasoup.yml` - Produktion mit Mediasoup

### **Setup-Skripte**
- `setup-production.bat` - Windows Setup
- `setup-production.sh` - Linux/macOS Setup
- `test-production.bat` - Windows Test
- `test-production.sh` - Linux/macOS Test

---

## 🎯 **Empfehlungen**

### **Für Einsteiger**
```bash
# LiveKit-Variante verwenden
docker compose -f docker-compose.prod.yml up -d
```
- ✅ Einfache Konfiguration
- ✅ Automatische SFU-Integration
- ✅ Weniger Ports erforderlich

### **Für Entwickler**
```bash
# Mediasoup-Variante verwenden
docker compose -f docker-compose.mediasoup.yml up -d
```
- ✅ Vollständige Kontrolle
- ✅ Custom Code-Integration
- ✅ Erweiterte Anpassungen

### **Für Produktion**
- **LiveKit**: Bis zu 1000+ Teilnehmer
- **Mediasoup**: Unbegrenzte Skalierung
- **Eigener TURN**: Für maximale Sicherheit

---

## 🔒 **Sicherheits-Features**

### **Alle Varianten**
- ✅ HTTPS/WSS Verschlüsselung
- ✅ Let's Encrypt Zertifikate
- ✅ Rate Limiting
- ✅ IP-Blacklist
- ✅ Automatische Backups

### **Zusätzlich Mediasoup**
- ✅ Redis-Authentifizierung
- ✅ RTP-Port-Isolation
- ✅ Custom Security-Policies

---

## 📊 **Performance-Vergleich**

| Feature | LiveKit | Mediasoup |
|---------|:-------:|:---------:|
| **Setup-Zeit** | 2 Minuten | 5 Minuten |
| **Ressourcen** | Niedrig | Mittel |
| **Skalierung** | Automatisch | Manuell |
| **Kontrolle** | Begrenzt | Vollständig |
| **Wartung** | Einfach | Komplex |

---

## 🚨 **Troubleshooting**

### **Häufige Probleme**

1. **DNS nicht aufgelöst**
   ```bash
   nslookup example.com
   nslookup turn.example.com
   ```

2. **Ports blockiert**
   ```bash
   # Prüfe Firewall
   netstat -an | grep :80
   netstat -an | grep :443
   ```

3. **Let's Encrypt Fehler**
   ```bash
   # Logs prüfen
   docker logs peerlink-traefik
   ```

4. **TURN-Server nicht erreichbar**
   ```bash
   # Test mit netcat
   nc -vz -u turn.example.com 3478
   ```

### **Test-Skripte**
```bash
# Windows
test-production.bat

# Linux/macOS
./test-production.sh
```

---

## 🎉 **Nächste Schritte**

1. **Domain konfigurieren** (A/AAAA Records)
2. **Umgebungsvariablen setzen** (.env bearbeiten)
3. **Setup-Skript ausführen**
4. **Test-Skript ausführen**
5. **Monitoring aktivieren**

---

**🚀 Viel Erfolg mit deiner PeerLink-Installation!**
