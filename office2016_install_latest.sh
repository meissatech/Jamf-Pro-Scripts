
#!/bin/bash

mkdir ~/officeinstall_temp
cd ~/officeinstall_temp

# Installing Office
curl -L -o Office2016.pkg "https://go.microsoft.com/fwlink/?linkid=525133"

installer -pkg Office2016.pkg -target /

rm Office2016.pkg
rmdir ~/officeinstall_temp
exit 0


