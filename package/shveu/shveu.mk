#############################################################
#
# shveu
#
#############################################################
SHVEU_VERSION = 1.5.2
SHVEU_SOURCE = libshveu-$(SHVEU_VERSION).tar.gz
SHVEU_SITE = http://github.com/downloads/pedwo/libshveu

SHVEU_AUTORECONF = YES
SHVEU_INSTALL_STAGING = YES
SHVEU_INSTALL_TARGET = YES

SHVEU_DEPENDENCIES = host-pkg-config uiomux ncurses

$(eval $(call AUTOTARGETS,package,shveu))