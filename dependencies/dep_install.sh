#!/bin/bash

cd ./dependencies

scp -o StrictHostKeyChecking=no -P 4633 ./* root@localhost:./

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "dpkg -i ./*.deb"

sleep 40


