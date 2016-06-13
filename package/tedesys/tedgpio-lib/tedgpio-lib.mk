################################################################################
#
# tedgpio-lib
#
################################################################################

TEDGPIO_LIB_VERSION = 7
TEDGPIO_LIB_SITE = http://svn.tedesys.net/tedgpio/trunk
TEDGPIO_LIB_SITE_METHOD = svn
TEDGPIO_LIB_INSTALL_STAGING = YES
TEDGPIO_LIB_INSTALL_TARGET = YES
TEDGPIO_LIB_LICENSE = GPLv2+
TEDGPIO_LIB_LICENSE_FILES = COPYING

define TEDGPIO_LIB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define TEDGPIO_LIB_INSTALL_STAGING_CMDS
        # Install tedgpio shared lib
        $(INSTALL) -m 0755 -D $(@D)/libtedgpio.so $(TARGET_DIR)/lib/libtedgpio.so.$(TEDGPIO_LIB_VERSION); \
        ln -sf libtedgpio.so.$(TEDGPIO_LIB_VERSION) $(TARGET_DIR)/lib/libtedgpio.so.2; \
        ln -sf libtedgpio.so.2 $(TARGET_DIR)/lib/libtedgpio.so;
endef

ifeq ($(BR2_PACKAGE_GPIO_CONTROL),y)
define TEDGPIO_LIB_INSTALL_TARGET_CMDS
	# Install gpio_control application
	$(INSTALL) -m 0755 -D $(@D)/bin/gpio_control $(TARGET_DIR)/usr/sbin/gpio_control;
endef
endif

$(eval $(generic-package))
