################################################################################
#
# rpi-firmware
#
################################################################################

RPI_FIRMWARE_VERSION = 22d8c910f4c53118f9cf85c038d7d8e307efc110
RPI_FIRMWARE_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_VERSION))
RPI_FIRMWARE_LICENSE = BSD-3c
RPI_FIRMWARE_LICENSE_FILES = boot/LICENCE.broadcom
RPI_FIRMWARE_INSTALL_TARGET = YES
RPI_FIRMWARE_INSTALL_IMAGES = YES
RPI_FIRMWARE_DEPENDENCIES += host-rpi-firmware

define RPI_FIRMWARE_BUILD_CONFIG_HEAD
	(\
		echo "# Please note that this is only a sample, we recommend you to change it to fit"; \
		echo "# your needs."; \
		echo "# You should override this file using a post-build script."; \
		echo "# See http://buildroot.org/manual.html#rootfs-custom"; \
		echo "# and http://elinux.org/RPiconfig for a description of config.txt syntax"; \
		echo ""; \
		echo "kernel=zImage"; \
		echo ""; \
		echo "# To use an external initramfs file"; \
		echo "#initramfs rootfs.cpio.gz"; \
		echo ""; \
		echo "# Disable overscan assuming the display supports displaying the full resolution"; \
		echo "# If the text shown on the screen disappears off the edge, comment this out"; \
		echo "disable_overscan=1"; \
		echo ""; \
		echo "# How much memory in MB to assign to the GPU on Pi models having"; \
		echo "# 256, 512 or 1024 MB total memory"; \
		echo "gpu_mem_256=100"; \
		echo "gpu_mem_512=100"; \
		echo "gpu_mem_1024=100"; \
		echo ""; \
	) > $(BINARIES_DIR)/rpi-firmware/config.txt
endef

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_TEDPI_1B),y)

define RPI_FIRMWARE_BUILD_CONFIG
	$(RPI_FIRMWARE_BUILD_CONFIG_HEAD)
	(\
		echo "device_tree=bcm2708-rpi-b-plus.dtb"; \
		echo "dtparam=i2c_arm=on,i2c_arm_baudrate=200000"; \
		echo "dtparam=spi=on"; \
		echo "dtparam=watchdog=on"; \
		echo ""; \
	) >> $(BINARIES_DIR)/rpi-firmware/config.txt
endef

define RPI_FIRMWARE_BUILD_CMDLINE
	(\
		echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait smsc95xx.macaddr=${BR2_PACKAGE_RPI_FIRMWARE_TEDPI_MAC} ip=dhcp"; \
		echo ""; \
	) > $(BINARIES_DIR)/rpi-firmware/cmdline.txt
endef

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2708-rpi-b-plus.dtb $(BINARIES_DIR)/rpi-firmware/bcm2708-rpi-b-plus.dtb
endef
endif

endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_TEDPI_CM),y)

define RPI_FIRMWARE_BUILD_CONFIG
	$(RPI_FIRMWARE_BUILD_CONFIG_HEAD)
	(\
		echo "device_tree=bcm2708-rpi-cm.dtb"; \
		echo "dtparam=i2c_arm=on,i2c_arm_baudrate=200000"; \
		echo "dtparam=spi=on"; \
		echo "dtparam=watchdog=on"; \
		echo ""; \
	) >> $(BINARIES_DIR)/rpi-firmware/config.txt
endef

define RPI_FIRMWARE_BUILD_CMDLINE
	(\
		echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait"; \
		echo ""; \
	) > $(BINARIES_DIR)/rpi-firmware/cmdline.txt
endef

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2708-rpi-cm.dtb $(BINARIES_DIR)/rpi-firmware/bcm2708-rpi-cm.dtb
endef
endif

endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_TEDPI_2B),y)

define RPI_FIRMWARE_BUILD_CONFIG
	$(RPI_FIRMWARE_BUILD_CONFIG_HEAD)
	(\
		echo "device_tree=bcm2709-rpi-2-b.dtb"; \
		echo "dtparam=i2c_arm=on,i2c_arm_baudrate=200000"; \
		echo "dtparam=spi=on"; \
		echo "dtparam=watchdog=on"; \
		echo ""; \
	) >> $(BINARIES_DIR)/rpi-firmware/config.txt
endef

define RPI_FIRMWARE_BUILD_CMDLINE
	(\
		echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait smsc95xx.macaddr=${BR2_PACKAGE_RPI_FIRMWARE_TEDPI_MAC} ip=dhcp"; \
		echo ""; \
	) > $(BINARIES_DIR)/rpi-firmware/cmdline.txt
endef

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB
	$(INSTALL) -D -m 0644 $(@D)/boot/bcm2709-rpi-2-b.dtb $(BINARIES_DIR)/rpi-firmware/bcm2709-rpi-2-b.dtb
endef
endif

endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB_OVERLAYS
	for ovldtb in  $(@D)/boot/overlays/*.dtb; do \
		$(INSTALL) -D -m 0644 $${ovldtb} $(BINARIES_DIR)/rpi-firmware/overlays/$${ovldtb##*/} || exit 1; \
	done
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_VCDBG),y)
define RPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0700 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/bin/vcdbg \
		$(TARGET_DIR)/usr/sbin/vcdbg
endef
endif # INSTALL_VCDBG

define RPI_FIRMWARE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/rpi-firmware/bootcode.bin
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup.dat
	#$(INSTALL) -D -m 0644 package/rpi-firmware/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
	#$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt $(BINARIES_DIR)/rpi-firmware/cmdline.txt
	$(RPI_FIRMWARE_BUILD_CONFIG)
	$(RPI_FIRMWARE_BUILD_CMDLINE)
	$(RPI_FIRMWARE_INSTALL_DTB)
	$(RPI_FIRMWARE_INSTALL_DTB_OVERLAYS)
endef

# We have no host sources to get, since we already
# bundle the script we want to install.
HOST_RPI_FIRMWARE_SOURCE =
HOST_RPI_FIRMWARE_DEPENDENCIES =

define HOST_RPI_FIRMWARE_INSTALL_CMDS
	$(INSTALL) -D -m 0755 package/rpi-firmware/mkknlimg $(HOST_DIR)/usr/bin/mkknlimg
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
