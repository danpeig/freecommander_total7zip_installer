#
# Total7zip Plugin Installer for FreeCommander XE
# This script was written by Daniel Brooke Peig (www.danbp.org)
#
# 7-Zip Copyright (C) 1999-2020 Igor Pavlov.
# Original Total 7-Zip plugin from TotalCmd.net (http://totalcmd.net/plugring/Total7zip.html)
#

#Configurations
#$defaultInstallPath64 = "$PSScriptRoot\FreeCommander" #Test root folder
$defaultInstallPath64 = "$Env:Programfiles\FreeCommander XE"
$defaultInstallPath32 = "$Env:Programfiles(x86)\FreeCommander XE"
$defaultConfigPath = "$Env:LOCALAPPDATA\FreeCommanderXE\Settings"
#$defaultConfigPath = "$PSScriptRoot\FreeCommanderConfig" #Test config file
$tempFolderName = "TEMP_FOLDER"
$downloadURL_01 = "https://www.danbp.org/downloads/Total7Zip.zip"
$downloadFile_01 = "Total7Zip.zip"
$pluginVersion = "0" #32 or 64 bits

# Introductions
Write-Output "`n------------------------------------------------------------------------------------"
Write-Output "Welcome to the Total7Zip Installer for FreeCommander XE by Daniel BP (www.danbp.org)"
Write-Output "--------------------------------------------------------------------------------------`n"
Write-Output "This script will download, install and configure the latest version of 7-zip plugin."
Write-Output "`nElevated permissions will be required...`n"
pause
Write-Output "`nPlease make sure you ended FreeCommander XE process including the notification bar icon. If you don't do this the configuration files will not be updated!`n"
pause

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-Noexit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
    }
}

Write-Output "`n`n"

# Ask for the installation path
$InstallPath = Read-Host -Prompt "Please enter the full FreeCommander install path or press ENTER for the default `"Program Files`" or `"Program Files (x86)`""
if ([string]::IsNullOrWhiteSpace($InstallPath))
{
    Write-Output "Using the system `"Program Files`" directories"
    Write-Output "Checking if the FreeCommander XE exists in the default `"Program Files`" directories..."
    if (Test-Path -Path "$defaultInstallPath64\FreeCommander.exe") {
        Write-Output "64-bits version found here: $defaultInstallPath64!"
        $InstallPath = $defaultInstallPath64
        $pluginVersion = "64"
    }
    elseif (Test-Path -Path "$defaultInstallPath32\FreeCommander.exe"){
        Write-Output "32-bits version found here: $defaultInstallPath32!"
        $InstallPath = $defaultInstallPath32
        $pluginVersion = "32"
    }
    else {
        Write-Output "`n`nERROR! No version found in the default paths!"
        exit
    }
}
# Check if the user installation path is correct
else {
    Write-Output "Checking if FreeCommander XE exists in the target folder..."
    if (Test-Path -Path "$InstallPath\FreeCommander.exe") {
        Write-Output "FreeCommander XE found in the user defined directory: $InstallPath!"
        #Ask the user the plugin version
        while(($pluginVersion -ne "32") -and ($pluginVersion -ne "64")) {
            $pluginVersion = Read-Host -Prompt "Please type `"32`" or `"64`" according to the version of FreeCommander you have:`n"
        }
    }
        else {
        Write-Output "`n`nERROR! No program found in the user specified path!"
        exit
    }
}

# Ask for the configuration path
$ConfigPath = Read-Host -Prompt "Please enter the FreeCommander.ini path or press ENTER for the default (`"..\AppData\Local\FreeCommander\Settings`")`n"
if ([string]::IsNullOrWhiteSpace($ConfigPath))
{
    Write-Output "Checking if the configuration files exist in the default directory..."
    if (Test-Path -Path "$defaultConfigPath\FreeCommander.ini") {
        Write-Output "Configuration files found here: $defaultConfigPath!"
        $ConfigPath = $defaultConfigPath
    }
    else {
        Write-Output "`n`nERROR! No configuration files found in the default user paths!"
        exit
    }
}
# Check if the user installation path is correct
else {
    Write-Output "Checking if FreeCommander XE exists in the target folder..."
    if (Test-Path -Path "$ConfigPath\FreeCommander.ini") {
        Write-Output "FreeCommander.ini path is correct!"
    }
    else {
        Write-Output "`n`nERROR! No configuration files found in the specified path!"
        exit
    }
}

# Creates a temporary directory for the downloaded files
Write-Output "Creating a temporary directory..."
if ( -Not (Test-Path "$PSScriptRoot\$tempFolderName"))
{
try{
 New-Item -Path "$PSScriptRoot\$tempFolderName" -ItemType Directory | out-null
}
catch {
    Write-Output "ERROR! Failed to create the temporary directory!"
}
}

# Download the package files
Write-Output "Downloading the latest version of the package files...."
$output = "$PSScriptRoot\$tempFolderName\$downloadFile_01"
$wc = New-Object System.Net.WebClient
try {
    $wc.DownloadFile($downloadURL_01, $output)
}
catch {
    Write-Output "ERROR! Download failed!"
    exit
}

# Unpack the downloaded files
Write-Output "Unpacking the files..."
try {
  Expand-Archive -LiteralPath "$PSScriptRoot\$tempFolderName\$downloadFile_01" -DestinationPath "$PSScriptRoot\$tempFolderName" -Force
}
catch {
    Write-Output "ERROR! Failed to unpack the files!"
    exit
}

# Modify the paths in the downloaded installation configuration files
Write-Output "Updating the plugin XML configuration..."
try {
    (Get-Content $PSScriptRoot\$tempFolderName\Plugins\wcx\Total7zip\total7zip.xml) -replace 'INSTALL_PATH', "$InstallPath" | Set-Content $PSScriptRoot\$tempFolderName\Plugins\wcx\Total7zip\total7zip.xml
}
catch {
    Write-Output "ERROR! Failed to configure the XML file!"
    exit
}

# Copy the directories to the FreeCommander installation folder
Write-Output "Copying the files to the FreeCommander installation folder..."
try {
    Copy-Item -Path "$PSScriptRoot\$tempFolderName\Plugins" -Destination "$InstallPath" -Recurse -Force
}
catch {
    Write-Output "ERROR! Failed to copy the plugin to the installation folder!"
    exit
}

# Create a backup of the INI file (yeah! I care about my users)
Write-Output "Backing up the original configuration file..."
for(($countBkp = 0), ($backupFlag = "false"); ($countBkp -le 255) -and ($backupFlag -eq "false"); $countBkp++){
    if ( -Not (Test-Path "$ConfigPath\FreeCommander_BKP$countBkp.ini")){
        try {
            Copy-Item -Path "$ConfigPath\FreeCommander.ini" -Destination "$ConfigPath\FreeCommander_BKP$countBkp.ini" -Recurse -Force
        }
        catch {
            Write-Output "ERROR! Failed to backup the INI file."
            exit
        }
        Write-Output "Backup filename: $ConfigPath\FreeCommander_BKP$countBkp.ini"
        $backupFlag = "true";

    }
}

# Modify the INI files and enable 7-Zip plugin
Write-Output "Updating the FreeCommander.ini file..."
$pluginCount = 1
$total7zipIndex = -1
$fcZipIndex = -1
$fcRarIndex = -1
$iniFile = Get-Content "$ConfigPath\FreeCommander.ini"
$lastPluginsLineIndex = -1

#Find all installed archiver plugins
foreach($line in $iniFile) {
    if($line -match "Title$pluginCount"){
        if($line -match "Total7zip") {
            Write-Output "Total7zip found in index: $pluginCount"
            $total7zipIndex = $pluginCount
        }
        if($line -match "fcZip") {
            Write-Output "FCZip found in index: $pluginCount"
            $fcZipIndex = $pluginCount
        }
        if($line -match "fcRar") {
            Write-Output "FCRar found in index: $pluginCount"
            $fcRarIndex = $pluginCount
        }
        $pluginCount++
    }
}

#Adjusts the counter
$pluginCount = $pluginCount-1
Write-Output "Found $pluginCount archiver plugins"

#Disable the existing archiver plugins and configure the 7-Zip plugin
$lineIndex = 0;
foreach($line in $iniFile) { 
    if($line -match "fc_internal_zip"){
        $line = $line -replace "=-1", "=0"
        Write-Output "Disabled the fcZip plugin."
        $iniFile[$lineIndex] = $line
    }
    if($line -match "fc_internal_rar"){
        $line = $line -replace "=-1", "=0"
        Write-Output "Disabled the fcRar plugin."
        $iniFile[$lineIndex] = $line
    }
    if($line -match "^Ext$total7zipIndex="){
        $line = "Ext$total7zipIndex=7z.xz.bzip2.gzip.tar.zip.arj.cab.chm.cpio.cramfs.deb.dmg.fat.hfs.iso.lzh.lzma.mbr.msi.nsis.ntfs.rar.rpm.squashfs.udf.vhd.wim.xar.z.gz"
        Write-Output "Updated the Total7zip extension associations."
        $iniFile[$lineIndex] = $line
    }
    if($line -match "^File$total7zipIndex="){
        if($pluginVersion -eq "32") {
            $line = "File$total7zipIndex=-1,735,`"$InstallPath\Plugins\wcx\Total7zip\Total7zip.wcx`",0"
            Write-Output "Updated the Total7zip path and enabled the 32-bit plugin."
        }
        if($pluginVersion -eq "64") {
            $line = "File$total7zipIndex=-1,735,`"$InstallPath\Plugins\wcx\Total7zip\Total7zip.wcx64`",0"
            Write-Output "Updated the Total7zip path and enabled the 64-bit plugin."
        }
        $iniFile[$lineIndex] = $line
    }
    if($line -match "^SfxFile$pluginCount="){
        $lastPluginsLineIndex = $lineIndex
    }
    $lineIndex++;
}

#If the plugin was not installed, perform the installation
if($total7zipIndex -eq -1){
    if($lastPluginsLineIndex -ge 0){
        $pluginIndex = $pluginCount+1;
        if($pluginVersion -eq "32") {
            $pluginConfig = "`nTitle$pluginIndex=Total7zip`nExt$pluginIndex=7z.xz.bzip2.gzip.tar.zip.arj.cab.chm.cpio.cramfs.deb.dmg.fat.hfs.iso.lzh.lzma.mbr.msi.nsis.ntfs.rar.rpm.squashfs.udf.vhd.wim.xar.z.gz`nFile$pluginIndex=-1,735,`"$InstallPath\Plugins\wcx\Total7zip\Total7zip.wcx`",0`nSfxFile$pluginIndex=$InstallPath\FCSFXStub.exe`n"
            Write-Output "Created and enabled the 32-bit plugin configuration entry."
        }
        if($pluginVersion -eq "64") {
            $pluginConfig = "`nTitle$pluginIndex=Total7zip`nExt$pluginIndex=7z.xz.bzip2.gzip.tar.zip.arj.cab.chm.cpio.cramfs.deb.dmg.fat.hfs.iso.lzh.lzma.mbr.msi.nsis.ntfs.rar.rpm.squashfs.udf.vhd.wim.xar.z.gz`nFile$pluginIndex=-1,735,`"$InstallPath\Plugins\wcx\Total7zip\Total7zip.wcx64`",0`nSfxFile$pluginIndex=$InstallPath\FCSFXStub.exe`n"
            Write-Output "Created and enabled the 64-bit plugin configuration entry."
        }
        $iniFile[$lastPluginsLineIndex] += $pluginConfig
    }

}

#Write the final configuration file
Write-Output "Writing the final configuration file..."
try{ 
    $iniFile | Set-Content -Path "$ConfigPath\FreeCommander.ini"
} catch{
    Write-Output "ERROR! Failed to write the configuration file!"
    exit
}

# Delete the temporary folder
Write-Output "Deleting the temporary directory..."
try{ 
    Remove-Item -Path "$PSScriptRoot\$tempFolderName" -Recurse
} catch{
    Write-Output "ERROR! Failed to delete the temporary folder. Try doing this manually!"
}

# Final output for the user
Write-Output "`n`n`nIf you dont see any errors the script was sucessfully installed! Thank you!"
