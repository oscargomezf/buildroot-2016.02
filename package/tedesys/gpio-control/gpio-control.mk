################################################################################
#
# gpio-control
#
################################################################################

GPIO_CONTROL_VERSION = 3
GPIO_CONTROL_SITE = http://svn.tedesys.net/gpio_control/trunk
GPIO_CONTROL_SITE_METHOD = svn
GPIO_CONTROL_INSTALL_STAGING = NO
GPIO_CONTROL_INSTALL_TARGET = YES
GPIO_CONTROL_LICENSE = GPLv2+
GPIO_CONTROL_LICENSE_FILES = COPYING

define GPIO_CONTROL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define GPIO_CONTROL_INSTALL_TARGET_CMDS
	# Install gpio_control application
	$(INSTALL) -m 0755 -D $(@D)/bin/gpio_control $(TARGET_DIR)/usr/sbin/gpio_control;
endef

$(eval $(generic-package))
