#############################################################
#
# tslib
#
#############################################################
TSLIB_VERSION:=r77
TSLIB_SOURCE:=tslib-$(TSLIB_VERSION).tar.bz2
TSLIB_SITE:=http://download.berlios.de/tslib
TSLIB_AUTORECONF = YES
TSLIB_LIBTOOL_PATCH = NO
TSLIB_INSTALL_STAGING = YES
TSLIB_INSTALL_TARGET = YES
TSLIB_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

TSLIB_CONF_OPT = \
	--enable-shared	\
	--prefix=/usr	\
	--sysconfdir=/etc

$(eval $(call AUTOTARGETS,package,tslib))
