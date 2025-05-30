@echo off
setlocal

:: ─── 1. Locate this script and set DEST to a "videos" subfolder ───────────
set "SCRIPT_DIR=%~dp0"
set "DEST=%SCRIPT_DIR%videos"

:: ─── 2. Create the folder if it doesn't exist ─────────────────────────────
if not exist "%DEST%" (
    mkdir "%DEST%"
)

:: ─── 3. Prompt for the video URL ──────────────────────────────────────────
set /p URL=Enter video URL:

:: ─── 4. Download into videos\—the -o template handles naming for us ────────
"%SCRIPT_DIR%yt-dlp.exe" -o "%DEST%\%%(title)s.%%(ext)s" "%URL%"

:: ─── 5. Find the newest file in videos\ (i.e., your download) ─────────────
set "NEWFILE="
for /f "delims=" %%F in ('dir "%DEST%\*.*" /b /a:-d /o:-d') do (
    set "NEWFILE=%%F"
    goto gotfile
)
:gotfile

if not defined NEWFILE (
    echo ERROR: No files found in %DEST%
    pause
    goto :eof
)

set "NEWPATH=%DEST%\%NEWFILE%"

:: ─── 6. Report & copy to clipboard ────────────────────────────────────────
echo.
echo Download complete!
echo File: %NEWPATH%
echo %NEWPATH% | clip
echo (Path copied to clipboard)

pause
