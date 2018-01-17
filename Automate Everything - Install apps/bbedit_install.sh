#!/bin/bash


###
#
#            Name:  bbedit_install_latest.sh
#     Description:  This script downloads and installs the latest version
#					BBedit.
#          Author:  Stephen Weinstein
#         Created:  2018-01-16
#   Last Modified:  2018-01-17
#
###



mkdir ~/bbedit_temp
cd ~/bbedit_temp

# Installing BBEdit
curl -L -o BBEdit.dmg "https://s3.amazonaws.com/BBSW-download/BBEdit_12.0.2.dmg"
hdiutil mount -nobrowse BBEdit.dmg
cp -R "/Volumes/BBEdit 12.0.2/BBEdit.app" /Applications
hdiutil unmount "/Volumes/BBEdit 12.0.2"


mounteddisk=`diskutil list | grep "BBEdit"`
diskname=`echo $mounteddisk | awk '{print $7}'`

echo $diskname

diskutil eject /dev/$diskname


rm BBEdit.dmg
rmdir ~/bbedit_temp
echo "BBEdit Installed"
exit 0




