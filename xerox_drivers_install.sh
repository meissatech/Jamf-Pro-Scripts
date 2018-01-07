#!/bin/bash

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
