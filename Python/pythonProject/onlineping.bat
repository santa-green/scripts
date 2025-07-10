@echo off
REM Batch script to stop and start Notepad

set "programName=OnlinePing.exe"
set "programPath=C:\Users\rumiantsev\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\NixSolutions LTD\OnlinePing\OnlinePing.appref-ms"

echo Stopping %programName%...
taskkill /F /IM %programName%

timeout /t 5 /nobreak >nul

echo Starting %programName%...
start "" "%programPath%"

echo Done.
pause
