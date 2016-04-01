################################################################################
#
# flycapture2-arm-lib
#
################################################################################

FLYCAPTURE2_ARM_LIB_VERSION = 9
FLYCAPTURE2_ARM_LIB_SITE = http://svn.tedesys.net/flycapture2_armhf/trunk
FLYCAPTURE2_ARM_LIB_SITE_METHOD = svn
FLYCAPTURE2_ARM_LIB_INSTALL_STAGING = NO
FLYCAPTURE2_ARM_LIB_INSTALL_TARGET = YES
FLYCAPTURE2_ARM_LIB_LICENSE = GPLv2+
FLYCAPTURE2_ARM_LIB_LICENSE_FILES = COPYING
FLYCAPTURE2_ARM_LIB_DEPENDENCIES = libraw1394 libusb
GROUP_FLYCAPTURE2 = pgrimaging
FLYCAPTURE2_LIB_VERSION = 2.9.3.13

ifeq ($(BR2_PACKAGE_FLYCAPTURE2_ARM_SNAPSHOT),y)
define FLYCAPTURE2_ARM_LIB_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) LD=$(TARGET_LD) -C $(@D)/src/snapshot all
endef
endif

USERNAME_FLYCAPTURE2 = $(call qstrip,$(BR2_PACKAGE_USERNAME_FLYCAPTURE2))
PASSWORD_FLYCAPTURE2 = $(call qstrip,$(BR2_PACKAGE_PASSWORD_FLYCAPTURE2))

#Add Point Grey User
ifeq ($(BR2_PACKAGE_FLYCAPTURE_ENABLE_PASSWORD),y)
define FLYCAPTURE2_ARM_LIB_USERS
	$(USERNAME_FLYCAPTURE2) -1 $(GROUP_FLYCAPTURE2) -1 =$(PASSWORD_FLYCAPTURE2) /home/$(USERNAME_FLYCAPTURE2) /bin/sh $(GROUP_FLYCAPTURE2) Point Grey user
endef
else
define FLYCAPTURE2_ARM_LIB_USERS
	$(USERNAME_FLYCAPTURE2) -1 $(GROUP_FLYCAPTURE2) -1 = /home/$(USERNAME_FLYCAPTURE2) /bin/sh $(GROUP_FLYCAPTURE2) Point Grey user
endef
endif

define FLYCAPTURE2_ARM_LIB_INSTALL_TARGET_CMDS
	# Install libs
	$(INSTALL) -m 0755 -D $(@D)/lib/libflycapture.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/; \
	ln -sf libflycapture.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/libflycapture.so.2; \
	ln -sf libflycapture.so.2 $(TARGET_DIR)/lib/libflycapture.so; \
	$(INSTALL) -m 0755 -D $(@D)/lib/libflycapturegui.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/; \
	ln -sf libflycapturegui.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/libflycapturegui.so.2; \
	ln -sf libflycapturegui.so.2 $(TARGET_DIR)/lib/libflycapturegui.so; \
	$(INSTALL) -m 0755 -D $(@D)/lib/C/libflycapture-c.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/; \
	ln -sf libflycapture-c.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/libflycapture-c.so.2; \
	ln -sf libflycapture-c.so.2 $(TARGET_DIR)/lib/libflycapture-c.so; \
	$(INSTALL) -m 0755 -D $(@D)/lib/C/libflycapturegui-c.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/; \
	ln -sf libflycapturegui-c.so.$(FLYCAPTURE2_LIB_VERSION) $(TARGET_DIR)/lib/libflycapturegui-c.so.2; \
	ln -sf libflycapturegui-c.so.2 $(TARGET_DIR)/lib/libflycapturegui-c.so; \
	# Install test program
	$(INSTALL) -m 0755 -D $(@D)/bin/C/snapshot/snapshot $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot;
	# Create udev rules file
	(\
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"2000\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"2001\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"2002\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"2003\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"2004\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"2005\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3000\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3001\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3004\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3005\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3006\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3007\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3008\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"300A\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"300B\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3100\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3101\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3102\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3103\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3104\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3105\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3106\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3107\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3108\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3109\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "ATTRS{idVendor}==\"1e10\", ATTRS{idProduct}==\"3300\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "KERNEL==\"raw1394\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "KERNEL==\"video1394*\", MODE=\"0664\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "SUBSYSTEM==\"firewire\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
		echo "SUBSYSTEM==\"usb\", GROUP=\"${GROUP_FLYCAPTURE2}\""; \
	) > $(TARGET_DIR)/etc/udev/rules.d/40-pgr.rules
endef

$(eval $(generic-package))
