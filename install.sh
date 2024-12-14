#!/usr/bin/env bash

. $(dirname $0)/demo.conf

##
## Sanity checks for all dependencies
##

ls dist/*.xz || exit_on_error "No Raspberry Pi OS compressed image found"
which -s brew || exit_on_error "Please install the HomeBrew package manager from https://brew.sh"

brew update && brew upgrade
brew install qemu xz openssl

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
    $IMAGE | grep Windows_FAT_32 | awk '{print $3}')

rm -f *.dtb *.img
cp $VOLUME/$DTB_FILE $VOLUME/kernel8.img .

##
## Override user credentials
##

cat > $VOLUME/userconf.txt <<EOF
$USERNAME:$(/opt/homebrew/bin/openssl passwd -6 $PASSWORD)
EOF

##
## Enable ssh
##

touch $VOLUME/ssh

hdiutil detach $VOLUME

##
## Resize instance
##

qemu-img resize -f raw $IMAGE $SD_CARD_SIZE

popd

