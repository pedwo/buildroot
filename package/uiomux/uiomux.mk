#############################################################
#
# uiomux
#
#############################################################
UIOMUX_VERSION = 1.3.0
UIOMUX_SOURCE = libuiomux-$(UIOMUX_VERSION).tar.gz
UIOMUX_SITE = http://github.com/downloads/pedwo/libuiomux

UIOMUX_AUTORECONF = YES
UIOMUX_INSTALL_STAGING = YES
UIOMUX_INSTALL_TARGET = YES

UIOMUX_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,uiomux))
