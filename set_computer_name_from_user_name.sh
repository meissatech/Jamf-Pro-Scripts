#!/bin/bash

### This script sets the computer name to the name of the loggedInUser-mac. 
### Created by Stephen Weinstein for Meissa Pro Services https://www.meissa.net

loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Get logged in user's shortname by checking console user since the current logged in user owns the console.
userName=`/usr/bin/who | awk '/console/{ print $1 }'`

# Obtain console (logged in user) user's full name
nameQuery=`dscl . -read /Users/$userName RealName | awk 'BEGIN {FS=": "} {print $1}'`
fullName=`echo $nameQuery | awk '{print $2,$3}'`
echo $fullName

# Retrieving logged in users first name, first inital, and last name
firstInitial=${fullName:0:1}
echo $firstInitial

# Retrieve user last name
lastName=`echo $nameQuery | awk '{print $3}'`
echo $lastName

# Sets first initial and last name
name=$firstInitial$lastName

# Makes $name all lower case
lowercaseName="$(tr [A-Z] [a-z] <<< "$name")"

# Appends -mac at end of the string
computerName=$lowercaseName'-mac'

# Setting computername
echo "Setting computer name..."
scutil --set ComputerName "$computerName"
scutil --set HostName "$computerName"
scutil --set LocalHostName "$computerName"
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName "$computerName"


echo "Computer name set to $computerName"
exit 0
