#!/bin/sh

echo "Putting iPhone into Recovery Mode"

cd tools

sudo ./irecovery -c setenv auto-boot true
sudo ./irecovery -c saveenv
sudo ./irecovery -c reboot
sleep 10