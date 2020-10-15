# FreeCommander XE Total7zip Plugin Installer

This is a PowerShell script for the automatic installation of the latest version of the Total7zip plugin in FreeCommander XE.

7-Zip is one of the most complete archivers supporting a huge range of compressed file types. Total7zip plugin does not require 7-Zip to be installed on the device.

## Current 7-Zip library version
* 19.0

## Tested with
* FreeCommander XE Build 830 (32 and 64-bit)

## Features
* Automatic download and installation of the latest version of the Total7zip plugin. 
* Automatic configuration of FreeCommander XE for the appropriate file associations (7z, xz, bzip2, gzip, tar, zip, arj, cab, chm, cpio, cramfs, deb, dmg, fat, hfs, iso, lzh, lzma, mbr, msi, nsis, ntfs, rar, rpm, squashfs, udf, vhd, wim, xar, z, gz)
* Run again to update the 7-Zip version to the latest version (if available). 
* Automatic backup of the original configuration files before performing any changes. 
* Works with 32-bit and 64-bit versions of Free Commander. 
* No need to install 7-Zip on the device.
* Open Source for maximum transparency. 

## Instructions
1. Terminate the FreeCommander XE application
2. Download and run the *total7zipinstaller.ps1* script.
3. If you are running FreeCommander from a custom installation directory (ex. portable version), enter the full directory path, otherwise just continue.
4. If you selected a custom installation path, type the version of FreeCommander you are using: 32 or 64.
5. If your FreeCommander configuration files are in a custom directory (ex. portable version), enter the full path for the configuration directory, otherwise just continue.
6. After the installation, start FreeCommander and test packing and unpacking a *7z* file. 
 


## Note about the package download source
* The Total7zip ZIP package is available in the [GitHub repository](https://github.com/danpeig/freecommander_total7zip_installer) but due hosting limitations, the script downloads from my personal Web-page. Both files are identical. 

## Credits
* 7-Zip Copyright © 1999-2020 Igor Pavlov (https://www.7-zip.org/)
* Total 7-Zip plugin from TotalCmd.net (http://totalcmd.net/plugring/Total7zip.html)
* FreeCommander XE Copyright © 2004-2020 Marek Jasinski (www.freecommander.com)

## Bugs and feature requests
* Please contact me at www.danbp.org
