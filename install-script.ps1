# install-script.ps1

# Enable script execution and TLS 1.2
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Log output
$logPath = "$env:SystemDrive\install-log.txt"
Start-Transcript -Path $logPath -Append

# Install Chocolatey if not already installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install required packages
$packages = @("python", "git", "googlechrome", "chromedriver")

foreach ($pkg in $packages) {
    Write-Output "Installing $pkg..."
    choco install -y $pkg --ignore-checksums --no-progress
    if ($LASTEXITCODE -ne 0) {
        Write-Error "$pkg installation failed"
    }
}

# Add Python scripts to PATH
$env:Path += ";C:\Python311\Scripts"

# Install Python packages
Write-Output "Installing Robot Framework & SeleniumLibrary..."
pip install -U pip
pip install robotframework
pip install robotframework-seleniumlibrary

Stop-Transcript
