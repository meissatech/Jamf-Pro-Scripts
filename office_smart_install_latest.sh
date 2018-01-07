#!/bin/bash


###
#
#            Name:  office_smart_install_latest.sh
#     Description:  This script is designed to run on a recurring frequnecy for
#                   so that the latest version of Microsoft Office is installed. 
#                   New releases of Office are generally released on a monthly basis.
#          Author:  Stephen Weinstein
#         Created:  2018-01-06
#   Last Modified:  2018-01-06
#
###

#Make temp directory
mkdir ~/officeinstall_temp
cd ~/officeinstall_temp

# Download macadmins.software page
curl -L -o macadmins.html https://macadmins.software/
#sed '89!d' macadmins.html > macadmins4.html
#url=`cat macadmins4.html | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq`

url=`sed '89!d' macadmins.html | cat | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq`


# Download Microsoft Office
curl -L -o Office2016.pkg $url

# Install Microsoft OFfice
installer -pkg Office2016.pkg -target /


rm Office2016.pkg
rmdir ~/officeinstall_temp

# Set the Open and Save options in Office 2016 apps to default to "On My Mac" instead of "Online Locations".
# This setting will apply to all users on this Mac.

/usr/bin/defaults write /Library/Preferences/com.microsoft.office DefaultsToLocalOpenSave -bool true

# Disable Microsoft Office Autoupdater

/usr/bin/defaults write /Library/Preferences/com.microsoft.autoupdate2 HowToCheck -string "Manual"
killall cfprefsd

# Suppress Microsoft Office first run promopts

 /usr/bin/defaults write /Library/Preferences/com.microsoft.Excel kSubUIAppCompletedFirstRunSetup1507 -bool true

 /usr/bin/defaults write /Library/Preferences/com.microsoft.onenote.app kSubUIAppCompletedFirstRunSetup1507 -bool true

 /usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook kSubUIAppCompletedFirstRunSetup1507 -bool true

 /usr/bin/defaults write /Library/Preferences/com.microsoft.Powerpoint kSubUIAppCompletedFirstRunSetup1507 -bool true

 /usr/bin/defaults write /Library/Preferences/com.microsoft.Word kSubUIAppCompletedFirstRunSetup1507 -bool true

 /usr/bin/defaults write /Library/Preferences/com.microsoft.onenote.app kSubUIAppCompletedFirstRunSetup1507 -bool true

exit 0
