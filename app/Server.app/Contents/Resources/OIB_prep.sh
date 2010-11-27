#!/bin/bash

echo "Starting USB SSH Daemon"

expect -c 'spawn sudo sh USB_SSH.sh ; expect password ; send -- "[read [open "./root_password" r]]" ; interact';


