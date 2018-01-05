
#!/bin/bash

mkdir ~/browseradd_temp
cd ~/browseradd_temp

# Installing Firefox
curl -L -o Firefox.dmg "http://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
hdiutil mount -nobrowse Firefox.dmg
cp -R "/Volumes/Firefox/Firefox.app" /Applications
hdiutil unmount "/Volumes/Firefox"
rm Firefox.dmg

exit 0


