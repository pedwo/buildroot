#############################################################
#
# directfb_sh772x_gfx
#
#############################################################
DIRECTFB_VERSION_MAJOR:=1.4
DIRECTFB_VERSION:=$(DIRECTFB_VERSION_MAJOR).10
DIRECTFB_SH772X_GFX_AUTORECONF = NO
DIRECTFB_SH772X_GFX_INSTALL_STAGING = YES
DIRECTFB_SH772X_GFX_INSTALL_TARGET = YES

LINUX_FOR_DFB=$(BR2_LINUX_KERNEL_VERSION)

# We are operating in a specific dir of the DirectFB src
DIRECTFB_SH772X_GFX_DIR:=$(BUILD_DIR)/directfb-$(DIRECTFB_VERSION)/gfxdrivers/sh772x

DIRECTFB_SH772X_GFX_MAKE_OPTS:=  KERNEL_VERSION=$(LINUX_FOR_DFB)
DIRECTFB_SH772X_GFX_MAKE_OPTS += KERNEL_BUILD=$(BUILD_DIR)/linux-$(LINUX_FOR_DFB)
DIRECTFB_SH772X_GFX_MAKE_OPTS += KERNEL_SOURCE=$(BUILD_DIR)/linux-$(LINUX_FOR_DFB)

DIRECTFB_SH772X_GFX_MAKE_OPTS += SYSROOT=$(STAGING_DIR)
#DIRECTFB_SH772X_GFX_MAKE_OPTS += ARCH=$(BR2_ARCH)
DIRECTFB_SH772X_GFX_MAKE_OPTS += ARCH=sh
DIRECTFB_SH772X_GFX_MAKE_OPTS += CROSS_COMPILE=$(TARGET_CROSS)
DIRECTFB_SH772X_GFX_MAKE_OPTS += KERNEL_MODLIB=/lib/modules/$(LINUX_FOR_DFB)
DIRECTFB_SH772X_GFX_MAKE_OPTS += DESTDIR=$(TARGET_DIR)
DIRECTFB_SH772X_GFX_MAKE_OPTS += HEADERDIR=$(STAGING_DIR)


$(DIRECTFB_SH772X_GFX_DIR)/.install:
	mkdir -p $(STAGING_DIR)/lib/modules/$(LINUX_FOR_DFB)/source/include/linux
	$(MAKE) -C $(DIRECTFB_SH772X_GFX_DIR) -f Makefile.kernel \
		$(DIRECTFB_SH772X_GFX_MAKE_OPTS)
	$(MAKE) -C $(DIRECTFB_SH772X_GFX_DIR) -f Makefile.kernel install \
		$(DIRECTFB_SH772X_GFX_MAKE_OPTS)
	cp -dpf $(DIRECTFB_SH772X_GFX_DIR)/directfbrc.sh7723 $(TARGET_DIR)/etc/directfbrc
	touch $@


directfb_sh772x_gfx-source:

directfb_sh772x_gfx-unpacked:

directfb_sh772x_gfx: linux26 $(DIRECTFB_SH772X_GFX_DIR)/.install

directfb_sh772x_gfx-clean:
	-$(MAKE) -C $(DIRECTFB_SH772X_GFX_DIR) -f Makefile.kernel clean
	rm -f $(TARGET_DIR)/lib/modules/$(LINUX_FOR_DFB)/renesas/sh772x_gfx.ko
	rm -f $(DIRECTFB_SH772X_GFX_DIR)/.install

directfb_sh772x_gfx-dirclean:

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_DIRECTFB_SH772X_GFX),y)
TARGETS+=directfb_sh772x_gfx
endif

