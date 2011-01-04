#############################################################
#
# gst-openmax
#
#############################################################
GST_OPENMAX_VERSION = 0.10.1
GST_OPENMAX_SOURCE = gst-openmax-$(GST_OPENMAX_VERSION).tar.gz
GST_OPENMAX_SITE = http://gstreamer.freedesktop.org/src/gst-openmax/
GST_OPENMAX_INSTALL_STAGING = YES
GST_OPENMAX_LIBTOOL_PATCH = NO
GST_OPENMAX_DEPENDENCIES = gstreamer gst-plugins-base

$(eval $(call AUTOTARGETS,package/multimedia,gst-openmax))
