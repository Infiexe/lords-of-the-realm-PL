@echo off
rem Kopiuje dane gry z plyty (lub jej kopii) do katalogu gry, tak aby
rem gra dzialala bez plyty. Uzycie:
rem   skopiuj_z_plyty.bat            - szuka kopii plyty w D:\Plytka
rem   skopiuj_z_plyty.bat E:\        - dowolne inne miejsce (np. napad CD)
setlocal
cd /d "%~dp0"

set "SRC=%~1"
if "%SRC%"=="" for /d %%d in ("D:\P*ytka") do set "SRC=%%d"
if "%SRC%"=="" (
  echo Nie znaleziono kopii plyty. Podaj sciezke jako parametr, np.:
  echo   skopiuj_z_plyty.bat E:\
  goto :end
)
if not exist "%SRC%\lords\conquest.map" (
  echo W "%SRC%" nie ma katalogu lords z plyty ^(brak lords\conquest.map^).
  goto :end
)

echo Kopiowanie "%SRC%\lords" do "%~dp0lords" ...
xcopy "%SRC%\lords" "%~dp0lords\" /E /I /Y /Q
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
