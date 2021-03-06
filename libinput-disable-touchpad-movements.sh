#!/bin/bash

# see https://askubuntu.com/a/737134 for a discussion
RELEASE=$(lsb_release -r | awk '{ print $2; }')
PATCH_FILE="evdev-mt-touchpad-disable-move.patch"
if [[ "$RELEASE" = "15.10" ]]; then
        PATCH_FILE="evdev-mt-touchpad-disable-move-15.04.patch"
fi
mkdir tmp-libinput
cd tmp-libinput
sudo apt-get install build-essential patch dh-autoreconf debhelper fakeroot libmtdev-dev libudev-dev libevdev-dev libwacom-dev
apt-get source libinput10
cd libinput-1.?.?
cp "../../${PATCH_FILE}" debian/patches/
echo "$PATCH_FILE" >> debian/patches/series
dpkg-buildpackage -d
cd ..
sudo dpkg -i *.deb

