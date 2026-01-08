@echo off
TITLE GTO NFC Tools ETS2 - Launcher
cd /d "%~dp0"
setlocal enabledelayedexpansion
cls

echo.
echo  =========================================================
echo         GTO NFC TOOLS ETS2 - LAUNCHER
echo              Created by MAZEES
echo  =========================================================
echo.

:: --- CHECK NGROK AUTH ---
if not exist "ngrok_token.txt" (
    echo  =========================================================
    echo   SETUP PERTAMA KALI - Masukkan Ngrok Auth Token
    echo  =========================================================
    echo.
    echo   1. Buka https://dashboard.ngrok.com/get-started/your-authtoken
    echo   2. Login/Daftar akun gratis
    echo   3. Copy Auth Token dari halaman tersebut
    echo.
    set /p "TOKEN=  Paste Auth Token disini: "
    echo !TOKEN!> ngrok_token.txt
    echo.
    echo  Token tersimpan!
    timeout /t 2 >nul
)

:: --- LOAD TOKEN ---
set /p NGROK_TOKEN=<ngrok_token.txt

:: --- CLEANUP ---
echo  [1/5] Membersihkan proses lama...
taskkill /f /im server.exe >nul 2>&1
taskkill /f /im ngrok.exe >nul 2>&1
taskkill /f /im autokey.exe >nul 2>&1
if exist ngrok.log del ngrok.log
timeout /t 1 >nul

:: --- CONFIG NGROK ---
echo  [2/4] Mengkonfigurasi Ngrok...
ngrok.exe config add-authtoken %NGROK_TOKEN% >nul 2>&1

:: --- START NGROK FIRST ---
echo  [3/4] Membuka tunnel...
start "" /min cmd /c "ngrok.exe http 3000 --log=stdout > ngrok.log 2>&1"

:: --- WAIT FOR LINK ---
echo        Menunggu link...
set RETRY=0

:wait_link
set "TUNNEL_URL="
if exist ngrok.log (
    for /f "tokens=*" %%i in ('findstr /C:"https://" ngrok.log 2^>nul') do (
        for %%u in (%%i) do (
            echo %%u | findstr /C:"https://" >nul 2>&1
            if not errorlevel 1 set TUNNEL_URL=%%u
        )
    )
)

if "!TUNNEL_URL!"=="" (
    set /a RETRY+=1
    if !RETRY! GEQ 20 (
        echo.
        echo  [!] Timeout - Ngrok gagal. Pastikan token benar.
        echo  Hapus file ngrok_token.txt untuk reset token.
        pause
        exit
    )
    timeout /t 1 >nul
    goto wait_link
)

echo        Link didapat!

:: --- SAVE URL TO FILE ---
echo !TUNNEL_URL!> tunnel_url.txt

:: --- START AUTOKEY ---
echo  [4/5] Menjalankan AutoHotkey...
start "" autokey.exe

:: --- START SERVER ---
echo  [5/5] Menjalankan Server...
start "GTO SERVER" cmd /k "title GTO SERVER && color 0A && server.exe"
timeout /t 2 >nul

:: --- SHOW RESULT ---
cls
echo.
echo  =========================================================
echo            GTO NFC TOOLS ETS2 - READY!
echo  =========================================================
echo.
echo    LINK: !TUNNEL_URL!
echo.
echo  =========================================================
echo   CARA PAKAI DI HP:
echo   1. Buka link di atas di Chrome HP
echo   2. Tempelkan kartu NFC ke belakang HP!
echo   3. Toll otomatis terbayar di game!
echo  =========================================================
echo.
echo  Tekan tombol apa saja untuk MENUTUP...
pause >nul

:: --- CLEANUP ---
taskkill /f /im server.exe >nul 2>&1
taskkill /f /im ngrok.exe >nul 2>&1
taskkill /f /im autokey.exe >nul 2>&1
endlocal
exit