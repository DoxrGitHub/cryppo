#!/bin/bash

echo "Running Cryptosmite_host"
# Thanks Mattias Nissler for the vuln https://chromium-review.googlesource.com/c/chromiumos/platform2/+/922063 :)
# Avoids adding new partitions and expanding disk image space, so we don't require larger usbs to flash
FILE_PATH=$(dirname "${0}")
if [ $(id -u) -ne 0 ]
then
    echo "You need to run this script as root"
    exit
fi
if [ "$#" -ne 3 ]
then
    echo "Usage: <rma shim path> <cryptsetup.tar.xz path> <stateful.tar.xz>"
    echo "If you need the last two files, please read the readme"
    exit 0;
fi
bb() {
    local font_blue="\033[94m"
    local font_bold="\033[1m"
    local font_end="\033[0m"

    echo -e "\n${font_blue}${font_bold}${1}${font_end}"
}
echo "Please make sure you have backed up your original RMA Shim. Any changes made here will modify the original rma shim, and there is a high chance it will break. (I recommend using tmpfs in your linux environment to modify the shim. If you have windows, WSL is an option)"
echo "If you would like to back up your shim, please press ctrl-c within 3 seconds, backup your shim, and run this again, otherwise you are on your own."

sleep 3

echo "Modifying shim now this script will take a while..."
bb "[Setting up loopfs to shim]"
mount -t tmpfs tmpfs /tmp/
shimmnt=$(mktemp -d)
lastlooppart=$(losetup -f)
SHIMPATH=$1
STATEFULPATH=$3
CRYPTSETUP_PATH=$2
losetup -fP "$SHIMPATH"
echo "Made loopfs on ${lastlooppart}"

bb "[Loading SHIM stateful]"
mkfs.ext4 "${lastlooppart}p1" -F # Need to erase stateful, there isn't much space on there but is just enough to contain 65MB worth of packages (including apk)
mount -o loop,rw "${lastlooppart}p1" "$shimmnt"
mount | grep "stateful"
echo "Copying stateful.tar.xz to shim"
dd if="${STATEFULPATH}" of="${shimmnt}/stateful.tar.xz" status=progress
echo "Extracting cryptsetup.tar.xz to shim"
mkdir "${shimmnt}/cryptsetup_root" -p
mkdir "${shimmnt}/dev_image/" -p
mkdir "${shimmnt}/dev_image/etc" -p
touch "${shimmnt}/dev_image/etc/lsb-factory"
tar -C "${shimmnt}/cryptsetup_root" -xvf "${CRYPTSETUP_PATH}"
echo "Cleaning up stateful mounts"
umount "${shimmnt}"

bb "[Loading shim root]"
echo "Making rootfs writable if not already"
sh "${FILE_PATH}/lib/ssd_util.sh" --no_resign_kernel --remove_rootfs_verification -i "${lastlooppart}"
sync
sync
sync
mount -o loop,rw "${lastlooppart}p3" "${shimmnt}"
if [ "$(ls -l "${shimmnt}/usr/sbin/factory_install.sh" | awk '{print $5}')" -ge 100  ]
then
    echo "Found non sh1mmered shim"
    echo "Make sure that you sh1mmer this shim, then you can rerun this script (keep in mind that you can run this script however many times you want)"
    umount "${shimmnt}"
    losetup -D
    exit 0
fi
mkdir -p "${shimmnt}/usr/local/bin"
cp -v cryptosmite.sh "${shimmnt}/usr/local/bin/"
echo "Cleaning up shim root"
umount "${shimmnt}"
bb "Finished, please boot into shim to see effects"
losetup -D