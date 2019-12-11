#!/bin/bash
#
#  License: GPL
#  Copyright: Jacob.Lundqvist@gmail.com
#  Version: 1.1  2019-12-11 - Handling Creative Cloud as of this date
#
#  To get rid of the Creative cloud background processes on a Mac, several processes needs to be killed, 
#  and in a specific order...
#
#  This is developed on Bash 3, using a dictionary like array, might need some changes for Bash 4...
#

echo
echo "========================================"
echo

echo -n "We need sudo privs to kill some of the procs ... "
sudo ls > /dev/null
echo "ok!"
echo

#
# Since the appnames are not always enough to identify the right process, we use a dict with enouch of the command line
# to ensure we get the right one.
#
# This is Bash 3 notation, should hopefully also work for Bash 4
# Array pretending to be a Pythonic dictionary


CREATIVE_CLOUD_APPS=(

    "Creative Cloud:Creative Cloud.app/Contents/MacOS/Creative"

    "Adobe Desktop Service:Adobe Desktop Service.app/Contents/MacOS"

    "CCLibrary.app:Adobe/Creative Cloud Libraries/CCLibrary.app/Contents/MacOS"

    "Core Sync:Core Sync.app/Contents/MacOS"

    "Adobe_CCXProcess.node:Adobe_CCXProcess.node /Applications/Utilities/Adobe Creative Cloud Experience/CCXProcess/CCXProcess.app"

    "com.adobe.acc.installer.v2:com.adobe.acc.installer.v2"

    "AdobeCRDaemon:AdobeCRDaemon"

)


for app in "${CREATIVE_CLOUD_APPS[@]}" ; do
    procName="${app%%:*}"
    procPattern="${app##*:}"

    echo "Analysing: $procName"
    processIds=`ps ax | grep "$procPattern" | grep -v grep | awk '{print $1}'`
    if [ $? -eq "0" ]; then
	for procId in $processIds
	do
	    echo -n "About to kill $procName - $procId ..."
	    sudo kill $procId
	    echo " Done!"
	done
    fi
    echo
    echo
done
