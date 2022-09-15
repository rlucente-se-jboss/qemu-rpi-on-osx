# Emulate RPi 3 on OSX
This project shows how to emulate a Raspberry Pi 3b on OSX using
QEMU. The emulated instance also includes networking.

## Prerequisites
There are only two things you need to do. First, review the contents
of `demo.conf`, set an appropriate username/password, and adjust
the size of the SD card. Next, you'll need to download a Raspberry
Pi OS image from the [archive](https://downloads.raspberrypi.org/raspios_lite_arm64/images/).
This should be a file with a name ending in `.img.xz`. Place this
file into the `dist` folder of this repository.

And that's it. You're ready to install and launch.

## Install
Once you've completed the prerequisites above, simply run the
command:

    ./install.sh

That will decompress the newest image in `dist`, extract the
devicetree blob and kernel image files, set the default user, and
resize the SD card image.

If you re-install, any existing data or work will be lost as the
SD card image file will be deleted.

## Launch
After installation, simply launch the instance using the command:

    ./launch.sh

System boot messages will scroll by and then a login prompt will
appear. Use the credentials you provided in the `demo.conf` file
earlier to log into your instance.

Have fun!

