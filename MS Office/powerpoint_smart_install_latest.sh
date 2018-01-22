#!/bin/bash


###
#
#            Name:  powerpoint_smart_install_latest.sh
#     Description:  This script is designed to run on a recurring frequnecy for
#                   so that the latest version of Microsoft powerpoint is installed. 
#                   New releases of powerpoint are generally released on a monthly basis.
#          Author:  Stephen Weinstein
#         Created:  2018-01-16
#   Last Modified:  2018-01-16
#
###

#Make temp directory
mkdir ~/officeinstall_temp
cd ~/officeinstall_temp

curl -L -o macadmins.html https://macadmins.software/
url=`sed '99!d' macadmins.html | cat | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq`

powerpointurl=`echo $url | awk '{print $1}'`

echo $powerpointurl


# Download Microsoft powerpoint
curl -L -o powerpoint2016.pkg $powerpointurl

# Install Microsoft powerpoint
installer -pkg powerpoint2016.pkg -target /


rm powerpoint2016.pkg
rmdir ~/officeinstall_temp

# Set the Open and Save options in Office 2016 apps to default to "On My Mac" instead of "Online Locations".
# This setting will apply to all users on this Mac.
echo "Setting default save location for Office application to On My Mac"
/usr/bin/defaults write /Library/Preferences/com.microsoft.office DefaultsToLocalOpenSave -bool true

# Suppress Microsoft Office first run promopts

echo "Suppressing Microsoft Powerpoint first run prompts..."
 /usr/bin/defaults write /Library/Preferences/com.microsoft.Powerpoint kSubUIAppCompletedFirstRunSetup1507 -bool true


exit 0