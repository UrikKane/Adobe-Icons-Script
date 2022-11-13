@echo off
setlocal enabledelayedexpansion
title %~n0

:check_elevation
net session >nul 2>&1
if not %errorlevel%==0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

:: Shortcuts to rewrite (notice not including the year bc it changes every year). The .ico files must have these exact names (same folder as script)
set links="Adobe Photoshop" "Adobe After Effects" "Adobe Audition" "Adobe Lightroom Classic" "Adobe Media Encoder" "Adobe Premiere Pro"

:: Installation folder for all apps, change if not default
set "adobefolder=%programfiles%\Adobe"

for /f "tokens=1-3 delims=" %%A in ('dir "%programdata%\Microsoft\Windows\Start Menu\Programs\Adobe*.lnk" /b /a:-d /o:n') do CALL :ProcessLink "%%~nA"
timeout /t 3
goto :eof

:ProcessLink
:: this line makes sure to skip shortcuts for any apps containing the word "CC" and years prior to 2020 (legacy icons)
for %%A in (CC,2019,2018,2017,2016,2015,2014) do (( echo "%~1"| find "%%~A" >nul 2>&1) && ( echo %~1 - skip & goto :eof))
:: run the shortcut generation routine for all links that (even partially) match the %links% variable entries
for %%A in (%links%) do (( echo "%~1"| find "%%~A" >nul 2>&1) && ( CALL :GenerateShortcut "%~1" "%%~A"))
goto :eof

:GenerateShortcut
:: if application .exe and new custom icon exist, generate new shortcut
if exist "%adobefolder%\%~1\%~2.exe" if exist "%~dp0%~2.ico" (
	powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%programdata%\Microsoft\Windows\Start Menu\Programs\%~1.lnk');$s.TargetPath='%adobefolder%\%~1\%~2.exe';$s.IconLocation='%~dp0%~2.ico';$s.Save()"
	if !errorlevel!==0 echo %~1 - ok
	goto :eof
)
:: this is for apps where .exe filename is only one word, like photoshop etc
for /f "tokens=2 delims= " %%A in ('echo %~2') do (
	if exist "%adobefolder%\%~1\%%~A.exe" if exist "%~dp0%~2.ico" (
		powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%programdata%\Microsoft\Windows\Start Menu\Programs\%~1.lnk');$s.TargetPath='%adobefolder%\%~1\%%~A.exe';$s.IconLocation='%~dp0%~2.ico';$s.Save()"
		if !errorlevel!==0 echo %~1 - ok
		goto :eof
	)
)
goto :eof