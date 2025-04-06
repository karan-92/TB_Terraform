# install-script.ps1

# Zet execution policy en beveiliging
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Download en installeer Visual Studio Code (User installer)
$vsInstaller = "$env:TEMP\\vscode-setup.exe"
Invoke-WebRequest -Uri "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -OutFile $vsInstaller
Start-Process -FilePath $vsInstaller -ArgumentList '/silent', '/mergetasks=!runcode' -Wait

# Download en installeer Python
$pythonInstaller = "$env:TEMP\\python-installer.exe"
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.11.7/python-3.11.7-amd64.exe" -OutFile $pythonInstaller
Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_test=0" -Wait

# Voeg Scripts folder toe aan PATH voor deze sessie
$env:Path += ";$env:LOCALAPPDATA\\Programs\\Python\\Python311\\Scripts"

# Installeer Robot Framework tooling
pip install -U pip
pip install robotframework
pip install robotframework-browser
rfbrowser init

# VS Code extensies installeren (RobotCode + Python)
$codeCmd = \"$env:LOCALAPPDATA\\Programs\\Microsoft VS Code\\bin\\code\"
& $codeCmd --install-extension daniel-biehl.robotcode
& $codeCmd --install-extension ms-python.python
& $codeCmd --install-extension ms-python.vscode-pylance

# VS Code settings.json configureren
$settingsPath = \"$env:APPDATA\\Code\\User\\settings.json\"

@"
{
  \"python.defaultInterpreterPath\": \"C:\\\\Users\\\\$env:USERNAME\\\\AppData\\\\Local\\\\Programs\\\\Python\\\\Python311\\\\python.exe\",
  \"python.languageServer\": \"Pylance\",
  \"robotcode.python.interpreter\": \"C:\\\\Users\\\\$env:USERNAME\\\\AppData\\\\Local\\\\Programs\\\\Python\\\\Python311\\\\python.exe\",
  \"robotcode.robotframework.libraries.builtin\": true,
  \"robotcode.robotframework.libraries.thirdparty\": true
}
"@ | Out-File -Encoding UTF8 -FilePath $settingsPath -Force
