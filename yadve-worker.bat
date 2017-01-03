@echo off
rem Modify to your needs

set OUTDIR=.\yadvetmp
for /f "delims=" %%a in ('hostname') do @set HNAME=%%a
set ENC="c:\ffmpeg\bin\ffmpeg.exe"
set /p OPTS=<%OUTDIR%\opts
set /p TARGETSUFFIX=<%OUTDIR%\targetsuffix
set VERBOSE="verbose"

:START

IF EXIST %OUTDIR%\splitfin (
GOTO STARTENC
) ELSE (
echo wait a bit ..
PING localhost -n 6 > NUL
GOTO START
)

:STARTENC
rem @echo on


for /f "delims=" %%b in ('type %OUTDIR%\status ^| findstr /V OK ^| findstr /V RUNNING ^| findstr /V ERROR ^| ..\sed -n 1p') do @set NEXT=%%b
if %NEXT%==END (
echo Encoding finished
exit /b
) ELSE (
sed.exe -e "s/%NEXT%/%NEXT% RUNNING %HNAME%/g" %OUTDIR%\status
%ENC% -y -v %VERBOSE% -i %OUTDIR%\%NEXT% %OPTS% %OUTDIR%\%NEXT%.enc.%TARGETSUFFIX%
IF %ERRORLEVEL% NEQ 0 (
sed.exe -e "s/%NEXT% RUNNING/%NEXT% ERROR/g" %OUTDIR%\status
echo Error during encoding %NEXT%
exit /b
) ELSE (
sed.exe -e "s/%NEXT% RUNNING/%NEXT% OK/g" %OUTDIR%\status
GOTO STARTENC
)
)

