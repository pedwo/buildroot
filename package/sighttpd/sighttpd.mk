#############################################################
#
# sighttpd
#
#############################################################
SIGHTTPD_VERSION = 1.2.0
SIGHTTPD_SOURCE = sighttpd-$(SIGHTTPD_VERSION).tar.gz
SIGHTTPD_SITE = http://github.com/downloads/pedwo/sighttpd/$(SIGHTTPD_SOURCE)

SIGHTTPD_AUTORECONF = YES
SIGHTTPD_INSTALL_STAGING = YES
SIGHTTPD_INSTALL_TARGET = YES

SIGHTTPD_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,sighttpd))
