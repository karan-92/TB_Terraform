@echo off
setlocal EnableDelayedExpansion

:: ===============================
:: STAP 1: INSTALLATIE PYTHON
:: ===============================
echo [1/4] Downloading and installing Python 3.10...
curl -o "%TEMP%\python-3.10.0-amd64.exe" https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe
start /wait "" "%TEMP%\python-3.10.0-amd64.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

:: Verifieer Python installatie
if not exist "C:\Program Files\Python310\python.exe" (
    echo Python installatie is mislukt.
    pause
    exit /b 1
)

:: Voeg Python toe aan PATH (voor deze sessie)
set PATH=%PATH%;C:\Program Files\Python310;C:\Program Files\Python310\Scripts

:: ===============================
:: STAP 2: INSTALLATIE PIP PACKAGES
:: ===============================
echo [2/4] Upgrading pip and installing Robot Framework packages...
python -m pip install --upgrade pip
python -m pip install robotframework robotframework-seleniumlibrary

:: ===============================
:: STAP 3: INSTALLATIE VISUAL STUDIO CODE
:: ===============================
echo [3/4] Downloading and installing Visual Studio Code...
curl -L -o "%TEMP%\VSCodeSetup-x64.exe" "https://update.code.visualstudio.com/latest/win32-x64-user/stable"
start /wait "%TEMP%\VSCodeSetup-x64.exe" /silent /mergetasks=!runcode

:: Zoek installatiepad van VS Code
set "vscode_path="
if exist "C:\Program Files\Microsoft VS Code\bin\code.cmd" (
    set "vscode_path=C:\Program Files\Microsoft VS Code"
) else if exist "%LocalAppData%\Programs\Microsoft VS Code\bin\code.cmd" (
    set "vscode_path=%LocalAppData%\Programs\Microsoft VS Code"
)

if not defined vscode_path (
    echo Visual Studio Code is niet gevonden. Installatie mislukt.
    pause
    exit /b 1
)

:: Voeg VS Code toe aan PATH
set PATH=%PATH%;%vscode_path%\bin

:: ===============================
:: STAP 4: INSTALLATIE ROBOTCODE EXTENSIE
:: ===============================
echo [4/4] Installing RobotCode extension...
code --install-extension d-biehl.robotcode --force

echo ✅ Installatie voltooid!
pause
exit /b 0
