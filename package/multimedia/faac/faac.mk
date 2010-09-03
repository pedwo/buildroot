#############################################################
#
# faac
#
#############################################################

FAAC_VERSION=1.28
FAAC_SOURCE=faac-$(FAAC_VERSION).tar.bz2
FAAC_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/faac/
FAAC_INSTALL_STAGING=YES
FAAC_LIBTOOL_PATCH=NO

FAAC_DIR:=$(BUILD_DIR)/faac-$(FAAC_VERSION)

define FAAC_GCC_4_4_FIX
	$(SED) 's@char \*strcasestr@//char *strcasestr@' "${FAAC_DIR}/common/mp4v2/mpeg4ip.h"
endef

FAAC_POST_EXTRACT_HOOKS += FAAC_GCC_4_4_FIX

$(eval $(call AUTOTARGETS,package/multimedia,faac))
