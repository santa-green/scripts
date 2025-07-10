@echo off

color 3

echo "Hung tasks on "

tasklist /fi "STATUS eq NOT RESPONDING"


echo:

echo "Sure want to close these hung tasks, brother? You can just tap "Ctrl+C" to stop..."

echo:

pause


echo:


cls

color 4c

for /L %%n in (1,1,3) do echo ------------------------------WARNING! TERMINATION IS ACTIVATED IN...------------------------------

timeout /nobreak /t 3


echo:

echo Sequence for user "%username%" STARTED: %date% %time%

taskkill /f /t /fi "STATUS eq NOT RESPONDING"

echo:

echo Sequence for user "%username%" COMPLETED: %date% %time%

echo:

pause



exit