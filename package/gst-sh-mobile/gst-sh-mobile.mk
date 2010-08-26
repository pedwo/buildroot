#############################################################
#
# gst-sh-mobile
#
#############################################################
GST_SH_MOBILE_VERSION = 2010-07-19
GST_SH_MOBILE_SOURCE = gst-sh-mobile-$(GST_SH_MOBILE_VERSION).tar.bz2
GST_SH_MOBILE_SITE =

GST_SH_MOBILE_AUTORECONF = YES
GST_SH_MOBILE_INSTALL_STAGING = YES
GST_SH_MOBILE_INSTALL_TARGET = YES

GST_SH_MOBILE_DEPENDENCIES = gstreamer gst-plugins-base uiomux shcodecs shveu

$(eval $(call AUTOTARGETS,package,gst-sh-mobile))
