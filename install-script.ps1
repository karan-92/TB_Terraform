# install-script.ps1

# Zet script policies
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Installeer Chocolatey (alleen als niet aanwezig)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Installeer Python, Git en Google Chrome
choco install -y python git googlechrome

# Zorg dat pip scripts in PATH zitten
$env:Path += ";C:\Python311\Scripts"

# Installeer Robot Framework + Selenium
pip install -U pip
pip install robotframework
pip install robotframework-seleniumlibrary
