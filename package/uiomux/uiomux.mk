#############################################################
#
# uiomux
#
#############################################################
UIOMUX_VERSION = 1.2.0
UIOMUX_SOURCE = libuiomux-$(UIOMUX_VERSION).tar.gz
UIOMUX_SITE = 

UIOMUX_AUTORECONF = YES
UIOMUX_INSTALL_STAGING = YES
UIOMUX_INSTALL_TARGET = YES

UIOMUX_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS,package,uiomux))
