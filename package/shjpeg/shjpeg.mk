#############################################################
#
# shjpeg
#
#############################################################
SHJPEG_VERSION = 1.2.0
SHJPEG_SOURCE = libshjpeg-$(SHJPEG_VERSION).tar.gz
SHJPEG_SITE = 

SHJPEG_AUTORECONF = YES
SHJPEG_INSTALL_STAGING = YES
SHJPEG_INSTALL_TARGET = YES

SHJPEG_DEPENDENCIES = host-pkg-config uiomux

$(eval $(call AUTOTARGETS,package,shjpeg))
