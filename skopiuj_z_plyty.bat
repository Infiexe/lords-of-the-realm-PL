@echo off
rem Kopiuje dane gry z plyty (lub jej kopii) do podkatalogu lords w katalogu
rem gry, tak aby gra dzialala bez plyty. Uzycie:
rem   skopiuj_z_plyty.bat            - szuka kopii plyty w D:\Plytka
rem   skopiuj_z_plyty.bat E:\        - dowolne inne miejsce (np. napad CD)
rem Dane moga lezec w katalogu glownym plyty (AB8, PL8, SPEECH_A, ...)
rem albo w jej podkatalogu lords.
setlocal
cd /d "%~dp0"

set "SRC=%~1"
if "%SRC%"=="" for /d %%d in ("D:\P*ytka") do set "SRC=%%d"
if "%SRC%"=="" (
  echo Nie znaleziono kopii plyty. Podaj sciezke jako parametr, np.:
  echo   skopiuj_z_plyty.bat E:\
  goto :end
)
if "%SRC:~-1%"=="\" set "SRC=%SRC:~0,-1%"

set "BASE="
if exist "%SRC%\PL8\" set "BASE=%SRC%"
if exist "%SRC%\lords\PL8\" set "BASE=%SRC%\lords"
if "%BASE%"=="" (
  echo W "%SRC%" nie ma danych gry ^(brak katalogu PL8 ani lords\PL8^).
  goto :end
)

echo Kopiowanie danych z "%BASE%" do "%~dp0lords" ...
for %%s in (AB8 PL8 VAS VOCS1 VOCS2 VPX XM2 XMI) do (
  if exist "%BASE%\%%s\" xcopy "%BASE%\%%s" "%~dp0lords\%%s\" /E /I /Y /Q >nul
)
for /d %%s in ("%BASE%\SPEECH_*") do (
  xcopy "%%s" "%~dp0lords\%%~nxs\" /E /I /Y /Q >nul
)
attrib -R "%~dp0lords\*" /S /D >nul

echo.
echo Sprawdzanie kompletnosci...
set BRAK=0
for /f "usebackq delims=" %%f in ("PLIKI_Z_PLYTY.txt") do (
  if not exist "%%f" (
    echo BRAK: %%f
    set BRAK=1
  )
)
if "%BRAK%"=="0" (
  echo Wszystkie pliki sa na miejscu. Gre mozna uruchamiac bez plyty.
) else (
  echo Brakuje plikow wymienionych powyzej.
)

:end
echo.
pause
