#############################################################
#
# shveu
#
#############################################################
SHVEU_VERSION = 1.4.0
SHVEU_SOURCE = libshveu-$(SHVEU_VERSION).tar.gz
SHVEU_SITE = 

SHVEU_AUTORECONF = YES
SHVEU_INSTALL_STAGING = YES
SHVEU_INSTALL_TARGET = YES

SHVEU_DEPENDENCIES = host-pkg-config uiomux

$(eval $(call AUTOTARGETS,package,shveu))
