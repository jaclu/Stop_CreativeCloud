#!/bin/bash
#
#  License: GPL
#  Copyright: Jacob.Lundqvist@gmail.com
#  Version: 1.0  2019-12-02
#
#  To get rid of Creative cloud on the Mac, several processes needs to be killed, and in a specific order...
#
#  Thie is developed on Bash 3, using a dictionary like array, might need some changes for Bash 4...
#

echo
echo "========================================"
echo

echo -n "We need sudo privs for this, if asked for Passwiord, enter yours ... "
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

    "CCXProcess:Adobe_CCXProcess.node /Applications/Utilities/Adobe Creative Cloud Experience/CCXProcess/CCXProcess.app"

    "Creative Cloud:Creative Cloud.app/Contents/MacOS/Creative"

    "Adobe Desktop Service:Adobe Desktop Service.app/Contents/MacOS"

    "com.adobe.acc.installer.v2:com.adobe.acc.installer.v2"

    "AdobeCRDaemon:AdobeCRDaemon"

    "Core Sync:Core Sync.app/Contents/MacOS"

    "CCLibrary:Adobe/Creative Cloud Libraries/CCLibrary.app/Contents/MacOS"

    "AdobeIPCBroker:AdobeIPCBroker"
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
