Tedpi

Intro
=====

These instructions apply to all models of tedpi:
	- tedpi-1b:   based on raspberry pi B+ rev2.1 - Code: 0x000e.
	- tedpi-cm:   based on raspberry pi Compute module - Code: 0x0011.
	- tedpi-2b-*: based on raspberry pi 2B - Code: 0xa01041.
	- tedpi-3b-*: based on raspberry pi 3 B v1.1 code: a02082"

How to build it
===============

Configure Buildroot
-------------------

There are several defconfig files in Buildroot, one for each
major variant, which you should base your work on:

For model tedpi-1b:

  $ make tedpi_1b_defconfig

For tedpi-cm:

  $ make tedpi_cm_defconfig
  
For tedpi-2b:

  $ make tedpi_2b_defconfig

For tedpi-3b:

  $ make tedpi_3b_defconfig

Build the rootfs
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

You may now build your rootfs with:

  $ make

(This may take a while, consider getting yourself a coffee ;-) )

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    +-- bcm2708-rpi-b.dtb           [1]
    +-- bcm2708-rpi-b-plus.dtb      [1]
    +-- bcm2709-rpi-2-b.dtb         [1]
    +-- bcm2710-rpi-3-b.dtb         [1]
    +-- boot.vfat
    +-- kernel-marked/zImage        [2]
    +-- rootfs.ext4
    +-- rpi-firmware/
    |   +-- bootcode.bin
    |   +-- cmdline.txt
    |   +-- config.txt
    |   +-- fixup.dat
    |   `-- start.elf
    +-- sdcard.img
    `-- zImage

[1] Not all of them will be present, depending on the RaspberryPi
    model you are using.

[2] This is the mkknlimg DT-marked kernel.

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Insert the SDcard into your Raspberry Pi, and power it up. Your new system
should come up now.
