#############################################################
#
# gst-sh-mobile
#
#############################################################
GST_SH_MOBILE_VERSION = 0.10.2
GST_SH_MOBILE_SOURCE = gst-sh-mobile-$(GST_SH_MOBILE_VERSION).tar.gz
GST_SH_MOBILE_SITE = http://github.com/downloads/pedwo/gst-sh-mobile

GST_SH_MOBILE_AUTORECONF = YES
GST_SH_MOBILE_INSTALL_STAGING = YES
GST_SH_MOBILE_INSTALL_TARGET = YES

GST_SH_MOBILE_DEPENDENCIES = gstreamer gst-plugins-base uiomux shcodecs shveu shbeu

$(eval $(call AUTOTARGETS,package,gst-sh-mobile))
