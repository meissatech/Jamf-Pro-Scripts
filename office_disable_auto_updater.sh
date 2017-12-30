#!/bin/bash

/usr/bin/defaults write /Library/Preferences/com.microsoft.autoupdate2 HowToCheck -string "Manual"
killall cfprefsd
