@echo off
echo ========================================
echo PeerLink APK Setup für Android Studio
echo ========================================
echo.

echo [1/6] Erstelle Android Studio Projektstruktur...
if not exist "android-project" mkdir android-project
cd android-project

echo [2/6] Erstelle App-Ordnerstruktur...
if not exist "app\src\main\java\com\telcotelekom\peerlink" mkdir app\src\main\java\com\telcotelekom\peerlink
if not exist "app\src\main\res\layout" mkdir app\src\main\res\layout
if not exist "app\src\main\res\values" mkdir app\src\main\res\values
if not exist "app\src\main\res\xml" mkdir app\src\main\res\xml
if not exist "app\src\main\assets" mkdir app\src\main\assets
if not exist "app\src\main\assets\medien" mkdir app\src\main\assets\medien

echo [3/6] Kopiere HTML-Datei...
copy "..\peerlink.html" "app\src\main\assets\peerlink.html"

echo [4/6] Kopiere Medien-Dateien...
xcopy "..\Medien\*" "app\src\main\assets\medien\" /E /I /Y

echo [5/6] Kopiere Android-Dateien...
copy "..\MainActivity.java" "app\src\main\java\com\telcotelekom\peerlink\MainActivity.java"
copy "..\activity_main.xml" "app\src\main\res\layout\activity_main.xml"
copy "..\strings.xml" "app\src\main\res\values\strings.xml"
copy "..\styles.xml" "app\src\main\res\values\styles.xml"
copy "..\AndroidManifest.xml" "app\src\main\AndroidManifest.xml"
copy "..\file_paths.xml" "app\src\main\res\xml\file_paths.xml"
copy "..\backup_rules.xml" "app\src\main\res\xml\backup_rules.xml"
copy "..\data_extraction_rules.xml" "app\src\main\res\xml\data_extraction_rules.xml"
copy "..\build.gradle" "app\build.gradle"

echo [6/6] Erstelle Projekt-Build-Datei...
echo // Top-level build file where you can add configuration options common to all sub-projects/modules.
echo plugins {
echo     id 'com.android.application' version '8.1.0' apply false
echo }
echo.
echo allprojects {
echo     repositories {
echo         google()
echo         mavenCentral()
echo     }
echo } > build.gradle

echo.
echo ========================================
echo Setup abgeschlossen!
echo ========================================
echo.
echo Nächste Schritte:
echo 1. Öffnen Sie Android Studio
echo 2. Wählen Sie "Open an existing project"
echo 3. Navigieren Sie zum Ordner: %CD%
echo 4. Wählen Sie den Ordner "android-project"
echo 5. Warten Sie auf Gradle-Sync
echo 6. Klicken Sie auf "Build" ^> "Build Bundle(s) / APK(s)" ^> "Build APK(s)"
echo.
echo Die APK-Datei finden Sie unter:
echo app\build\outputs\apk\debug\app-debug.apk
echo.
pause
