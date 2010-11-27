#!/bin/bash

echo "Removing Firmware Files"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm -rf /var/firmware"

echo "Removing iDroid System Files"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm -rf /var/idroid"

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "rm -rf /private/var/sdcard"

echo "Preparing to Uninstall OpeniBoot"

scp -o StrictHostKeyChecking=no -P 4633 ./uninstall root@localhost:/var/

echo "Setting NVRAM Flags for Uninstall"

expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram partition-script=1" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram opib-hide-menu=true" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram file-script=/uninstall" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram scripting-openiboot=1" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

echo "Rebooting"

expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "reboot" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

echo "The Rest Takes Place on the Device"

killall Server

exit 0
