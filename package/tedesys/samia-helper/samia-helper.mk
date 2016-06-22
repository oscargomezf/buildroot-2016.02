################################################################################
#
# samia-helper
#
################################################################################

SAMIA_HELPER_VERSION = 11
SAMIA_HELPER_SITE = http://svn.tedesys.net/samia/trunk/scripts
SAMIA_HELPER_SITE_METHOD = svn
SAMIA_HELPER_INSTALL_STAGING = NO
SAMIA_HELPER_INSTALL_TARGET = YES
SAMIA_HELPER_LICENSE = GPLv2+
SAMIA_HELPER_LICENSE_FILES = COPYING
SAMIA_HELPER_DEPENDENCIES = flycapture2-arm-lib
SAMIA_HELPER_GROUP = pgrimaging
SAMIA_HELPER_USER = $(call qstrip,$(BR2_PACKAGE_USERNAME_FLYCAPTURE2))

define SAMIA_HELPER_INSTALL_TARGET_CMDS
	# Create /home/$(SAMIA_HELPER_USER)/snapshot folder
	mkdir -p $(TARGET_DIR)/home/$(SAMIA_HELPER_USER)/snapshot;
	# Install snapshot.sh script
	$(INSTALL) -m 0755 -D $(@D)/snapshot.sh $(TARGET_DIR)/home/$(SAMIA_HELPER_USER)/snapshot/snapshot.sh;
	# Install configuration files
	$(INSTALL) -m 0660 -D $(@D)/configs/default_fl3_u3_13y3m_c.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/default_fl3_u3_13y3m_c.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED1.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED1.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED2.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED2.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED3.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED3.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED4.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED4.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED5.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED5.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED6.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED6.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED7.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED7.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED8.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED8.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED9.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED9.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED10.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED10.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED11.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED11.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED12.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED12.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED13.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED13.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED14.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED14.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED15.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED15.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED16.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED16.ini; \
	$(INSTALL) -m 0660 -D $(@D)/configs/configLED17.ini $(TARGET_DIR)/home/$(USERNAME_FLYCAPTURE2)/snapshot/configs/configLED17.ini;
endef

$(eval $(generic-package))
