@echo off
rem ===========================================================================
rem  NYTA CREATIVE ENGINE - tek komutla guncelleme gonder
rem  Kullanim:  push.bat "commit mesaji"
rem  Mesaj verilmezse tarih-saat damgasi kullanilir.
rem ===========================================================================
setlocal
cd /d "%~dp0"

set "MSG=%~1"
if "%MSG%"=="" (
  for /f "tokens=1-6 delims=/:. " %%a in ("%date% %time%") do set "MSG=update %%c-%%b-%%a %%d:%%e"
)

git add -A
git diff --cached --quiet && (
  echo.
  echo  Degisiklik yok - gonderilecek bir sey bulunamadi.
  echo.
  pause
  exit /b 0
)

echo.
echo  Gonderilecek dosyalar:
git status --short
echo.

git commit -q -m "%MSG%"
if errorlevel 1 goto fail
git push -q origin main
if errorlevel 1 goto fail

echo  Gonderildi: %MSG%
echo  https://github.com/ennytang/NYTA-CREATIVE-ENGINE
echo.
timeout /t 4 >nul
exit /b 0

:fail
echo.
echo  [HATA] commit ya da push basarisiz oldu. Yukaridaki ciktiya bak.
echo.
pause
exit /b 1
