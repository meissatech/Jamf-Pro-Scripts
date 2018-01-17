#!/bin/bash


###
#
#            Name:  xerox_drivers_install_latest.sh
#     Description:  This script download ans installs Xerox Printer Drivers for
#					macOS devices directly from Apple's website. 
#          Author:  Stephen Weinstein
#         Created:  2018-01-17
#   Last Modified:  2018-01-17
#
###




mkdir ~/xerox_driver_install_temp
cd ~/xerox_driver_install_temp

# Installing Xerox Driver
curl -L -o xeroxdrivers.dmg "http://support.apple.com/downloads/DL1861/en_US/xeroxprinterdrivers4.1.dmg"
hdiutil mount -nobrowse xeroxdrivers.dmg

installer -pkg /Volumes/Xerox\ Printer\ Drivers/XeroxPrinterDrivers.pkg -target /
echo "Installer done"
hdiutil unmount "/Volumes/Xerox Printer Drivers"
echo "Printer ready to drive"
rm xeroxdrivers.dmg
rmdir ~/xerox_driver_install_temp



find /Volumes -maxdepth 1 -not -user root -print0 | xargs -0 diskutil eject
exit 0
