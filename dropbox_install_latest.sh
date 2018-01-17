#!/bin/sh


mkdir ~/dropbox_temp
cd ~/dropbox_temp

# Installing Chrome
curl -L -o dropbox.dmg "https://www.dropbox.com/download?plat=mac&type=full"
hdiutil mount -nobrowse dropbox.dmg
cp -R "/Volumes/Dropbox Installer/Dropbox.app" /Applications
hdiutil unmount "/Volumes/Dropbox Installer"

mounteddisk=`diskutil list | grep "Dropbox"`

diskname=`echo $mounteddisk | awk '{print $7}'`

echo $diskname

diskutil eject /dev/$diskname

exit 0


rm dropbox.dmg

### Unmount disk

exit 0


