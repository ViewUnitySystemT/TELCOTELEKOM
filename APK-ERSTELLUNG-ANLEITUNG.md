# PeerLink APK Erstellung - Detaillierte Anleitung

## Übersicht
Diese Anleitung führt Sie durch die Erstellung einer APK-Datei aus Ihrer `peerlink.html` mit integrierter Mediengalerie.

## Voraussetzungen
- ✅ Android Studio installiert
- ✅ Java Development Kit (JDK) 8 oder höher
- ✅ Windows 11 (wie in Ihren Einstellungen)

## Schritt 1: Projekt Setup

### 1.1 Android Studio öffnen
1. Starten Sie Android Studio
2. Wählen Sie "Create New Project"
3. Wählen Sie "Empty Activity"
4. Konfiguration:
   - **Name**: PeerLink
   - **Package name**: com.telcotelekom.peerlink
   - **Language**: Java
   - **Minimum SDK**: API 21 (Android 5.0)
   - **Target SDK**: API 34 (Android 14)

### 1.2 Automatisches Setup (Empfohlen)
```bash
# Führen Sie das Setup-Skript aus
setup-android-apk.bat
```

## Schritt 2: Dateien kopieren

### 2.1 Assets-Ordner
Kopieren Sie folgende Dateien in `app/src/main/assets/`:
- `peerlink.html` (Ihre Haupt-HTML-Datei)
- `media-gallery.js` (Mediengalerie-Integration)

### 2.2 Medien-Ordner
Kopieren Sie den gesamten `Medien`-Ordner nach `app/src/main/assets/medien/`

### 2.3 Android-Dateien
Kopieren Sie alle erstellten Android-Dateien in die entsprechenden Ordner:
- `MainActivity.java` → `app/src/main/java/com/telcotelekom/peerlink/`
- `activity_main.xml` → `app/src/main/res/layout/`
- `AndroidManifest.xml` → `app/src/main/`
- etc.

## Schritt 3: HTML-Datei anpassen

### 3.1 Mediengalerie-Integration
Fügen Sie am Ende Ihrer `peerlink.html` vor dem schließenden `</body>`-Tag hinzu:

```html
<!-- Media Gallery Integration -->
<script src="media-gallery.js"></script>
<script>
// Automatische Initialisierung der Mediengalerie
document.addEventListener('DOMContentLoaded', function() {
    if (window.MediaInterface) {
        console.log('✅ Android App erkannt - Mediengalerie aktiviert');
    }
});
</script>
```

## Schritt 4: Build-Konfiguration

### 4.1 Gradle-Sync
1. Öffnen Sie Android Studio
2. Warten Sie auf automatischen Gradle-Sync
3. Falls Fehler auftreten: "File" → "Sync Project with Gradle Files"

### 4.2 Abhängigkeiten prüfen
Stellen Sie sicher, dass in `app/build.gradle` folgende Abhängigkeiten enthalten sind:
```gradle
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.10.0'
    implementation 'androidx.webkit:webkit:1.8.0'
}
```

## Schritt 5: APK erstellen

### 5.1 Debug-APK
1. Wählen Sie "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"
2. Warten Sie auf Build-Abschluss
3. APK-Datei finden Sie unter: `app/build/outputs/apk/debug/app-debug.apk`

### 5.2 Release-APK (Optional)
1. Wählen Sie "Build" → "Generate Signed Bundle / APK"
2. Erstellen Sie einen neuen Keystore
3. Wählen Sie "APK"
4. Konfigurieren Sie Signing
5. Build-Type: "release"

## Schritt 6: Installation und Test

### 6.1 APK installieren
```bash
# Über ADB (Android Debug Bridge)
adb install app-debug.apk

# Oder direkt auf dem Gerät:
# 1. APK-Datei auf Android-Gerät kopieren
# 2. "Unbekannte Quellen" in Einstellungen aktivieren
# 3. APK-Datei antippen und installieren
```

### 6.2 Funktionen testen
- ✅ App startet und lädt peerlink.html
- ✅ WebRTC-Funktionen funktionieren
- ✅ Mediengalerie-Button erscheint in der Navigation
- ✅ Medien-Dateien werden korrekt angezeigt
- ✅ Datei-Upload funktioniert

## Schritt 7: Medienzugriff konfigurieren

### 7.1 Berechtigungen
Die App fragt automatisch nach folgenden Berechtigungen:
- Kamera (für Video-Calls)
- Mikrofon (für Audio-Calls)
- Speicher (für Medienzugriff)
- Internet (für WebRTC)

### 7.2 Medienordner
- Der `medien`-Ordner wird automatisch im App-Verzeichnis erstellt
- Alle Dateien aus `assets/medien/` werden in die APK eingebettet
- Benutzer können über die Galerie auf alle Medien zugreifen

## Fehlerbehebung

### Häufige Probleme:

#### 1. Gradle-Sync-Fehler
```bash
# Lösung: Gradle-Cache leeren
./gradlew clean
./gradlew build
```

#### 2. WebView lädt nicht
- Prüfen Sie, ob `peerlink.html` in `assets/` liegt
- Prüfen Sie die URL: `file:///android_asset/peerlink.html`

#### 3. Medien werden nicht angezeigt
- Prüfen Sie, ob `medien`-Ordner in `assets/` liegt
- Prüfen Sie die JavaScript-Konsole auf Fehler

#### 4. Berechtigungen verweigert
- App-Einstellungen öffnen
- Berechtigungen manuell aktivieren

## Erweiterte Konfiguration

### App-Icon ändern
1. Ersetzen Sie `ic_launcher.png` in `app/src/main/res/mipmap-*/`
2. Verschiedene Auflösungen: 48dp, 72dp, 96dp, 144dp, 192dp

### App-Name ändern
Bearbeiten Sie `app/src/main/res/values/strings.xml`:
```xml
<string name="app_name">Ihr App-Name</string>
```

### Version ändern
Bearbeiten Sie `app/build.gradle`:
```gradle
defaultConfig {
    versionCode 2
    versionName "1.1"
}
```

## Support

Bei Problemen:
1. Prüfen Sie die Android Studio Logs
2. Testen Sie auf verschiedenen Android-Versionen
3. Prüfen Sie die WebView-Kompatibilität

## Erfolg! 🎉

Nach erfolgreicher Erstellung haben Sie:
- ✅ Eine funktionsfähige APK-Datei
- ✅ Integrierte Mediengalerie
- ✅ Vollständige PeerLink-Funktionalität
- ✅ Professionelle Android-App

Die APK kann jetzt auf Android-Geräten installiert und verwendet werden!
