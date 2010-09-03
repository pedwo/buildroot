#############################################################
#
# gst-shrtsp
#
#############################################################
GST_SHRTSP_VERSION = 0.1.0
GST_SHRTSP_SOURCE = gst-shrtsp-$(GST_SHRTSP_VERSION).tar.gz
GST_SHRTSP_SITE = http://github.com/downloads/pedwo/gst-shrtsp

GST_SHRTSP_AUTORECONF = YES
GST_SHRTSP_INSTALL_STAGING = YES
GST_SHRTSP_INSTALL_TARGET = YES

GST_SHRTSP_DEPENDENCIES = host-pkg-config gst-sh-mobile gst-rtsp

$(eval $(call AUTOTARGETS,package,gst-shrtsp))
