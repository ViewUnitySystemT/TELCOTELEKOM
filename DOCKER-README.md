# 🚀 PeerLink Docker Setup
## 11000% User-Freundlichkeitsgarantie! 🎉

### ⚡ Schnellstart (3 Befehle)

```bash
# 1. System starten
docker-start.bat

# 2. Browser öffnen
http://localhost:8080

# 3. Fertig! 🎉
```

### 📋 Was ist enthalten?

- ✅ **PeerLink Server** - Vollständiger WebRTC-Signaling-Server
- ✅ **Live Monitoring** - Echtzeit-Dashboard mit Metriken
- ✅ **Automatische Backups** - Alle 6 Stunden + manuelle Backups
- ✅ **Traefik Proxy** - Automatische Load-Balancing
- ✅ **Volume-Management** - Persistente Datenspeicherung
- ✅ **Health-Checks** - Automatische Systemüberwachung

### 🎮 Verfügbare Scripts

| Script | Beschreibung | Wann verwenden? |
|--------|-------------|-----------------|
| `docker-start.bat` | System starten | Zum ersten Mal oder nach Stop |
| `docker-stop.bat` | System stoppen | Zum Herunterfahren |
| `docker-status.bat` | Status anzeigen | Zum Überprüfen des Systems |
| `docker-backup.bat` | Backup erstellen | Regelmäßig für Sicherheit |
| `docker-restore.bat` | Backup wiederherstellen | Bei Datenverlust |
| `docker-update.bat` | System aktualisieren | Für neue Versionen |

### 🌐 Zugriff

Nach dem Start sind verfügbar:
- **PeerLink**: http://localhost:8080
- **Monitoring**: http://localhost:8080/monitoring
- **Health-Check**: http://localhost:8080/health
- **Traefik Dashboard**: http://localhost:8081

### 💾 Daten & Backups

**Automatisch gesichert:**
- `./logs/` - System-Logs
- `./data/` - Anwendungsdaten
- `./backup/` - Automatische Backups
- `./monitoring-data.json` - Monitoring-Daten

**Backup-Strategie:**
- Automatisch alle 6 Stunden
- 7 Tage Aufbewahrung
- Manuelle Backups jederzeit möglich

### 🔧 Erweiterte Konfiguration

**Ports ändern:**
```yaml
# In docker-compose.yml
ports:
  - "9090:8080"  # Ändere 8080 zu gewünschtem Port
```

**Volumes anpassen:**
```yaml
volumes:
  - ./meine-logs:/app/logs
  - ./meine-daten:/app/data
```

### 🚨 Fehlerbehebung

**"Docker nicht verfügbar":**
```bash
# Docker Desktop starten und warten
docker-start.bat
```

**"Port bereits belegt":**
```yaml
# docker-compose.yml anpassen
ports:
  - "9090:8080"
```

**"Backup wiederherstellen":**
```bash
docker-restore.bat peerlink_backup_20250908_143000
```

### 📞 Support

Bei Problemen:
1. `docker-status.bat` ausführen
2. Logs in `./logs/` überprüfen
3. `docker-stop.bat` und `docker-start.bat` versuchen

---

**🎊 Ihr PeerLink-System ist bereit für den produktiven Einsatz!**

**11000% User-Freundlichkeitsgarantie erfüllt!** ✨🚀
