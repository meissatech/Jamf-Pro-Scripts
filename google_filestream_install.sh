#!/bin/bash

mkdir ~/filestream_temp
cd ~/filestream_temp

# Installing Google Filestream
curl -L -o filestream.dmg "https://dl.google.com/drive-file-stream/googledrivefilestream.dmg"
hdiutil mount -nobrowse filestream.dmg

installer -pkg /Volumes/Install\ Google\ Drive\ File\ Stream/GoogleDriveFileStream.pkg -target /
echo "Installer done"
hdiutil unmount "/Volumes/Google Drive File Stream"
echo "Printer ready to drive"
rm filestream.dmg
rmdir ~/filestream_temp


mounteddisk=`diskutil list | grep "Google"`

diskname=`echo $mounteddisk | awk '{print $8}'`

echo $diskname

diskutil eject /dev/$diskname



exit 0

