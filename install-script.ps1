# install-script.ps1

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y python vscode git

$env:Path += ";C:\Python311\Scripts"

pip install robotframework
pip install robotframework-browser
rfbrowser init
