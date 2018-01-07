#!/bin/sh

dmgfile="googlechrome.dmg"
volname="Google Chrome"
logfile="/Library/Logs/GoogleChromeInstallScript.log"

url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'


/bin/echo "--" >> ${logfile}
/bin/echo "`date`: Downloading latest version." >> ${logfile}
/usr/bin/curl -s -o /tmp/${dmgfile} ${url}
/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet
/bin/echo "`date`: Installing..." >> ${logfile}
ditto -rsrc "/Volumes/${volname}/Google Chrome.app" "/Applications/Google Chrome.app"
/bin/sleep 10
/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet
/bin/sleep 10
/bin/echo "`date`: Deleting disk image." >> ${logfile}
/bin/rm /tmp/"${dmgfile}"


python << END


#### Disable auto updates
####
####



#!/usr/bin/env python
# encoding: utf-8
"""
chrome-enable-autoupdates.py

This script enables system wide automatic updates for Google Chrome.
It should work for Chrome versions 18 and later. No configuration needed
as this is originally intended as a munki postinstall script.

Created by Hannes Juutilainen, hjuutilainen@mac.com

History:

2015-09-25, Niklas Blomdalen
- Modifications to include old KeystoneRegistration installation (python version)

2014-11-20, Hannes Juutilainen
- Modifications for Chrome 39

2012-08-31, Hannes Juutilainen
- Added --force flag to keystoneInstall as suggested by Riley Shott

2012-05-29, Hannes Juutilainen
- Added more error checking

2012-05-25, Hannes Juutilainen
- Added some error checking in main

2012-05-24, Hannes Juutilainen
- First version

"""

import sys
import os
import getopt
import subprocess
import plistlib

chromePath = "/Applications/Google Chrome.app"
infoPlistPath = os.path.realpath(os.path.join(chromePath, 'Contents/Info.plist'))
brandPath = "/Library/Google/Google Chrome Brand.plist"
brandKey = "KSBrandID"
tagPath = infoPlistPath
tagKey = "KSChannelID"
versionPath = infoPlistPath
versionKey = "KSVersion"


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def chromeIsInstalled():
    """Check if Chrome is installed"""
    if os.path.exists(chromePath):
        return True
    else:
        return False


def chromeVersion():
    """Returns Chrome version"""
    infoPlist = plistlib.readPlist(infoPlistPath)
    bundleShortVersion = infoPlist["CFBundleShortVersionString"]
    return bundleShortVersion


def chromeKSUpdateURL():
    """Returns KSUpdateURL from Chrome Info.plist"""
    infoPlist = plistlib.readPlist(infoPlistPath)
    KSUpdateURL = infoPlist["KSUpdateURL"]
    return KSUpdateURL


def chromeKSProductID():
    """Returns KSProductID from Chrome Info.plist"""
    infoPlist = plistlib.readPlist(infoPlistPath)
    KSProductID = infoPlist["KSProductID"]
    return KSProductID


def keystoneRegistrationFrameworkPath():
    """Returns KeystoneRegistration.framework path"""
    keystoneRegistration = os.path.join(chromePath, 'Contents/Versions')
    keystoneRegistration = os.path.join(keystoneRegistration, chromeVersion())
    keystoneRegistration = os.path.join(keystoneRegistration, 'Google Chrome Framework.framework')
    keystoneRegistration = os.path.join(keystoneRegistration, 'Frameworks/KeystoneRegistration.framework')
    return keystoneRegistration


def keystoneInstall():
    """Install the current Keystone"""
    installScript = os.path.join(keystoneRegistrationFrameworkPath(), 'Resources/ksinstall')
    if not os.path.exists(installScript):
        installScript = os.path.join(keystoneRegistrationFrameworkPath(), 'Resources/install.py')
    keystonePayload = os.path.join(keystoneRegistrationFrameworkPath(), 'Resources/Keystone.tbz')
    if os.path.exists(installScript) and os.path.exists(keystonePayload):
        retcode = subprocess.call([installScript, '--install', keystonePayload, '--force'])
        if retcode == 0:
            return True
        else:
            return False
    else:
        print >> sys.stderr, "Error: KeystoneRegistration.framework not found"
        return False


def removeChromeFromKeystone():
    """Removes Chrome from Keystone"""
    ksadmin = "/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/MacOS/ksadmin"
    ksadminProcess = [  ksadmin, '--delete', '--productid',  chromeKSProductID()]
    retcode = subprocess.call(ksadminProcess)
    if retcode == 0:
        return True
    else:
        return False


def registerChromeWithKeystone():
    """Registers Chrome with Keystone"""
    ksadmin = "/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/MacOS/ksadmin"
    if os.path.exists(ksadmin):
        ksadminProcess = [ksadmin,
                        '--register',
                        '--preserve-tttoken',
                        '--productid',          chromeKSProductID(),
                        '--version',            chromeVersion(),
                        '--xcpath',             chromePath,
                        '--url',                chromeKSUpdateURL(),
                        '--tag-path',           tagPath,
                        '--tag-key',            tagKey,
                        '--brand-path',         brandPath,
                        '--brand-key',          brandKey,
                        '--version-path',       versionPath,
                        '--version-key',        versionKey]
        retcode = subprocess.call(ksadminProcess)
        if retcode == 0:
            return True
        else:
            return False
    else:
        print >> sys.stderr, "Error: %s doesn't exist" % ksadmin
        return False


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        # Check for root
        if os.geteuid() != 0:
            print >> sys.stderr, "This script must be run as root"
            return 1

        if not chromeIsInstalled():
            print >> sys.stderr, "Error: Chrome is not installed on this computer"
            return 1
        if keystoneInstall():
            print "Keystone installed"
        else:
            print >> sys.stderr, "Error: Keystone install failed"
            return 1
        if registerChromeWithKeystone():
            print "Registered Chrome with Keystone"
            return 0
        else:
            print >> sys.stderr, "Error: Failed to register Chrome with Keystone"
            return 1

    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2


if __name__ == "__main__":
    sys.exit(main())

END

####### Set Google Chrome as default macOS browser
#######
#######


#!/bin/bash

# Desired default browser string
DefaultBrowser='com.google.chrome'
#DefaultBrowser='com.apple.safari'
#DefaultBrowser='org.mozilla.firefox'

# PlistBuddy executable
PlistBuddy='/usr/libexec/PlistBuddy'

# Plist directory
PlistDirectory="$HOME/Library/Preferences/com.apple.LaunchServices"

# Plist name
PlistName="com.apple.launchservices.secure.plist"

# Plist location
PlistLocation="$PlistDirectory/$PlistName"

# Array of preferences to add
PrefsToAdd=("{ LSHandlerContentType = \"public.url\"; LSHandlerPreferredVersions = { LSHandlerRoleViewer = \"-\"; }; LSHandlerRoleViewer = \"$DefaultBrowser\"; }"
"{ LSHandlerContentType = \"public.html\"; LSHandlerPreferredVersions =  { LSHandlerRoleAll = \"-\"; }; LSHandlerRoleAll = \"$DefaultBrowser\"; }"
"{ LSHandlerPreferredVersions = { LSHandlerRoleAll = \"-\"; }; LSHandlerRoleAll = \"$DefaultBrowser\"; LSHandlerURLScheme = https; }"
"{ LSHandlerPreferredVersions = { LSHandlerRoleAll = \"-\"; }; LSHandlerRoleAll = \"$DefaultBrowser\"; LSHandlerURLScheme = http; }"
)

# lsregister location (this location appears to exist on most macOS systems)
lsregister='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister'
# This is an alternate location, but I think anything with the location below should also have the location above
#lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

# Double-check the PlistLocation exists
if [ -f "$PlistLocation" ]; then

    # Initialize counter that will just keep moving us through the array of dicts
    # A bit imprecise... would be better if we could just count the array of dicts, but we'll stop when we get to a blank one
    Counter=0

    # Initialize DictResult just so the while loop begins
    DictResult='PLACEHOLDER'

    while [[ ! -z "$DictResult" ]]; do
        DictResult=$("$PlistBuddy" -c "Print LSHandlers:$Counter" "$PlistLocation")

        # Check for existing settings
        if [[ "$DictResult" == *"public.url"* ]] || [[ "$DictResult" == *"public.html"* ]] || [[ "$DictResult" == *"LSHandlerURLScheme = https"* ]] || [[ "$DictResult" == *"LSHandlerURLScheme = http"* ]]; then
            # Delete the existing. We'll add new ones in later
            "$PlistBuddy" -c "Delete :LSHandlers:$Counter" "$PlistLocation"
            echo "Deleting $Counter from Plist"
        fi

        # Increase counter
      Counter=$((Counter+1))

    # End of while loop
    done

# Plist does not exist
else
    # Say the Plist does not exist
    echo "Plist does not exist. Creating directory for it."
    mkdir -p "$PlistDirectory"

# End checking whether Plist exists or not
fi

echo "Adding in prefs"
for PrefToAdd in "${PrefsToAdd[@]}"
    do
        defaults write "$PlistLocation" LSHandlers -array-add "$PrefToAdd"
    done

# Check the lsregister location exists
if [ -f "$lsregister" ]; then

    echo "Rebuilding Launch services. This may take a few moments."
    # Rebuilding launch services
    "$lsregister" -kill -r -domain local -domain system -domain user
else
    echo "You may need to log out or reboot for changes to take effect. Cannot find location of lsregister at $lsregister"
fi



### Unmount disk

find /Volumes -maxdepth 1 -not -user root -print0 | xargs -0 diskutil eject
exit 0


