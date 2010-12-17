#############################################################
#
# xkeyboard-config
#
#############################################################
XKEYBOARD_CONFIG_VERSION = 1.8
XKEYBOARD_CONFIG_SOURCE = xkeyboard-config-$(XKEYBOARD_CONFIG_VERSION).tar.bz2
XKEYBOARD_CONFIG_SITE = http://xlibs.freedesktop.org/xkbdesc
XKEYBOARD_CONFIG_AUTORECONF = NO
XKEYBOARD_CONFIG_INSTALL_STAGING = NO
XKEYBOARD_CONFIG_INSTALL_TARGET = YES
XKEYBOARD_CONFIG_DEPENDENCIES = host-intltool host-xapp_xkbcomp

XKEYBOARD_CONFIG_CONF_OPT = GMSGFMT=/usr/bin/msgfmt

$(eval $(call AUTOTARGETS,package/x11r7,xkeyboard-config))

