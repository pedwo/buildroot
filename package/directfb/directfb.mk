#############################################################
#
# directfb
#
#############################################################
DIRECTFB_VERSION_MAJOR:=1.4
DIRECTFB_VERSION:=1.4.3
DIRECTFB_SITE:=http://www.directfb.org/downloads/Core/DirectFB-$(DIRECTFB_VERSION_MAJOR)
DIRECTFB_SOURCE:=DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_AUTORECONF = NO
DIRECTFB_LIBTOOL_PATCH = NO
DIRECTFB_INSTALL_STAGING = YES
DIRECTFB_INSTALL_TARGET = YES

# Renesas Start
DIRECTFB_DIR:=$(BUILD_DIR)/directfb-$(DIRECTFB_VERSION)

# Fix SH detection for CodeSourcery toolchain
define DIRECTFB_SH_TOOLCHAIN
	$(SED) 's/sh4-\* | sh3-\*)/sh4-\* | sh3-\* | sh-\*)/' $(DIRECTFB_DIR)/configure.in
endef
DIRECTFB_POST_EXTRACT_HOOKS += DIRECTFB_SH_TOOLCHAIN

# Fix tslib detection
define DIRECTFB_TSLIB_VERSION
	$(SED) 's/tslib-0.0/tslib-1.0/' $(DIRECTFB_DIR)/configure.in
endef
DIRECTFB_POST_EXTRACT_HOOKS += DIRECTFB_TSLIB_VERSION
# Renesas End

ifeq ($(BR2_PACKAGE_DIRECTFB_MULTI),y)
DIRECTFB_MULTI:=--enable-multi --enable-fusion
DIRECTFB_FUSION:=linux-fusion
else
DIRECTFB_MULTI:=
DIRECTFB_FUSION:=
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_DEBUG),y)
DIRECTFB_DEBUG:=--enable-debug
else
DIRECTFB_DEBUG:=
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_TRACE),y)
DIRECTFB_TRACE:=--enable-trace
else
DIRECTFB_TRACE:=
endif

ifeq ($(BR2_PACKAGE_XSERVER),y)
DIRECTFB_X:=--enable-x11
else
DIRECTFB_X:=--disable-x11
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_UNIQUE),y)
DIRECTFB_UNIQUE:=--enable-unique
else
DIRECTFB_UNIQUE:=--disable-unique
endif

DIRECTFB_GFX:=
ifeq ($(BR2_PACKAGE_DIRECTFB_ATI128),y)
DIRECTFB_GFX+= ati128
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_CLE266),y)
DIRECTFB_GFX+= cle266
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_CYBER5K),y)
DIRECTFB_GFX+= cyber5k
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_MATROX),y)
DIRECTFB_GFX+= matrox
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_PXA3XX),y)
DIRECTFB_GFX+= pxa3xx
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_UNICHROME),y)
DIRECTFB_GFX+= unichrome
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_I830),y)
DIRECTFB_GFX+= i830
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_SH772X),y)
DIRECTFB_GFX+= sh772x
endif
ifeq ($(DIRECTFB_GFX),)
DIRECTFB_GFX:=none
else
DIRECTFB_GFX:=$(subst $(space),$(comma),$(strip $(DIRECTFB_GFX)))
endif

DIRECTFB_INPUT:=
ifeq ($(BR2_PACKAGE_DIRECTFB_LINUXINPUT),y)
DIRECTFB_INPUT+= linuxinput
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_KEYBOARD),y)
DIRECTFB_INPUT+= keyboard
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_PS2MOUSE),y)
DIRECTFB_INPUT+= ps2mouse
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_SERIALMOUSE),y)
DIRECTFB_INPUT+= serialmouse
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_TSLIB),y)
DIRECTFB_INPUT+= tslib
DIRECTFB_DEP+= tslib
endif
ifeq ($(DIRECTFB_INPUT),)
DIRECTFB_INPUT:=none
else
DIRECTFB_INPUT:=$(subst $(space),$(comma),$(strip $(DIRECTFB_INPUT)))
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_GIF),y)
DIRECTFB_GIF:=--enable-gif
else
DIRECTFB_GIF:=--disable-gif
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_PNG),y)
DIRECTFB_PNG:=--enable-png
DIRECTFB_DEP+= libpng
else
DIRECTFB_PNG:=--disable-png
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_JPEG),y)
DIRECTFB_JPEG:=--enable-jpeg
DIRECTFB_DEP+= jpeg
else
DIRECTFB_JPEG:=--disable-jpeg
endif

ifeq ($(BR2_PACKAGE_DIRECTB_DITHER_RGB16),y)
DIRECTFB_DITHER_RGB16:=--with-dither-rgb16=advanced
else
DIRECTFB_DITHER_RGB16:=--with-dither-rgb16=none
endif

ifeq ($(BR2_PACKAGE_DIRECTB_TESTS),y)
DIRECTFB_TESTS:=--with-tests
else
DIRECTFB_TESTS:=
endif

DIRECTFB_CONF_OPT = \
	--localstatedir=/var \
	--with-gfxdrivers=$(DIRECTFB_GFX) \
	--with-inputdrivers=$(DIRECTFB_INPUT) \
	--enable-static \
	--enable-shared \
	--disable-explicit-deps \
	--program-prefix='' \
	$(DIRECTFB_MULTI) \
	$(DIRECTFB_DEBUG) \
	$(DIRECTFB_TRACE) \
	$(DIRECTFB_X) \
	$(DIRECTFB_JPEG) \
	$(DIRECTFB_PNG) \
	$(DIRECTFB_GIF) \
	$(DIRECTFB_UNIQUE) \
	$(DIRECTFB_DITHER_RGB16) \
	--enable-linux-input \
	--enable-zlib \
	--enable-freetype \
	--enable-fbdev \
	--disable-sysfs \
	--disable-sdl \
	--disable-vnc \
	--disable-video4linux \
	--disable-video4linux2 \
	$(DIRECTFB_TESTS)

DIRECTFB_DEPENDENCIES = $(DIRECTFB_DEP) freetype $(DIRECTFB_FUSION)

HOST_DIRECTFB_DEPENDENCIES = host-pkg-config
HOST_DIRECTFB_CONF_OPT = \
		--enable-shared \
		--disable-static \
		--disable-debug \
		--disable-multi \
		--with-gfxdrivers=none \
		--with-inputdrivers=none

HOST_DIRECTFB_BUILD_CMDS = \
	$(MAKE) -C $(@D)/tools directfb-csource

HOST_DIRECTFB_INSTALL_CMDS = \
	$(INSTALL) -m 0755 $(@D)/tools/directfb-csource $(HOST_DIR)/usr/bin

$(eval $(call AUTOTARGETS,package,directfb))
$(eval $(call AUTOTARGETS,package,directfb,host))

# directfb-csource for the host
DIRECTFB_HOST_BINARY:=$(HOST_DIR)/usr/bin/directfb-csource
