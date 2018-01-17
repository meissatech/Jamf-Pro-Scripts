
#!/bin/bash

###
#
#            Name:  firefox_install_latest.sh
#     Description:  This script downloads and installs the latest version
#					Firefox.
#          Author:  Stephen Weinstein
#         Created:  2018-01-16
#   Last Modified:  2018-01-17
#
###



mkdir ~/browseradd_temp
cd ~/browseradd_temp

# Installing Firefox
curl -L -o Firefox.dmg "http://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
hdiutil mount -nobrowse Firefox.dmg
cp -R "/Volumes/Firefox/Firefox.app" /Applications
hdiutil unmount "/Volumes/Firefox"


mounteddisk=`diskutil list | grep "Firefox"`
diskname=`echo $mounteddisk | awk '{print $6}'`

echo $diskname

diskutil eject /dev/$diskname


rm Firefox.dmg
rmdir ~/browseradd_temp


exit 0


