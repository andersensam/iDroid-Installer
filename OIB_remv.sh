#!/bin/bash

killall iTunesHelper
killall iTunes


echo "Putting iPhone Into Recovery Mode!"

cd tools

sh recovin.sh

echo "Please Wait… Quadra Will Begin Install in just a moment"


cd ..



echo "Waiting for iPhone to Reboot into Recovery (45 Seconds)"

sleep 2

sh oib_finalize2.sh

sleep 1


echo "All Done. Thanks!"
