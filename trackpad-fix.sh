#!/bin/bash

# Original script by d3pd from http://askubuntu.com/a/443668

sudo apt-get install git
sudo apt-get build-dep xserver-xorg-input-evdev xserver-xorg-input-synaptics

mkdir tmp-trackpoint
cd tmp-trackpoint

git clone https://aur.archlinux.org/xf86-input-evdev-trackpoint.git
git clone git://git.debian.org/git/pkg-xorg/driver/xserver-xorg-input-evdev
git clone git://git.debian.org/git/pkg-xorg/driver/xserver-xorg-input-synaptics

mv xf86-input-evdev-trackpoint arch
mv xserver-xorg-input-evdev evdev
mv xserver-xorg-input-synaptics synaptics

cp synaptics/src/{eventcomm.c,eventcomm.h,properties.c,synaptics.c,synapticsstr.h,synproto.c,synproto.h} evdev/src
cp synaptics/include/synaptics-properties.h evdev/src
cp arch/*.patch evdev

cd evdev
patch -p1 -i 0001-implement-trackpoint-wheel-emulation.patch
patch -p1 -i 0004-disable-clickpad_guess_clickfingers.patch
patch -p1 -i 0006-add-synatics-files-into-Makefile.am.patch

dpkg-buildpackage -d

cd ..
sudo dpkg -i xserver-xorg-input-evdev_*.deb
sudo apt-get remove xserver-xorg-input-synaptics

sudo mkdir /etc/X11/xorg.conf.d/
sudo cp arch/90-evdev-trackpoint.conf /etc/X11/xorg.conf.d

