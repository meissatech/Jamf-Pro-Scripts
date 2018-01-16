#!/bin/bash


###
#
#            Name:  excel_smart_install_latest.sh
#     Description:  This script is designed to run on a recurring frequnecy for
#                   so that the latest version of Microsoft Excel is installed. 
#                   New releases of Excel are generally released on a monthly basis.
#          Author:  Stephen Weinstein
#         Created:  2018-01-16
#   Last Modified:  2018-01-16
#
###

#Make temp directory
mkdir ~/officeinstall_temp
cd ~/officeinstall_temp

curl -L -o macadmins.html https://macadmins.software/
url=`sed '97!d' macadmins.html | cat | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq`

excelurl=`echo $url | awk '{print $1}'`

echo $excelurl


# Download Microsoft Excel
curl -L -o excel2016.pkg $excelurl

# Install Microsoft Excel
installer -pkg excel2016.pkg -target /


rm excel2016.pkg
rmdir ~/officeinstall_temp

# Set the Open and Save options in Office 2016 apps to default to "On My Mac" instead of "Online Locations".
# This setting will apply to all users on this Mac.
echo "Setting default save location for Office application to On My Mac"
/usr/bin/defaults write /Library/Preferences/com.microsoft.office DefaultsToLocalOpenSave -bool true

# Suppress Microsoft Office first run promopts

echo "Suppressing Microsoft  first run prompts..."
 /usr/bin/defaults write /Library/Preferences/com.microsoft.Excel kSubUIAppCompletedFirstRunSetup1507 -bool true


exit 0