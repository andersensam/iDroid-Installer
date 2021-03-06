#!/bin/bash

killall iTunesHelper
killall iTunes

echo "Sending Upgrade Files"

expect -c 'spawn scp -o StrictHostKeyChecking=no -P 4633 ./installoib root@localhost:/var ; expect password ; send -- "[read [open "./password" r]]" ; interact'

echo "Setting NVRAM Flags!"



expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram partition-script=1" ; expect password ; send -- "[read [open "./password" r]]" ; interact'
expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram opib-hide-menu=true" ; expect password ; send -- "[read [open "./password" r]]" ; interact'
expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram file-script=/installoib" ; expect password ; send -- "[read [open "./password" r]]" ; interact'
expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram scripting-openiboot=1" ; expect password ; send -- "[read [open "./password" r]]" ; interact'
expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "nvram auto-boot=false" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

echo "Rebooting"

expect -c 'spawn ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "reboot" ; expect password ; send -- "[read [open "./password" r]]" ; interact'

echo "Waiting for Recovery (45 Seconds)"

sleep 45

expect -c 'spawn sudo ./loadibec openiboot.img3 ; expect password ; send -- "[read [open "./root_password" r]]" ; interact'

killall Server

echo "The Rest Takes Place on the iPhone, All Done!"


