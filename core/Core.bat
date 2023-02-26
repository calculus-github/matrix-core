@echo off & setlocal enabledelayedexpansion
Title Core Script B.David [STARTING]
mode con cols=80 lines=14 & Color A

cd /d %~dp0
Set "Path=%Path%;%CD%;%CD%\bin;"
set localver=3405
set maindir=%CD%
set format=Yes
set formatcolor=2F
if defined ProgramFiles(x86) (set bit=64) else (set bit=32)

REM GET ADMIN CODE MUST GO FIRST
:initialchecks
echo.Running Initial Checks
ping 1.1.1.1 -n 1 -w 1000 > nul
if errorlevel 1 (Echo.Could not Ping 1.1.1.1, Attempting backup pings.) else (goto foundinternet)
ping 8.8.8.8 -n 1 -w 2000 > nul
if errorlevel 1 (Echo.Could not Ping 8.8.8.8, Attempting backup pings.) else (goto foundinternet)
ping github.com -n 1 -w 2000 > nul
if errorlevel 1 (Echo.Could not Ping gihub.com, Exiting Script && timeout 5 > nul && exit) else (goto foundinternet)
:foundinternet
echo.Found Internet
curl.exe -V > nul
if errorlevel 1 (echo Filed to find curl. && pause && exit)
echo.Found cURL
for %%# in (powershell.exe) do @if "%%~$PATH:#"=="" (echo.Could not find Powershell. && pause && exit) 
echo.Found Powershell
echo.Promting for admin permissions if not run as admin.
timeout 1 >nul
set _elev=
if /i "%~1"=="-el" set _elev=1
set _PSarg="""%~f0""" -el %_args% && set "nul=>nul 2>&1" && setlocal EnableDelayedExpansion
%nul% reg query HKU\S-1-5-19 || (
if not defined _elev %nul% powershell.exe "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && exit /b
	echo.Please reopen this script as admin. 
	echo.Veuillez rouvrir ce script en tant qu'administrateur.
	echo.Por favor, reabra este script como administrador.
	echo.Bitte offnen Sie dieses Skript erneut als Administrator.
	echo.Lutfen bu betigi yonetici olarak yeniden acin. && pause && exit /b
)

:begin
echo Selectionne une tache:
echo =============
echo -
echo 1) Option 1 Changer reseau le sur ON
echo 2) Option 2 Changer reseau le sur OFF
echo 3) Option 3 Medicat
echo 4) Option 4 Cloud Azure Automation
echo 5) Option 5 Relancer Core
echo 6) Option 6 Peupler un AD en 1 clic
echo 7) Option 7 Controler le PC avec une IA (telecharger Python 3.9)
echo 8) Option 8 Preparation de Poste
echo 9) Option 9 Rainbow
echo 10) Option 10 Enregistrer le fond ecran 
echo 11) Option 11
echo -
set /p op=Type option:
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3
if "%op%"=="4" goto op4
if "%op%"=="5" goto op5
if "%op%"=="6" goto op6
if "%op%"=="7" goto op7
if "%op%"=="8" goto op8
if "%op%"=="9" goto op9
if "%op%"=="10" goto op10
if "%op%"=="11" goto op11

echo Choisissez une option : 
goto begin


:op1
echo you picked option %op%
netsh int set int name="ETHERNET" admin=enabled
netsh int set int name="Wi-Fi" admin=enabled
goto begin

:op2
echo you picked option %op%
netsh int set int name="ETHERNET" admin=disabled
netsh int set int name="Wi-Fi" admin=disabled
goto begin

:op3
start %CD%\Medicat_Installer.bat
goto begin

:op4
powershell %CD%\Auto_Azure.ps1
goto begin

:op5
start %CD%\Core.bat
goto begin

:op6
powershell %CD%\Add-NewUsers.ps1
goto begin

:op7
"E:\CMD\python-3.12\python.exe" "E:\CMD\foo.py"
goto begin

:op8
start %CD%\Prepa.bat
goto begin

:op9
start %CD%\rainbow.bat
goto begin

:op10
mspaint %AppData%\Microsoft\Windows\Themes\TranscodedWallpaper
goto begin

:op11
goto begin


:exit
@exit