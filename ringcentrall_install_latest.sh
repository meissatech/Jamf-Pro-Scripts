#!/bin/sh


mkdir ~/ringcentral_temp
cd ~/ringcentral_temp

# Installing RingCentral
curl -L -o ringcentral.dmg "http://downloads.ringcentral.com/sp/RingCentralForMac"
hdiutil mount -nobrowse ringcentral.dmg
cp -R "/Volumes/RingCentral for Mac/RingCentral for Mac.app" /Applications

mounteddisk=`diskutil list | grep "RingCentral"`

diskname=`echo $mounteddisk | awk '{print $7}'`

echo $diskname

diskutil eject /dev/$diskname


rm ringcentral.dmg
rmdir ~/ringcentral_temp
exit 0
