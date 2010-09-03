#############################################################
#
# gst-rtsp
#
#############################################################
GST_RTSP_VERSION = 0.10.5
GST_RTSP_SOURCE = gst-rtsp-$(GST_RTSP_VERSION).tar.bz2
GST_RTSP_SITE = http://people.freedesktop.org/~wtay/
GST_RTSP_LIBTOOL_PATCH = NO
GST_RTSP_INSTALL_STAGING = YES
GST_RTSP_INSTALL_TARGET = YES

GST_RTSP_DEPENDENCIES = gst-plugins-base gstreamer liboil

$(eval $(call AUTOTARGETS,package/multimedia,gst-rtsp))
