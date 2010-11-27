#!/bin/bash

#AndersenTech iDroid Update Checker v1.0.002 for Mac

#iDroid Version


Version=`sed -n '1p' iDroidVersion.info`

echo $Version

rm idroidm3g.info

curl -C - -O http://www.andersentechwiki.net/objects/updater/idroidm3g.info

NewVersion=`sed -n '1p' idroidm3g.info`

echo $NewVersion

if [ $NewVersion = $Version ] ; then

exit 0;

fi

if [ $NewVersion > $Version ] ; then

echo "Downloading New Version";

curl -C - -O http://www.andersentechwiki.net/objects/iphone/idroidinstaller/current/iDroidInstaller3G.zip;

mv iDroidInstaller3G.zip $HOME;

sh UpdateComplete.sh;

echo "Check Your Desktop!";

fi

exit 0

