#!/bin/bash

/usr/sbin/systemsetup -setremotelogin on

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users "yourAdminUser" -privs -all -restart -agent -menu