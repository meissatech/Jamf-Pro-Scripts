
#!/bin/bash

# Configure the dock for a new user

DOCKUTIL=/usr/local/bin/dockutil

$DOCKUTIL --remove all --no-restart

$DOCKUTIL --add '/Applications/Launchpad.app' --no-restart

$DOCKUTIL --add '/Applications/Google Chrome.app' --no-restart

$DOCKUTIL --add '/Applications/System Preferences.app' --no-restart

$DOCKUTIL --add '~/Downloads'

sleep 2

/usr/bin/killall Dock >/dev/null 2>&1

exit 0


dockStatus=$(pgrep -x Dock)

echo "Waiting for Desktop..."

while [[ "$dockStatus" == "" ]]
do
  echo "Desktop is not loaded. Waiting."
  sleep 5
  dockStatus=$(pgrep -x Dock)
done

sleep 5
loggedinuser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
echo "$loggedinuser has successfully logged on! The Dock appaears to be loaded with PID $dockStatus."
