#!/usr/bin/env bash

. $(dirname $0)/demo.conf

##
## Sanity checks for all dependencies
##

ls dist/*.xz || exit_on_error "No Raspberry Pi OS compressed image found"
which -s brew || exit_on_error "Please install the HomeBrew package manager from https://brew.sh"

brew update && brew upgrade
brew install qemu xz openssl@1.1

pushd $(dirname $0)

##
## Decompress latest RaspberryPi OS image
##

rm -fr dist/*.img
xz -dk $(ls dist/*.img.xz | sort | tail -1)

IMAGE=dist/*.img

##
## Extract kernel and dtb files
##

VOLUME=$(hdiutil attach -imagekey diskimage-class=CRawDiskImage \
    dist/*.img | grep Windows_FAT_32 | awk '{print $3}')

rm -f *.dtb *.img
cp $VOLUME/bcm2710-rpi-3-b-plus.dtb $VOLUME/kernel8.img .

##
## Override user credentials
##

cat > $VOLUME/userconf.txt <<EOF
$USERNAME:$(/usr/local/opt/openssl/bin/openssl passwd -6 $PASSWORD)
EOF

hdiutil detach $VOLUME

##
## Resize instance
##

qemu-img resize -f raw dist/*.img $SD_CARD_SIZE

popd

