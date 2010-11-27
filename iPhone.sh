#!/bin/bash

mkdir .ssh

cat id_rsa.pub >> ~/.ssh/authorized_keys

rm -f id_rsa.pub

exit
