# FreeCommander XE Total7zip Plugin Installer

This is a PowerShell script that automatically install the latest version of the Total7zip plugin for FreeCommander XE.

7-Zip is one of the most complete archivers supporting a huge range of compressed file types. Total7zip plugin does not require 7-Zip to be installed on the device.

## Current 7-Zip library version
* 19.0

## Tested with
* FreeCommander XE Build 830 (32 and 64 bits)

## Features
* Automatic download and installation of the latest 7-Zip version of the plugin
* Automatic configuration of FreeCommander XE with the appropriate file associations (7z, xz, bzip2, gzip, tar, zip, arj, cab, chm, cpio, cramfs, deb, dmg, fat, hfs, iso, lzh, lzma, mbr, msi, nsis, ntfs, rar, rpm, squashfs, udf, vhd, wim, xar, z, gz)
* Run again to update the 7-Zip version to the latest version (if available)
* Backup of the original configuration files before doing any changes
* Works with 32-bit and 64-bit versions of FreeCommander
* No need to install 7-Zip on the device

## Instructions
* Download and run the *total7zipinstaller.ps1* script.

## Note about the download source
* The Total7zip package is available in the [GitHub repository](https://github.com/danpeig/freecommander_total7zip_installer) but due hosting limitations, the script downloads from my personal web-page.

## Credits
* 7-Zip Copyright © 1999-2020 Igor Pavlov (https://www.7-zip.org/)
* Total 7-Zip plugin from TotalCmd.net (http://totalcmd.net/plugring/Total7zip.html)
* FreeCommander XE Copyright © 2004-2020 Marek Jasinski (www.freecommander.com)

## Bugs and feature requests
* Please contact me at www.danbp.org
