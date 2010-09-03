#############################################################
#
# gst-ffmpeg
#
#############################################################
GST_FFMPEG_VERSION = 0.10.9
GST_FFMPEG_SOURCE = gst-ffmpeg-$(GST_FFMPEG_VERSION).tar.bz2
GST_FFMPEG_SITE = http://gstreamer.freedesktop.org/src/gst-ffmpeg/
GST_FFMPEG_LIBTOOL_PATCH = NO

GST_FFMPEG_CONF_OPT = \
	--with-forced-embedded-ffmpeg \
	--with-ffmpeg-extra-configure=--target-os=linux

$(eval $(call AUTOTARGETS,package/multimedia,gst-ffmpeg))
