#!/bin/bash

echo "Installing Dependencies"
sleep 2

echo "Installing USB Readline"

expect -c 'spawn sudo installer -pkg mac_dependencies/usbreadline.mpkg -target / ; expect password ; send -- "[read [open "./root_password" r]]" ; interact'

echo "Installing LibReadline - AndersenTech"

expect -c 'spawn sudo installer -pkg mac_dependencies/LibReadline-iDroid.pkg -target / ; expect password ; send -- "[read [open "./root_password" r]]" ; interact'

echo "Installing Libusb"

expect -c 'spawn sudo installer -pkg mac_dependencies/libusb.pkg -target / ; expect password ; send -- "[read [open "./root_password" r]]" ; interact'


