@echo off
setlocal enabledelayedexpansion
title NYTA - WEBM to MP4
rem ===========================================================================
rem  Motor artik dogrudan MP4 yaziyor (Chrome 126+ MediaRecorder H.264).
rem  Bu betik yalnizca ESKI .webm dosyalari icin: OUTPUT klasorundeki her
rem  .webm'i yaninda .mp4 olarak birakir, kaynagi silmez.
rem ===========================================================================
set "OUT=%~dp0OUTPUT"
set "FF=ffmpeg"
where ffmpeg >nul 2>nul || set "FF=C:\ffmpeg\bin\ffmpeg.exe"
if not exist "%FF%" if "%FF%" neq "ffmpeg" goto noff

if not exist "%OUT%" goto noout
set "N=0"
for %%F in ("%OUT%\*.webm") do (
  if exist "%%~dpnF.mp4" (
    echo [ATLA] %%~nxF  -  mp4 zaten var
  ) else (
    echo [DONUSTUR] %%~nxF
    "%FF%" -hide_banner -loglevel error -i "%%F" -c:v libx264 -preset slow -crf 16 -pix_fmt yuv420p -movflags +faststart "%%~dpnF.mp4"
    if errorlevel 1 (echo    [HATA] %%~nxF donusturulemedi) else (set /a N+=1)
  )
)
echo.
echo Bitti. !N! dosya donusturuldu. Kaynak .webm dosyalari silinmedi.
pause
exit /b 0

:noff
echo.
echo  [HATA] ffmpeg bulunamadi. PATH'e ekle ya da C:\ffmpeg\bin\ffmpeg.exe olarak kur.
echo.
pause
exit /b 1

:noout
echo.
echo  [HATA] OUTPUT klasoru yok: %OUT%
echo.
pause
exit /b 1
