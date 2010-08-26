#############################################################
#
# faad
#
#############################################################

FAAD_VERSION=2.7
FAAD_SOURCE=faad2-$(FAAD_VERSION).tar.bz2
FAAD_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/faac/
FAAD_INSTALL_STAGING=YES
FAAD_LIBTOOL_PATCH=NO

$(eval $(call AUTOTARGETS,package/multimedia,faad))
