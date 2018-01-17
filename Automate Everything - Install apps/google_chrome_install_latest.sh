#!/bin/sh


mkdir ~/ringcentral_temp
cd ~/ringcentral_temp

# Installing RingCentral
curl ringcentral.dmg -L -O "http://downloads.ringcentral.com/sp/RingCentralForMac"
hdiutil mount -nobrowse ringcentral.dmg
cp -R "/Volumes/RingCentral for Mac/RingCentral for Mac.app" /Applications

mounteddisk=`diskutil list | grep "RingCentral"`

diskname=`echo $mounteddisk | awk '{print $7}'`

echo $diskname

diskutil unmount /dev/$diskname

exit 0


rm ringcentral.dmg
rmdir ~/ringcentral_temp

### Unmount disk

exit 0


