#############################################################
#
# shbeu
#
#############################################################
SHBEU_VERSION = latest
SHBEU_SOURCE = libshbeu-$(SHBEU_VERSION).tar.gz
SHBEU_SITE = 

SHBEU_AUTORECONF = YES
SHBEU_INSTALL_STAGING = YES
SHBEU_INSTALL_TARGET = YES

SHBEU_DEPENDENCIES = host-pkg-config uiomux

$(eval $(call AUTOTARGETS,package,shbeu))
