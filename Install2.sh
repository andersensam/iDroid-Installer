#!/bin/bash

echo "Removing Old Files"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm /var/android.img.gz /var/cache.img /var/system.img /var/userdata.img /var/zImage"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm *.deb"


echo "Creating Firmware Directory"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "mkdir /private/var/firmware"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm /private/var/firmware/*"

scp -o StrictHostKeyChecking=no -P 4633 ./sd* root@localhost:/private/var/firmware/

echo "Creating SD Card"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "mkdir /private/var/sdcard"

clear

echo "Preparing to Extract Firmware"

sh ./dependencies/dep_install.sh

sleep 10

sh ./FirmwareInstall.sh

echo "Creating iDroid System Image Directory"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "mkdir /var/idroid"

echo "Sending iDroid OS Files"

scp -o StrictHostKeyChecking=no -P 4633 ./os/* root@localhost:/var/idroid

scp -o StrictHostKeyChecking=no -P 4633 ./atech root@localhost:/var

echo "Extracting iDroid OS Files"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "tar -xzvf /var/idroid/os.tar.gz -C /var/idroid"

sleep 190

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "chmod 777 /var/idroid/*"

clear

echo "Cleaning Up"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm *.deb"

clear


echo "All Done!"

killall Server

open http://www.andersentechwiki.net/

exit 0
