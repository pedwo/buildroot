#############################################################
#
# shjpeg
#
#############################################################
SHJPEG_VERSION = 1.3.1
SHJPEG_SOURCE = libshjpeg-$(SHJPEG_VERSION).tar.gz
SHJPEG_SITE = http://github.com/downloads/pedwo/libshjpeg

SHJPEG_AUTORECONF = YES
SHJPEG_INSTALL_STAGING = YES
SHJPEG_INSTALL_TARGET = YES

SHJPEG_DEPENDENCIES = host-pkg-config uiomux

$(eval $(call AUTOTARGETS,package,shjpeg))
