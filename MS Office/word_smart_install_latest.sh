#!/bin/bash


###
#
#            Name:  word_smart_install_latest.sh
#     Description:  This script is designed to run on a recurring frequnecy for
#                   so that the latest version of Microsoft word is installed. 
#                   New releases of word are generally released on a monthly basis.
#          Author:  Stephen Weinstein
#         Created:  2018-01-16
#   Last Modified:  2018-01-16
#
###

#Make temp directory
mkdir ~/officeinstall_temp
cd ~/officeinstall_temp

curl -L -o macadmins.html https://macadmins.software/
url=`sed '96!d' macadmins.html | cat | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq`

wordurl=`echo $url | awk '{print $1}'`

echo $wordurl


# Download Microsoft word
curl -L -o word2016.pkg $wordurl

# Install Microsoft word
installer -pkg word2016.pkg -target /


rm word2016.pkg
rmdir ~/officeinstall_temp

# Set the Open and Save options in Office 2016 apps to default to "On My Mac" instead of "Online Locations".
# This setting will apply to all users on this Mac.
echo "Setting default save location for Office application to On My Mac"
/usr/bin/defaults write /Library/Preferences/com.microsoft.office DefaultsToLocalOpenSave -bool true

# Suppress Microsoft Office first run promopts

echo "Suppressing Microsoft word first run prompts..."
 /usr/bin/defaults write /Library/Preferences/com.microsoft.Word kSubUIAppCompletedFirstRunSetup1507 -bool true


exit 0