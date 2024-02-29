#!/bin/bash
print_blue () {
    echo -e "\x1b[1;34m$1\x1b[0;0m";
}
print_red () {
    echo -e "\x1b[1;31m$1\x1b[0;0m";
}

if [ ! `id -u` -eq 0 ]
then
    print_red "You need to run as root!";
    exit 0;
fi;
if [ $# -eq 0 ]
then
    print_red "Usage: <Image to modify>";
    exit 0;
fi
qemu-img resize -f raw $1 +20M # Resize image file itself (TODO: Replace with dd)
fdisk $1 <<EOF # Fix GPT Table
w

EOF
fdisk $1 <<EOF # Resize p1
d
1
n
1

+20M
w

EOF

MNTPOINT=$(mktemp -d mntpoint.XXXX)
LODEV=$(losetup -f)
echo ${LODEV}
losetup -fP $1 # Partitions are visible now created from fdisk
mkfs.ext4 ${LODEV}p1 # Making new ext4 fs
mount -o loop,rw ${LODEV}p1 $MNTPOINT
LINK_TO="/bin/busybox"
read -p "Enter file to symlink: " LINK_TO
ln -s $LINK_TO $MNTPOINT/decrypt_stateful
umount $MNTPOINT
rm -rvf $MNTPOINT
losetup -D
print_blue "Added dm-verity bypass. Please flash onto usb and boot through recovery mode."