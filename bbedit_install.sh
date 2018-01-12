#!/bin/bash

mkdir ~/bbedit_temp
cd ~/bbedit_temp

# Installing BBEdit
curl -L -o BBEdit.dmg "https://s3.amazonaws.com/BBSW-download/BBEdit_12.0.2.dmg"
hdiutil mount -nobrowse BBEdit.dmg
cp -R "/Volumes/BBEdit 12.0.2/BBEdit.app" /Applications
hdiutil unmount "/Volumes/BBEdit 12.0.2"
find /Volumes -maxdepth 1 -not -user root -print0 | xargs -0 diskutil eject

rmdir ~/bbedit_temp

rm BBEdit.dmg




