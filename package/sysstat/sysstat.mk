#############################################################
#
# sysstat
#
#############################################################

SYSSTAT_VERSION = 9.1.5
SYSSTAT_SOURCE = sysstat-$(SYSSTAT_VERSION).tar.bz2
SYSSTAT_SITE = http://pagesperso-orange.fr/sebastien.godard/
SYSSTAT_AUTORECONF = NO
SYSSTAT_LIBTOOL_PATCH = NO
SYSSTAT_INSTALL_STAGING = NO
SYSSTAT_INSTALL_TARGET = YES

SYSSTAT_CONF_OPT = --disable-man-group
ifneq ($(BR2_HAVE_DOCUMENTATION),y)
SYSSTAT_CONF_OPT += --disable-documentation
endif

# The isag tool is a post processing script that depends on tcl/tk
# among other things. So we don't install it.
SYSSTAT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) INSTALL_ISAG=n install

$(eval $(call AUTOTARGETS,package,sysstat))
