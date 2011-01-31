#############################################################
#
# uiomux
#
#############################################################
UIOMUX_VERSION = 1.6.1
UIOMUX_SOURCE = libuiomux-$(UIOMUX_VERSION).tar.gz
UIOMUX_SITE = https://github.com/downloads/pedwo/libuiomux

UIOMUX_AUTORECONF = YES
UIOMUX_INSTALL_STAGING = YES
UIOMUX_INSTALL_TARGET = YES

UIOMUX_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,uiomux))
