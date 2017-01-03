@echo off
rem Modify to your needs

set OUTDIR=.\yadvetmp
for /f "delims=" %%a in ('hostname') do @set HNAME=%%a
set ENC=ffmpeg.exe
set SED=sed.exe
set /p OPTS=<%OUTDIR%\opts
set /p TARGETSUFFIX=<%OUTDIR%\targetsuffix
set VERBOSE=verbose

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
%SED% -i.bak -e "s/%NEXT%/%NEXT% RUNNING %HNAME%/g" %OUTDIR%\status
attrib +r +s sed.exe
del sed*
attrib -r -s sed.exe
%ENC% -y -v %VERBOSE% -i %OUTDIR%\%NEXT% %OPTS% %OUTDIR%\%NEXT%.enc.%TARGETSUFFIX%
IF %ERRORLEVEL% NEQ 0 (
%SED% -i -e "s/%NEXT% RUNNING/%NEXT% ERROR/g" %OUTDIR%\status
attrib +r +s sed.exe
del sed*
attrib -r -s sed.exe
echo Error during encoding %NEXT%
exit /b
) ELSE (
%SED% -i -e "s/%NEXT% RUNNING/%NEXT% OK/g" %OUTDIR%\status
attrib +r +s sed.exe
del sed*
attrib -r -s sed.exe
GOTO STARTENC
)
)

