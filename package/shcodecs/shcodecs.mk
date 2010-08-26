#############################################################
#
# shcodecs
#
#############################################################
SHCODECS_VERSION = latest
SHCODECS_SOURCE = libshcodecs-$(SHCODECS_VERSION).tar.gz
SHCODECS_SITE = 

SHCODECS_AUTORECONF = YES
SHCODECS_INSTALL_STAGING = YES
SHCODECS_INSTALL_TARGET = YES

SHCODECS_DEPENDENCIES = host-pkg-config shveu shbeu uiomux

define SHCODECS_INSTALL_MIDDLEWARE
	tar jxf $(TOPDIR)/../../shcodecs/libshvpu44a.tar.bz2 -C $(TOPDIR)/../../shcodecs
	cp -dpf $(TOPDIR)/../../shcodecs/*.so* $(STAGING_DIR)/usr/lib
	cp -dpf $(TOPDIR)/../../shcodecs/*.so* $(TARGET_DIR)/usr/lib
endef

SHCODECS_POST_EXTRACT_HOOKS += SHCODECS_INSTALL_MIDDLEWARE

$(eval $(call AUTOTARGETS,package,shcodecs))
