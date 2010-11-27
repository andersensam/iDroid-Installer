#!/bin/bash

echo "Extracting Firmware"

sleep 1

echo "FIRMWARE LICENSE TERMS

Copyright (c) Marvell International Ltd.

All rights reserved.

Redistribution. Redistribution and use in binary form, without modification, are permitted provided that the following conditions are met:

* Redistributions must reproduce the above copyright notice and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of Marvell International Ltd. nor the names of its suppliers may be used to endorse or promote products derived from this software without specific prior written permission.

* No reverse engineering, decompilation, or disassembly of this software is permitted.
Limited patent license. Marvell International Ltd. grants a world-wide, royalty-free, non-exclusive license under patents it now or hereafter owns or controls to make, have made, use, import, offer to sell and sell ('Utilize') this software, but solely to the extent that any such patent is necessary to Utilize the software alone, or in combination with an operating system licensed under an approved Open Source license as listed by the Open Source Initiative at http://opensource.org/licenses. The patent license shall not apply to any other combinations which include this software. No hardware per se is licensed hereunder.
DISCLAIMER. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

echo "By using this installer you are agreeing with the license above"

clear

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "apt-get -y --force-yes install iokittools coreutils vim"

echo "Installing Dependencies" & sleep 30

ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "cp /private/var/stash/share*/firmware/multitouch/iPhone.mtprops ./"
ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "cat iPhone.mtprops | grep -B2 0x0049 | grep data | sed 's/^\t\t<data>//' | sed 's/<\/data>$//' | base64 -d > zephyr2.bin"
ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "mv zeph* /private/var/firmware/"
ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "chmod 0777 /private/var/firmware/*"
ssh -fCT -o StrictHostKeyChecking=no -p 4633 root@localhost "cd /private/var/firmware & ls -l"


