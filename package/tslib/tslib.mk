#############################################################
#
# tslib
#
#############################################################
TSLIB_VERSION = d9ff92d4
TSLIB_SOURCE = tslib-$(TSLIB_VERSION).tar.gz
TSLIB_SITE = http://github.com/downloads/pedwo/tslib

TSLIB_AUTORECONF = YES
TSLIB_LIBTOOL_PATCH = NO
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_TARGET = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

# Other files
define TSLIB_FILES
	$(INSTALL) -m 0644 -D package/tslib/touch.env $(TARGET_DIR)
	$(INSTALL) -m 0644 -D package/tslib/pointercal $(TARGET_DIR)/etc

	$(SED) 's/\# module_raw input/module_raw input/' $(BUILD_DIR)/tslib-$(TSLIB_VERSION)/etc/ts.conf
endef

TSLIB_POST_EXTRACT_HOOKS += TSLIB_FILES

TSLIB_CONF_OPT = \
	--enable-shared	\
	--prefix=/usr	\
	--sysconfdir=/etc

$(eval $(call AUTOTARGETS,package,tslib))
