#############################################################
#
# shcodecs
#
#############################################################
SHCODECS_VERSION = 1.3.1
SHCODECS_SOURCE = libshcodecs-$(SHCODECS_VERSION).tar.gz
SHCODECS_SITE = http://github.com/downloads/pedwo/libshcodecs

SHCODECS_AUTORECONF = YES
SHCODECS_INSTALL_STAGING = YES
SHCODECS_INSTALL_TARGET = YES

SHCODECS_DEPENDENCIES = host-pkg-config shveu shbeu uiomux

define SHCODECS_INSTALL_MIDDLEWARE
	mkdir -p $(BUILD_DIR)/middleware
	tar jxf $(DL_DIR)/libshvpu44a.tar.bz2 -C $(BUILD_DIR)/middleware
	install $(BUILD_DIR)/middleware/*.so* $(STAGING_DIR)/usr/lib
	install $(BUILD_DIR)/middleware/*.so* $(TARGET_DIR)/usr/lib
endef

SHCODECS_POST_EXTRACT_HOOKS += SHCODECS_INSTALL_MIDDLEWARE

$(eval $(call AUTOTARGETS,package,shcodecs))
