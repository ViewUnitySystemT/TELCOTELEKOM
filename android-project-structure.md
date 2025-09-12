# Android Studio Projektstruktur für PeerLink APK

## Erforderliche Ordnerstruktur:

```
app/
├── src/
│   ├── main/
│   │   ├── java/com/telcotelekom/peerlink/
│   │   │   └── MainActivity.java
│   │   ├── res/
│   │   │   ├── layout/
│   │   │   │   └── activity_main.xml
│   │   │   ├── values/
│   │   │   │   ├── strings.xml
│   │   │   │   └── styles.xml
│   │   │   └── mipmap/
│   │   │       └── ic_launcher.png
│   │   ├── assets/
│   │   │   ├── peerlink.html
│   │   │   └── medien/
│   │   │       ├── 2025.jpg
│   │   │       ├── 4chillout.mp4
│   │   │       ├── BEATHROW.mp3
│   │   │       └── [alle anderen Medien-Dateien]
│   │   └── AndroidManifest.xml
├── build.gradle (Module: app)
└── build.gradle (Project: PeerLink)
```

## Wichtige Konfigurationen:

### AndroidManifest.xml
- Internet-Berechtigung
- Medien-Zugriffsberechtigungen
- WebView-Aktivität

### MainActivity.java
- WebView-Integration
- Medienordner-Zugriff
- JavaScript-Brücke für Dateizugriff

### assets/medien/
- Kopieren Sie den gesamten Medienordner hierher
- Alle Dateien werden in der APK eingebettet
