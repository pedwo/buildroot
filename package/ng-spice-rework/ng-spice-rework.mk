#############################################################
#
# ng-spice-rework
#
#############################################################
NG_SPICE_REWORK_VERSION = 17
NG_SPICE_REWORK_SOURCE = ng-spice-rework-$(NG_SPICE_REWORK_VERSION).tar.gz
NG_SPICE_REWORK_SITE = http://superb-west.dl.sourceforge.net/sourceforge/ngspice
NG_SPICE_REWORK_AUTORECONF = NO
NG_SPICE_REWORK_INSTALL_STAGING = NO
NG_SPICE_REWORK_INSTALL_TARGET = YES

NG_SPICE_REWORK_CONF_OPT = CFLAGS="-I$(STAGING_DIR)/usr/include"

NG_SPICE_REWORK_DEPENDENCIES = xserver_xorg-server xlib_libXaw

$(eval $(call AUTOTARGETS,package,ng-spice-rework))

