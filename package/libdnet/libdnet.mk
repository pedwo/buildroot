#############################################################
#
# libdnet
#
#############################################################

LIBDNET_VERSION = 1.11
LIBDNET_SOURCE = libdnet-$(LIBDNET_VERSION).tar.gz
LIBDNET_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libdnet/
LIBDNET_INSTALL_STAGING = YES
LIBDNET_INSTALL_TARGET = YES
LIBDNET_AUTORECONF = YES
LIBDNET_CONF_OPT = \
	--with-gnu-ld \
	--enable-shared \
	--enable-static \
	--with-check=no

ifneq ($(BR2_PACKAGE_LIBDNET_PYTHON),)
LIBDNET_DEPENDENCIES = python
LIBDNET_CONF_OPT += --with-python
LIBDNET_MAKE_OPT = PYTHON=python$(PYTHON_VERSION_MAJOR) PYINCDIR=$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
LIBDNET_INSTALL_TARGET_OPT = $(LIBDNET_MAKE_OPT) DESTDIR=$(TARGET_DIR) INSTALL_STRIP_FLAG=-s install-exec
LIBDNET_INSTALL_STAGING_OPT = $(LIBDNET_MAKE_OPT) DESTDIR=$(STAGING_DIR) install
endif

# Needed for autoreconf to work properly
define LIBDNET_FIXUP_ACINCLUDE_M4
	ln -sf config/acinclude.m4 $(@D)
endef

LIBDNET_POST_EXTRACT_HOOKS += LIBDNET_FIXUP_ACINCLUDE_M4

$(eval $(call AUTOTARGETS,package,libdnet))
