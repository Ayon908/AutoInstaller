#/////////////////////////////////////

Write-Host "Installing NodeJs"
Invoke-WebRequest -Uri "https://nodejs.org/dist/v16.13.0/node-v16.13.0-x64.msi" -OutFile "C:\node-v16.13.0-x64.msi"
Start-Process -FilePath "C:\node-v16.13.0-x64.msi" -ArgumentList "/quiet", "/norestart" -Wait

# Find the installation paths for Node.js and npm
$nodejsPath = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Node.js
if ($nodejsPath) {
    $nodejsInstallPath = $nodejsPath.InstallPath
    $env:Path += ";$nodejsInstallPath"
}

$appDataPath = [System.Environment]::GetFolderPath("ApplicationData")
$npmPath = Join-Path $appDataPath "npm"
if (Test-Path $npmPath) {
    $env:Path += ";$npmPath"
}

Write-Host "NodeJs Installation Complete"

Write-Host "Installing Appium"
npm install -g appium@latest
Write-Host "Appium Installation Completed"


Write-Host "Downloading and installing Python. Press Yes"
$url = "https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe"
$output = "$env:TEMP\python-3.9.0-amd64.exe"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -Args "/passive InstallAllUsers=1 PrependPath=1" -Wait

# Find the installation paths for Python
$pythonInstallPath = Get-ChildItem -Path "C:\Program Files" -Filter "Python39" -Directory | Select-Object -First 1
if ($pythonInstallPath) {
    $env:Path += ";$($pythonInstallPath.FullName)"
    $env:Path += ";$($pythonInstallPath.FullName)\Scripts"
}

Write-Host "Python Installation Completed"

# Upgrade pip and install packages
Write-Host "Upgrading PIP and installing Pytest, Pytest-Bdd, and allure-combine"
python -m pip install --upgrade pip
pip install -U pytest
pip install pytest-bdd
pip install allure-combine
Write-Host "Installation completed"





Write-Host "Installing WinAPPDriver"
$url = "https://github.com/Microsoft/WinAppDriver/releases"
$output = "$env:TEMP\WinAppDriver.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process msiexec.exe -Wait -ArgumentList "/I $output /quiet"
Write-Host "WinApp Driver installed"

Write-Host "Downloading Scoop"
#installing scoop
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
iwr -useb get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -RunAsAdmin
Write-Host "Scoop Downloaded"

Write-Host "Updating scoop and installing Allure"
scoop install git
scoop update

#installing allure
scoop install allure

Write-Host "All Files successfully Installed. Thank you"