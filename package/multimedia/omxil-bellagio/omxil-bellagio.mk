#############################################################
#
# omxil-bellagio
#
#############################################################
OMXIL_BELLAGIO_VERSION = 0.9.2.1
OMXIL_BELLAGIO_SOURCE = libomxil-bellagio-$(OMXIL_BELLAGIO_VERSION).tar.gz
OMXIL_BELLAGIO_SITE = http://downloads.sourceforge.net/omxil/
OMXIL_BELLAGIO_AUTORECONF = YES

$(eval $(call AUTOTARGETS,package/multimedia,omxil-bellagio))
