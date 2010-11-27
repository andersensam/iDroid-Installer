#!/bin/bash

echo "Removing iDroid System Files"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm /var/android.img.gz /var/cache.img /var/system.img /var/userdata.img /var/zImage"

echo "Removing iDroid Folder"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm -rf  /private/var/idroid"

echo "Removing Firmware"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm /private/var/firmware/*"

echo "Cleaning Up"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm *.deb"

clear


echo "All Done!"

exit 0
