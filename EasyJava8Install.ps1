# Very stupid simple script to do a very rough check if java 8 is installed,
# install adopt open JDK 8 if it isn't (using ninite), then run game pointing to 
# the java 8 executable

# 4-28-23

# Grab current location of script
$currentDirectory = $PSScriptRoot

# Setup directory for temporary Java download
$javaDirTemp = "$currentDirectory\TempJavaDownload"

# Java download URL
$javaDownloadURL = "https://ninite.com/adoptjavax8/ninite.exe"

# Check versions of Java installed
$nativeJavaInstalled = Get-Command Java | Select-Object Version

if ($nativeJavaInstalled.version.major -notlike "*8*" -and !(Test-Path -LiteralPath "$currentDirectory\Java8Installed.txt"))
    {
        # Make Directory to download ninite installer
        $hush = Mkdir -Path "$javaDirTemp" -Force

        # Download and save the ninite installer/bootstrapper
        Invoke-WebRequest -Uri $javaDownloadURL -OutFile $javaDirTemp\NiniteInstaller.exe -MaximumRedirection 100

        # Run ninite installer
        Start-Process -FilePath "$javaDirTemp\NiniteInstaller.exe" -Wait

        # Delete temp folder
        $hush = rmdir -Path "$javaDirTemp" -Force -Recurse

        # Drop little breadcrumb saying it's been installed (if using script to always launch game)
        "Java8Installed" | Out-File -FilePath "$currentDirectory\Java8Installed.txt" -Force
    }

# Start game
