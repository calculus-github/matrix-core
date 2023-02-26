@echo off
cls

rem prepare loop 
Set Sleep=0  
:start

rem loop 40 times
if %Sleep% == 40 ( goto end )

rem pick random numbers 1-16
set /a rand1=%random% %% 16
set /a rand2=%random% %% 16

rem user 
set HEX=0123456789ABCDEF
call set hexcolors=%%HEX:~%rand1%,1%%%%HEX:~%rand2%,1%%

rem set back/fore colors
color %hexcolors%
echo loop#%Sleep% color=%hexcolors%

rem the pings act as a split-second delay   
PING localhost -n 1 >NUL
PING localhost -n 1 >NUL

rem increment counter and loop
Set /A Sleep+=1
goto start
:end

rem close after 3 seconds
timeout /t 3