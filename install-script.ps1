# install-script.ps1

Start-Transcript -Path "C:\install-log.txt" -Append

# Enable TLS 1.2 for all downloads
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Install Chocolatey if not already installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path += ";C:\ProgramData\chocolatey\bin"
}

# Wait for choco to be ready
Start-Sleep -Seconds 5

# Install packages via Chocolatey
$packages = @("python", "git", "googlechrome")
foreach ($pkg in $packages) {
    Write-Output "Installing $pkg..."
    choco install -y $pkg --no-progress --ignore-checksums
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "$pkg failed to install"
    } else {
        Write-Output "$pkg installed successfully."
    }
}

# Add pip to PATH
$pythonPath = "$env:ProgramFiles\Python311\Scripts"
$altPath = "$env:LocalAppData\Programs\Python\Python311\Scripts"
if (Test-Path $pythonPath) {
    $env:Path += ";$pythonPath"
} elseif (Test-Path $altPath) {
    $env:Path += ";$altPath"
}

# Check pip availability
$pipPath = Get-Command pip.exe -ErrorAction SilentlyContinue
if (-not $pipPath) {
    Write-Warning "pip not found"
    Stop-Transcript
    exit 1
}

# Install Python packages
Write-Output "Installing Robot Framework packages..."
pip install -U pip
pip install robotframework
pip install robotframework-seleniumlibrary

Write-Output "Installation complete."
Stop-Transcript
