#############################################################
#
# libidn
#
#############################################################

LIBIDN_VERSION = 1.15
LIBIDN_SITE = http://ftp.gnu.org/gnu/libidn/
LIBIDN_INSTALL_STAGING = YES
LIBIDN_INSTALL_TARGET = YES
LIBIDN_CONF_ENV = EMACS="no"
LIBIDN_CONF_OPT = --enable-shared --disable-java --enable-csharp=no
LIBIDN_LIBTOOL_PATCH = NO
LIBIDN_DEPENDENCIES = host-pkg-config $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) $(if $(BR2_PACKAGE_LIBICONV),libiconv)

define LIBIDN_REMOVE_BINARY
	rm -f $(TARGET_DIR)/usr/bin/idn
endef

ifneq ($(BR2_PACKAGE_LIBIDN_BINARY),y)
LIBIDN_POST_INSTALL_TARGET_HOOKS += LIBIDN_REMOVE_BINARY
endif

define LIBIDN_REMOVE_EMACS_STUFF
	rm -rf $(TARGET_DIR)/usr/share/emacs
endef

LIBIDN_POST_INSTALL_TARGET_HOOKS += LIBIDN_REMOVE_EMACS_STUFF

define LIBIDN_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/libidn*
	rm -f $(TARGET_DIR)/usr/bin/idn
endef

$(eval $(call AUTOTARGETS,package,libidn))
