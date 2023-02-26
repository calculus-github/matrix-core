@echo OFF & setlocal enabledelayedexpansion
title Medicat Installer [STARTING]
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

pushd "%CD%"
CD /D "%~dp0"
for /f "tokens=4-5 delims=. " %%i in ('ver') do set os2=%%i.%%j
if "%os2%" == "10.0" goto oscheckpass
mode con:cols=64 lines=18
title Medicat Installer [UNSUPPORTED]
ver
echo.Your version of windows might not be supported.
echo.If you believe this is an error you can
Set /P _num=bypass this warning by typing "I AGREE": || Set _num=NothingChosen
If "%_num%"=="NothingChosen" exit
If /i "%_num%"=="I AGREE" goto oscheckpass
:oscheckpass
echo.Using Supported version of windows.
timeout 1 > nul
md bin
cd %maindir%\bin
curl -O -s https://eternallybored.org/misc/wget/1.21.3/%bit%/wget.exe
cd %maindir% 



:lang
FOR /F "skip=2 tokens=2*" %%a IN ('REG QUERY "HKEY_CURRENT_USER\Control Panel\International" /v "LocaleName"') DO SET "OSLanguage=%%b"
set lang=%OSLanguage:~0,2%
IF "%lang%"=="en" (goto curver)
IF "%lang%"=="fr" (goto curver)
echo.Select Your Language
call Button 1 2 F2 "English" 14 2 F2 "Francais" 28 2 F2 "Portugues" 43 2 F2 "Deutsch" 56 2 F2 "Turkish" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover%  
If /I "%Errorlevel%"=="1" (
set lang=en
goto curver
)
If /I "%Errorlevel%"=="2" (
set lang=fr
goto curver
)
If /I "%Errorlevel%"=="3" (
set lang=pt
goto curver
)
If /I "%Errorlevel%"=="4" (
set lang=gr
goto curver
)
If /I "%Errorlevel%"=="4" (
set lang=gr
goto curver
)
If /I "%Errorlevel%"=="5" (
set lang=tr
goto curver
)

:curver
mode con:cols=64 lines=18
cls
powershell -c "$data = wget https://api.github.com/repos/mon5termatt/medicat_installer/git/refs/tag -UseBasicParsing | ConvertFrom-Json; $data[-1].ref -replace 'refs/tags/', '' | Out-File -Encoding 'UTF8' -FilePath './curver.ini'"
set /p remver= < curver.ini
set remver=%remver:~-4%
del curver.ini /Q
if "%localver%" == "%remver%" (goto startup)

:updateprogram
cls
echo.A new version of the program has been released. The program will now restart.
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/update.bat" -O ./update.bat -q
start cmd /k update.bat
exit


:startup
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII           DUE TO THE PACKED FILES IN THIS             IIII
echo.IIII          PROGRAM THE ANTIVIRUS MUST BE OFF            IIII
echo.IIII                                                       IIII
echo.IIII          PLEASE MAKE SURE ANTIVIRUS IS OFF            IIII
echo.IIII        BEFORE CONTINUING TO USE THIS PROGRAM          IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II     
echo.                          Press any key to bypass this warning.&& pause >nul
:checkupdateprogram
title Medicat Installer [FILECHECK]
cls
echo.Please wait. Files are being downloaded. 
echo.1/13  [====                                                ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/QuickSFV.EXE" -O ./bin/QuickSFV.exe -q
echo.2/13  [========                                            ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/QuickSFV.ini" -O ./bin/QuickSFV.ini -q
echo.3/13  [============                                        ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/Box.bat" -O ./bin/Box.bat -q
echo.4/13  [================                                    ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/Button.bat" -O ./bin/Button.bat -q
echo.5/13  [====================                                ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/GetInput.exe" -O ./bin/GetInput.exe -q
echo.6/13  [========================                            ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/Getlen.bat" -O ./bin/Getlen.bat -q
echo.7/13  [============================                        ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/batbox.exe" -O ./bin/batbox.exe -q
echo.8/13  [================================                    ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/bin/folderbrowse.exe" -O ./bin/folderbrowse.exe -q
echo.9/13  [====================================                ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/ver.ini" -O ./ver.ini -q
echo.10/13 [========================================            ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/%lang%/motd.txt" -O ./bin/motd.txt -q
echo.11/13 [============================================        ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/%lang%/LICENSE.txt" -O ./bin/LICENSE.txt -q
echo.12/13 [================================================    ]
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/7z/%bit%.exe" -O ./bin/7z.exe -q
echo.13/13 [====================================================]

wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/7z/%bit%.dll" -O ./bin/7z.dll -q
set /p medicatver= < ver.ini
DEL ver.ini /Q


:start
call:ascii
pause
:menu
set installertext=[31mM[32mE[33mD[34mI[35mC[36mA[31mT[32m I[33mN[34mS[35mT[36mA[31mL[32mL[33mE[34mR[0m
title Medicat Installer [%localver%]
mode con:cols=100 lines=30
cls
type bin\LICENSE.txt
echo.
pause
:menu2
mode con:cols=64 lines=20
echo.  %installertext%   %installertext%   %installertext%
call Button 1 2 F2 "INSTALL MEDICAT" 23 2 %formatcolor% "TOGGLE DRIVE FORMAT (CURRENTLY %format%)" 1 7 F9 "JOIN THE DISCORD" 24 7 F9 "  VISIT THE SITE  " 49 7 FC "  EXIT.  "  X _Var_Box _Var_Hover
echo.
echo.
echo.
echo.VERSION %localver% BY MON5TERMATT. 
echo.
type bin\motd.txt
GetInput /M %_Var_Box% /H %_Var_Hover% 


If /I "%Errorlevel%"=="1" (
	cls & goto check5
)
If /I "%Errorlevel%"=="2" (
	cls & goto formatswitch
)
If /I "%Errorlevel%"=="3" (
	cls & goto discord
)
If /I "%Errorlevel%"=="4" (
	cls & goto medicatsite
)
If /I "%Errorlevel%"=="5" exit

:formatswitch
if "%format%" == "Yes" (goto fs2) else (echo.>nul)
if "%format%" == "No" (goto fs3) else (goto menu2)
:fs2
set format=No
set formatcolor=4F
goto menu2
:fs3
set format=Yes
set formatcolor=2F
goto menu2



:check5
echo.Getting Current Ventoy Version
timeout 0 >nul
powershell -c "$data = wget https://api.github.com/repos/ventoy/ventoy/git/refs/tag -UseBasicParsing | ConvertFrom-Json; $data[-1].ref -replace 'refs/tags/', '' | Out-File -Encoding 'UTF8' -FilePath './ventoyversion.txt'"
set /p VENVER= <./ventoyversion.txt
set vencurver=%VENVER:~-6%
echo.Current Online Version - %VENVER:~-6%
goto checkventoyver
:checkventoyver
echo.Checking if current version found on system.
timeout 1 >nul
if exist "%CD%\Ventoy2Disk\" (goto checkver) else (goto ventoyget)
:checkver
set /p localver= <.\Ventoy2Disk\ventoy\version
echo.Current Local Version - %VENVER:~-6%
if "%localver%" == "%vencurver%" (goto uptodate) else (goto ventoyget)
:ventoyget
echo.Update Found. Downloading Latest Ventoy.
timeout 1 >nul
wget https://github.com/ventoy/Ventoy/releases/download/v%vencurver%/ventoy-%vencurver%-windows.zip -O ./ventoy.zip -q
7z x ventoy.zip -r -aoa
RMDIR Ventoy2Disk /S /Q
REN ventoy-%vencurver% Ventoy2Disk
move .\Ventoy2Disk\altexe\Ventoy2Disk_X64.exe .\Ventoy2Disk\Ventoy2Disk.exe
cls
echo.Downloaded newest version.
goto doneventoy
:uptodate
echo.Local version matches latest version. Not attempting to update.
:doneventoy
timeout 3 >nul
DEL ventoy.zip /Q
del .wget-hsts /Q
del ventoyversion.txt /Q





:install2
title Medicat Installer [CHOOSEINSTALL]
mode con:cols=100 lines=15
echo.We now need to find out what drive you will be installing to.
REM - FOLDER PROMPT STARTS
for /f "delims=" %%A in ('folderbrowse.exe "Please select the drive you want to install medicat on"') do set "folder=%%A"
REM - AND ENDS
set drivepath=%folder:~0,1%
IF "%drivepath%" == "~0,1" GOTO install2
echo.Installing to (%drivepath%). If this is correct just hit enter.
Set /P drivepath=if this is wrong type the correct drive letter now: || Set drivepath=%drivepath%
IF "%drivepath%" == "C" GOTO IMPORTANTDRIVE
if "%format%" == "Yes" (goto formatdrive) else (goto updateventoy)

:formatdrive
set arg1=/GPT
set arg2=/NOSB

:sbask
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII               WOULD YOU LIKE TO USE GPT               IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
call Button 10 12 F2 "YES" 46 12 F4 "NO" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 
REM BELOW IS YES
If /I "%Errorlevel%"=="1" (
	cls & set arg1=/GPT & goto gptask
)
REM BELOW IS NO
If /I "%Errorlevel%"=="2" (
	cls & set "arg1=" & goto gptask
)
goto sbask

:gptask
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII           WOULD YOU LIKE TO USE SECUREBOOT?           IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
call Button 10 12 F2 "YES" 46 12 F4 "NO" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 
REM BELOW IS YES
If /I "%Errorlevel%"=="1" (
	cls & set "arg2=" & goto ventoyinstall
)
REM BELOW IS NO
If /I "%Errorlevel%"=="2" (
	cls & set set arg2=/NOSB & goto ventoyinstall
)
goto sbask



:ventoyinstall
echo.Please Wait, Installing Ventoy. Please close the file explorer when done.
cd .\Ventoy2Disk\
Ventoy2Disk.exe VTOYCLI /I /Drive:%drivepath%: %arg1% %arg2% 
cd %maindir%
echo.[101mPlease hit enter, The format diolouge is dumb[0m
format %drivepath%: /FS:NTFS /X /Q /V:Medicat
goto installversion

:error
echo.nothing was chosen, try again
timeout 5
goto install2
:importantdrive
mode con:cols=64 lines=18
echo.[101mII-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                   IMPORTANT WARNING                   IIII
echo.IIII                                                       IIII
echo.IIII       IT LOOKS LIKE YOU SELECTED THE C DRIVE          IIII
echo.IIII        THIS MAY CAUSE IRREPARABLE DAMAGE TO           IIII
echo.IIII               YOUR COMPUTER SYSTEM..                  IIII
echo.IIII           THE PROGRAM WILL NOW ASK AGAIN              IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.                          Press any key to bypass this warning.[0m&& pause >nul
goto install2



REM -- GO TO END OF FILE FOR MOST EXTRACTIONS
REM -- WHEN DONE EXTRACTING VENTOY, TYPE LICENCE AND CONTINUE


:updateventoy
echo.Please Wait, Updating Ventoy but not formatting
cd .\Ventoy2Disk\
Ventoy2Disk.exe VTOYCLI /U /Drive:%drivepath%:
cd %maindir%
:installversion
title Medicat Installer [INSTALL!]
if exist "%CD%\MediCat.USB.v%medicatver%.7z" (goto install4) else (goto installversion2)
:installversion2
if exist "%CD%\MediCat.USB.v%medicatver%.zip.001" (goto warnhash) else (goto dlcheck3)

REM -- INSTALLER

:warnhash
title Medicat Installer [HASHCHECK]
cls
if exist "%CD%\MediCat.USB*.001" (echo..001 Exists) else (goto gdriveerror)
if exist "%CD%\MediCat.USB*.002" (echo..002 Exists) else (goto gdriveerror)
if exist "%CD%\MediCat.USB*.003" (echo..003 Exists) else (goto gdriveerror)
if exist "%CD%\MediCat.USB*.004" (echo..004 Exists) else (goto gdriveerror)
if exist "%CD%\MediCat.USB*.005" (echo..005 Exists) else (goto gdriveerror)
if exist "%CD%\MediCat.USB*.006" (echo..006 Exists) else (goto gdriveerror)
echo.Hashing files to verify they are not corrupted
timeout 2 >nul
goto hasher


:gdriveerror
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                  DRIVE FILES MISSING                  IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII   IT LOOKS LIKE YOU DOWNLOADED MEDICAT IN PARTS.      IIII
echo.IIII              WE COULDNT FIND ONE OF THEM              IIII
echo.IIII              DID YOU DOWNLOAD ALL SIX??               IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.
echo.
pause
goto bigboi

REM -- CHECK WHICH VERSION USER DOWNLOADED


:installerror
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII        THE INSTALLER COULD NOT FIND MEDICAT           IIII
echo.IIII        PLEASE MANUALLY SELECT THE .7z FILE!           IIII
echo.IIII                                                       IIII
echo.IIII       PRESS ANY KEY TO OPEN THE FILE PROMPT!          IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
pause> nul

set dialog="about:<input type=file id=FILE><script>FILE.click();new ActiveXObject
set dialog=%dialog%('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);
set dialog=%dialog%close();resizeTo(0,0);</script>"

for /f "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "file=%%p"
mode con:cols=100 lines=15
goto install6


REM -- ACTUALLY EXTRACT/INSTALL

:install4
set file="MediCat.USB.v21.12.7z"
set sha256=a306331453897d2b20644ca9334bb0015b126b8647cecec8d9b2d300a0027ea4
set sha1=2cbf5f337849a11084124a79a1b8d7e77eaca7d5
7z x -O%drivepath%: %file% -r -aoa
goto finishup

:install5
set file="MediCat.USB.v%medicatver%.zip.001"
7z x -O%drivepath%: %file% -r -aoa
goto finishup

:install6
7z x -O%drivepath%: "%file%" -r -aoa
goto finishup


REM -- FILE CLEANUP

:finishup
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/icon.ico" -O %drivepath%:/autorun.ico -q
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/hasher/CheckFiles.bat" -O %drivepath%:/CheckFiles.bat -q
cd /d %drivepath%:
start cmd /k CheckFiles.bat
echo.The Installer Has Completed.
pause
exit







::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------
::---------------------------------------------------------------------------------------------------------------------------------------------------




:hasher
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/hasher/drivefiles.md5" -O ./drivefiles.md5 -q
echo.THIS WILL LOOK FROZEN, DONT PANIC, ITS WORKING!
echo.CANCEL AT ANY TIME BY CLOSING THE QUICKSFV BOX!
QuickSFV.EXE drivefiles.md5
DEL drivefiles.md5 /Q
goto install5


:medicatsite
start https://medicatusb.com
goto menu2

:discord
start https://url.medicatusb.com/discord
goto menu2





:dlcheck3
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII         COULD NOT FIND THE MEDICAT FILE(S).           IIII
echo.IIII                                                       IIII
echo.IIII            (EITHER *.001 or the main .7z)             IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII           WOULD YOU LIKE TO DOWNLOAD THEM?            IIII
echo.IIII                       ( Y / N )                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
call Button 10 12 F2 "YES" 46 12 F4 "NO" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 

If /I "%Errorlevel%"=="1" (
	cls & goto bigboi
)
If /I "%Errorlevel%"=="2" (
	cls & goto installerror
)

:bigboi
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII           WOULD YOU LIKE TO USE THE TORRENT           IIII
echo.IIII            TO DOWNLOAD THE LATEST VERSION?            IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
call Button 10 12 F2 "YES" 46 12 F4 "NO" X _Var_Box _Var_Hover
GetInput /M %_Var_Box% /H %_Var_Hover% 
REM BELOW IS YES
If /I "%Errorlevel%"=="1" (
	cls & goto tordown
)
REM BELOW IS NO
If /I "%Errorlevel%"=="2" (
	cls & goto drivedown
)
:drivedown
cls
mode con:cols=64 lines=18
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII           WOULD YOU LIKE TO USE THE TORRENT           IIII
echo.IIII            TO DOWNLOAD THE LATEST VERSION?            IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.IIII             OK USING GOOGLE DRIVE INSTEAD             IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/download/drive.bat" -O ./drive.bat -q
call drive.bat
del drive.bat /Q
goto installversion

:tordown
wget "https://raw.githubusercontent.com/mon5termatt/medicat_installer/main/download/tor.bat" -O ./tor.bat -q
call tor.bat
del tor.bat /Q
goto installversion

:renameprogram





:ascii
mode con:cols=100 lines=55
echo.@@   @@  @@@@@@  @@       @@@@    @@@@   @@   @@  @@@@@@          @@@@@@   @@@@                 
echo.@@   @@  @@      @@      @@  @@  @@  @@  @@@ @@@  @@                @@    @@  @@                
echo.@@ @ @@  @@@@    @@      @@      @@  @@  @@ @ @@  @@@@              @@    @@  @@                
echo.@@@@@@@  @@      @@      @@  @@  @@  @@  @@   @@  @@                @@    @@  @@                
echo. @@ @@   @@@@@@  @@@@@@   @@@@    @@@@   @@   @@  @@@@@@            @@     @@@@                 
echo.                                                                                                
echo.        @@@@@@  @@  @@  @@@@@@          @@   @@  @@@@@@  @@@@@   @@@@@@   @@@@    @@@@   @@@@@@ 
echo.          @@    @@  @@  @@              @@@ @@@  @@      @@  @@    @@    @@  @@  @@  @@    @@   
echo.          @@    @@@@@@  @@@@            @@ @ @@  @@@@    @@  @@    @@    @@      @@@@@@    @@   
echo.          @@    @@  @@  @@              @@   @@  @@      @@  @@    @@    @@  @@  @@  @@    @@   
echo.          @@    @@  @@  @@@@@@          @@   @@  @@@@@@  @@@@@   @@@@@@   @@@@   @@  @@    @@   
echo.                                                                                                
echo.                @@@@@@  @@  @@   @@@@   @@@@@@   @@@@   @@      @@      @@@@@@  @@@@@           
echo.                  @@    @@@ @@  @@        @@    @@  @@  @@      @@      @@      @@  @@          
echo.                  @@    @@ @@@   @@@@     @@    @@@@@@  @@      @@      @@@@    @@@@@           
echo.                  @@    @@  @@      @@    @@    @@  @@  @@      @@      @@      @@  @@          
echo.                @@@@@@  @@  @@   @@@@     @@    @@  @@  @@@@@@  @@@@@@  @@@@@@  @@  @@          
echo.												
echo.  .........                                                              .........  
echo.  ................                     ......                     ................  
echo.  .....................       ........................       .....................  
echo.  .... ................. .................................  ................. ...   
echo.   ... [101m0@@@00ooo[0m....................................................[101mooo00@@@0[0m ...   
echo.   ... [101mo@@@@@@@@@0o[0m..............................................[101mo@@@@@@@@@@o[0m ...   
echo.    ....[101m0@@@@@@0o[0m..................................................[101mo@@@@@@@0[0m....    
echo.    ... [101mo@@@@@o[0m......................................................[101m0@@@@@o[0m ...    
echo.     ....[101m0@@0[0m.........................................................[101mo@@@0[0m....     
echo.     ... [101m.@0[0m............................................................[101m0@[0m.....     
echo.      ... [101mo[0m..............................................................[101mo[0m ...      
echo.       ... .............................................................  ...       
echo.        .. .............................................................. ..        
echo.          ...........[42mo0o.....ooo[0m....................[42mooo.....o0o[0m...........          
echo.          .........[42mo00o[40m       [42mo00o[0m.......oo.......[42mo000[40m       [42mo00o[0m.........          
echo.         .........[42mo00o[40m         [42m000o[0m......00......[42mo00o[40m         [42m000o[0m........          
echo.         ..........[42mo00[40m         [42m000o[0m ....0@@0.....[42m000o[40m         [42m00o[0m.........          
echo.  ...oooooooooo.....[42mo0o[40m       [42mo00o[0m.....0@@@@0.....[42mo00o[40m       [42mo0o[0m.....oooooooooo...  
echo.  ........ooooooooo...[42mooo...oooo[0m.....o0@@@@@@0o.....[42moooo...ooo[0m..oooooooooo......o.  
echo.       ...........oo................o0@@@@@@@@@o...............ooo...........       
echo.       ..ooooooooooo..............o0@@@@@@@@@@@@0o..............ooooooooooo..       
echo..oooooooooooooooooooo..........oo0@@@@@@@@@@@@@@@@0oo..........ooooooooooooooooooo..
echo....      ...................oo0@@@@@@@@@@@@@@@@@@@@@@0oo...................     ....
echo.          ..ooooooooooooo00@@@@@oo@@@@@@0oo0@@@@@0oo@@@@@00ooooooooooooo..          
echo.        .oooo.o00000@@@@@@@@@@@@@ooooooo000oooooo.o@@@@@@@@@@@@@0000o..oooo.        
echo.      ooo.  .0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0oo0@@@@@@@@@@@@@@@@@@@o. ..oo.      
echo.              .oo0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0oo.              
echo.                  .oo0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0oo.                  
echo.                      ..ooo000@@@@@@@@@@@@@@@@@@@@@@@@000ooo..                      
echo.                              ....oooooooooooooooo....                              
echo.CODED BY MON5TERMATT With Help from AAA3A, Daan Breur, Jayro, and many others. Thanks!
echo.TRANSLATED BY MON5TERMATT
exit/b

:exit
exit
