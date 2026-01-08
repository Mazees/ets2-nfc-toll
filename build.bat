@echo off
TITLE GTO TOOLS - BUILD
cd /d "%~dp0"
cls

echo.
echo  =========================================================
echo         GTO NFC TOOLS ETS2 - BUILD SCRIPT
echo              Created by MAZEES
echo  =========================================================
echo.

:: Buat folder build
if not exist build mkdir build

:: Kosongkan folder build dulu
echo  [0/5] Mengosongkan folder build...
del /q build\* 2>nul

echo  [1/5] Building server.exe...
call pkg ./server/index.js --targets node18-win-x64 --output ./build/server.exe
if errorlevel 1 (
    echo  [ERROR] Gagal build server.exe!
    echo  Pastikan pkg sudah terinstall: npm install -g pkg
    pause
    exit /b 1
)
echo        Done!

echo  [2/5] Copying ngrok.exe...
copy /Y ngrok.exe build\ngrok.exe >nul
echo        Done!

echo  [3/5] Copying autokey.exe...
copy /Y autokey.exe build\autokey.exe >nul
echo        Done!

echo  [4/5] Copying index.html...
copy /Y index.html build\index.html >nul
echo        Done!

echo  [5/5] Copying run.bat...
copy /Y run.bat build\run.bat >nul
echo        Done!

echo.
echo  =========================================================
echo   BUILD SELESAI!
echo  =========================================================
echo.
echo   Folder 'build' berisi:
echo     - run.bat     (Launcher)
echo     - server.exe  (Server)
echo     - ngrok.exe   (Tunnel)
echo     - autokey.exe (AutoHotkey)
echo     - index.html  (Frontend)
echo.
echo   Siap di-zip dan dibagikan!
echo.
echo  =========================================================
pause
