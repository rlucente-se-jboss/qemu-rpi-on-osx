#!/usr/bin/env bash

. $(dirname $0)/demo.conf

pushd $(dirname $0)

##
## Launch instance
##

qemu-system-aarch64 \
    -machine $MACHINE \
    -append "root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait" \
    -dtb $DTB_FILE \
    -sd dist/*.img \
    -kernel kernel8.img \
    -device usb-kbd \
    -device usb-mouse \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22
popd

