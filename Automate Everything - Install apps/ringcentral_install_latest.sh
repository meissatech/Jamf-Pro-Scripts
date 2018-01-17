#!/bin/sh


###
#
#            Name:  ringcentral_install_latest.sh
#     Description:  This script downloads and installs the latest version
#					Ringcentral for Mac.
#          Author:  Stephen Weinstein
#         Created:  2018-01-16
#   Last Modified:  2018-01-17
#
###


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

exit 0


rm ringcentral.dmg
rmdir ~/ringcentral_temp

### Unmount disk

exit 0


