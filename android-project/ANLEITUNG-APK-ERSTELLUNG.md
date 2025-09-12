# PeerLink APK - Manuelle Erstellung mit Android Studio

## Projekt ist bereit! 🎉

Das Android Studio Projekt wurde erfolgreich erstellt und konfiguriert. Hier ist die Anleitung zur APK-Erstellung:

## Schritt 1: Android Studio öffnen

1. **Android Studio starten**
2. **"Open an existing project" wählen**
3. **Zum Ordner navigieren**: `C:\Users\Gebruiker\Desktop\software\peerlink\Production\Nieuwe map\TELCOTELEKOM\android-project`
4. **Ordner "android-project" auswählen**

## Schritt 2: Gradle Sync

1. **Warten Sie auf automatischen Gradle Sync**
2. **Falls Fehler auftreten**: 
   - "File" → "Sync Project with Gradle Files"
   - Oder: "Build" → "Clean Project" → "Rebuild Project"

## Schritt 3: APK erstellen

### Option A: Debug APK (Empfohlen für Tests)
1. **"Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"**
2. **Warten auf Build-Abschluss**
3. **APK-Datei finden Sie unter**: `app\build\outputs\apk\debug\app-debug.apk`

### Option B: Release APK (Für Verteilung)
1. **"Build" → "Generate Signed Bundle / APK"**
2. **"APK" wählen**
3. **Neuen Keystore erstellen**:
   - Key store path: Wählen Sie einen Speicherort
   - Password: Wählen Sie ein sicheres Passwort
   - Key alias: peerlink-key
   - Key password: Gleiches Passwort wie Key store
4. **Build-Type: "release"**
5. **APK-Datei finden Sie unter**: `app\build\outputs\apk\release\app-release.apk`

## Schritt 4: APK installieren

### Über Android Studio (mit verbundenem Gerät)
1. **Android-Gerät per USB verbinden**
2. **USB-Debugging aktivieren** (in Entwickleroptionen)
3. **"Run" → "Run 'app'"** oder **"Run" → "Debug 'app'"**

### Über ADB (Android Debug Bridge)
```bash
adb install app-debug.apk
```

### Manuell auf dem Gerät
1. **APK-Datei auf Android-Gerät kopieren**
2. **"Unbekannte Quellen" in Einstellungen aktivieren**
3. **APK-Datei antippen und installieren**

## Projektstruktur

```
android-project/
├── app/
│   ├── src/main/
│   │   ├── java/com/telcotelekom/peerlink/
│   │   │   └── MainActivity.java
│   │   ├── res/
│   │   │   ├── layout/activity_main.xml
│   │   │   ├── values/strings.xml
│   │   │   ├── values/styles.xml
│   │   │   └── xml/
│   │   ├── assets/
│   │   │   ├── index.html (mit Mediengalerie)
│   │   │   └── medien/ (47 Mediendateien)
│   │   └── AndroidManifest.xml
│   └── build.gradle
├── build.gradle
├── settings.gradle
└── gradle.properties
```

## Funktionen der APK

✅ **WebView-Integration** - Lädt index.html direkt in die App
✅ **Mediengalerie** - Zugriff auf alle 47 Dateien im Medien-Ordner
✅ **WebRTC-Support** - Vollständige Video/Audio-Call-Funktionalität
✅ **Datei-Upload** - Benutzer können Dateien hochladen
✅ **Berechtigungen** - Automatische Anfrage aller Android-Berechtigungen
✅ **Responsive Design** - Funktioniert auf verschiedenen Android-Geräten

## Fehlerbehebung

### Gradle Sync Fehler
- **Lösung**: "File" → "Invalidate Caches and Restart"

### Build Fehler
- **Lösung**: "Build" → "Clean Project" → "Rebuild Project"

### WebView lädt nicht
- **Prüfen**: index.html ist in `assets/` vorhanden
- **Prüfen**: URL ist `file:///android_asset/index.html`

### Medien werden nicht angezeigt
- **Prüfen**: medien-Ordner ist in `assets/medien/` vorhanden
- **Prüfen**: JavaScript-Konsole auf Fehler

## Erfolg! 🎉

Nach erfolgreicher Erstellung haben Sie:
- ✅ Eine funktionsfähige APK-Datei
- ✅ Integrierte Mediengalerie mit 47 Dateien
- ✅ Vollständige PeerLink-Funktionalität
- ✅ Professionelle Android-App

Die APK kann jetzt auf Android-Geräten installiert und verwendet werden!
