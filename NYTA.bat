@echo off
title NYTA CREATIVE ENGINE
rem ===========================================================================
rem  NYTA CREATIVE ENGINE - tasinabilir baslatici
rem  Chrome'u uygulama modunda acar: sekme yok, adres cubugu yok.
rem  Klasoru tasisan da calisir; masaustundeki kisayol sabit yolu kullanir.
rem ===========================================================================
set "HTML=%~dp0nyta_creative_engine.html"
set "PROFILE=%~dp0.chrome-profile"
set "CHROME=C:\Program Files\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" goto nochrome
if not exist "%HTML%" goto nohtml
if not exist "%~dp0OUTPUT" mkdir "%~dp0OUTPUT"
start "" "%CHROME%" --app="file:///%HTML:\=/%" --user-data-dir="%PROFILE%" --window-size=1680,1000 --window-position=60,40
exit /b 0

:nochrome
echo.
echo  [HATA] Chrome bulunamadi.
echo  Beklenen konum: C:\Program Files\Google\Chrome\Application\chrome.exe
echo.
pause
exit /b 1

:nohtml
echo.
echo  [HATA] nyta_creative_engine.html bu klasorde yok:
echo  %~dp0
echo.
pause
exit /b 1
