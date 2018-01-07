#!/bin/bash

# Disable first run prompts for Google



set -o nounset                              # Treat unset variables as an error

IFS=$'\n'

USERS=(`ls /Users | grep -v Shared | grep -v .localized`)
TEMPLATES=(`ls /System/Library/User\ Template/`)


## Loop through any pre-existing user profiles and touch "First Run"
## Edit -- for whatever reason chown after the fact does not set ownership properly
## use sudo to create the folder and file as the user in question
for userid in "${USERS[@]}"
do
    sudo -u $userid mkdir -p /Users/$userid/Library/Application\ Support/Google/Chrome
    sudo -u $userid touch /Users/$userid/Library/Application\ Support/Google/Chrome/First\ Run
done



mkdir ~/Library/Application Support/Google/Chrome/First Run
mkdir ~/Library/Application Support/Google/Chrome/Default/Preferences




exit 0

