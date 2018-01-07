#!/bin/bash

mkdir ~/hp_driver_install_temp
cd ~/hp_driver_install_temp

# Installing HP Printer Drivers
curl -L -o hpdrivers.dmg "http://support.apple.com/downloads/DL1888/en_US/HewlettPackardPrinterDrivers5.1.dmg"
hdiutil mount -nobrowse hpdrivers.dmg

installer -pkg /Volumes/HewlettPackard\ Printer\ Drivers/HewlettPackardPrinterDrivers.pkg -target /
echo "Installer done"
hdiutil unmount "/Volumes/HewlettPackard Printer Drivers"
echo "Printer ready to drive"
rm hpdrivers.dmg
rmdir ~/hp_driver_install_temp

find /Volumes -maxdepth 1 -not -user root -print0 | xargs -0 diskutil eject

exit 0

