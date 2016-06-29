################################################################################
#
# tedgpio-lib
#
################################################################################

TEDGPIO_LIB_VERSION = 11
TEDGPIO_LIB_SITE = http://svn.tedesys.net/tedgpio-lib/trunk
TEDGPIO_LIB_SITE_METHOD = svn
TEDGPIO_LIB_INSTALL_STAGING = NO
TEDGPIO_LIB_INSTALL_TARGET = YES
TEDGPIO_LIB_LICENSE = GPLv2+
TEDGPIO_LIB_LICENSE_FILES = COPYING
TEDGPIO_LIB_MAYOR_VERSION = 0

define TEDGPIO_LIB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define TEDGPIO_LIB_INSTALL_TARGET_CMDS
	# Install gpio_control application
	$(INSTALL) -m 4755 -D $(@D)/bin/gpio_control $(TARGET_DIR)/usr/sbin/gpio_control;
endef

$(eval $(generic-package))
