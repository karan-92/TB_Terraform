# install-script.ps1

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Installeer Python, Git en Google Chrome
choco install -y python git googlechrome

# Voeg pip scripts toe aan PATH
$env:Path += ";C:\Python311\Scripts"

# Installeer Robot Framework + Selenium
pip install -U pip
pip install robotframework
pip install robotframework-seleniumlibrary

# Download en installeer ChromeDriver (versie afgestemd op geïnstalleerde Chrome)
choco install -y chromedriver --ignore-checksums
