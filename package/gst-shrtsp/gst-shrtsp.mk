#############################################################
#
# gst-shrtsp
#
#############################################################
GST_SHRTSP_VERSION = latest
GST_SHRTSP_SOURCE = gst-shrtsp-$(GST_SHRTSP_VERSION).tar.bz2
GST_SHRTSP_SITE = 

GST_SHRTSP_AUTORECONF = YES
GST_SHRTSP_AUTORECONF_OPT = -I$(GST_SHRTSP_DIR)/m4 -I$(GST_SHRTSP_DIR)/common/m4
GST_SHRTSP_INSTALL_STAGING = YES
GST_SHRTSP_INSTALL_TARGET = YES

GST_SHRTSP_DEPENDENCIES = host-pkg-config gst-sh-mobile gst-rtsp

GST_SHRTSP_CONF_OPT = \
	--program-prefix="" \
	--program-transform-name=""

$(eval $(call AUTOTARGETS,package,gst-shrtsp))
