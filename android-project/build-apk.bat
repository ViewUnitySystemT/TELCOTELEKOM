@echo off
echo ========================================
echo PeerLink APK Build
echo ========================================
echo.

echo [1/3] Gradle Wrapper erstellen...
call gradle wrapper

echo [2/3] Gradle Sync...
call gradlew build

echo [3/3] APK erstellen...
call gradlew assembleDebug

echo.
echo ========================================
echo Build abgeschlossen!
echo ========================================
echo.
echo APK-Datei finden Sie unter:
echo app\build\outputs\apk\debug\app-debug.apk
echo.
echo Installation:
echo adb install app\build\outputs\apk\debug\app-debug.apk
echo.
pause
