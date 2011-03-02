#############################################################
#
# tslib
#
#############################################################
TSLIB_VERSION:=860d69ca
TSLIB_SITE:=git://github.com/kergoth/tslib.git
TSLIB_AUTORECONF = YES
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_TARGET = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

# Other files
define TSLIB_FILES
	$(INSTALL) -m 0644 -D package/tslib/touch.env $(TARGET_DIR)
	$(INSTALL) -m 0644 -D package/tslib/pointercal $(TARGET_DIR)/etc
endef

TSLIB_POST_EXTRACT_HOOKS += TSLIB_FILES

TSLIB_CONF_OPT = \
	--enable-shared	\
	--prefix=/usr	\
	--sysconfdir=/etc

$(eval $(call AUTOTARGETS,package,tslib))
