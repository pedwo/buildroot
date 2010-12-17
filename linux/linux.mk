###############################################################################
#
# Linux kernel 2.6 target
#
###############################################################################
LINUX26_VERSION=$(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

# Compute LINUX26_SOURCE and LINUX26_SITE from the configuration
ifeq ($(LINUX26_VERSION),custom)
LINUX26_TARBALL:=$(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX26_SITE:=$(dir $(LINUX26_TARBALL))
LINUX26_SOURCE:=$(notdir $(LINUX26_TARBALL))
else
LINUX26_SOURCE:=linux-$(LINUX26_VERSION).tar.bz2
LINUX26_SITE:=$(BR2_KERNEL_MIRROR)/linux/kernel/v2.6/
endif

LINUX26_DIR:=$(BUILD_DIR)/linux-$(LINUX26_VERSION)
LINUX26_PATCH=$(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

LINUX26_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
	ARCH=$(KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LZMA="$(LZMA)"

# Get the real Linux version, which tells us where kernel modules are
# going to be installed in the target filesystem.
LINUX26_VERSION_PROBED = $(shell $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) --no-print-directory -s kernelrelease)

ifeq ($(BR2_LINUX_KERNEL_UIMAGE),y)
LINUX26_IMAGE_NAME=uImage
LINUX26_DEPENDENCIES+=$(MKIMAGE)
else ifeq ($(BR2_LINUX_KERNEL_BZIMAGE),y)
LINUX26_IMAGE_NAME=bzImage
else ifeq ($(BR2_LINUX_KERNEL_ZIMAGE),y)
LINUX26_IMAGE_NAME=zImage
else ifeq ($(BR2_LINUX_KERNEL_VMLINUX_BIN),y)
LINUX26_IMAGE_NAME=vmlinux.bin
endif

ifeq ($(KERNEL_ARCH),avr32)
LINUX26_IMAGE_PATH=$(LINUX26_DIR)/arch/$(KERNEL_ARCH)/boot/images/$(LINUX26_IMAGE_NAME)
else
LINUX26_IMAGE_PATH=$(LINUX26_DIR)/arch/$(KERNEL_ARCH)/boot/$(LINUX26_IMAGE_NAME)
endif

# Download
$(LINUX26_DIR)/.stamp_downloaded:
	@$(call MESSAGE,"Downloading kernel")
	$(call DOWNLOAD,$(LINUX26_SITE),$(LINUX26_SOURCE))
ifneq ($(filter ftp://% http://%,$(LINUX26_PATCH)),)
	$(call DOWNLOAD,$(dir $(LINUX26_PATCH)),$(notdir $(LINUX26_PATCH)))
endif
	mkdir -p $(@D)
	touch $@

# Extraction
$(LINUX26_DIR)/.stamp_extracted: $(LINUX26_DIR)/.stamp_downloaded
	@$(call MESSAGE,"Extracting kernel")
	mkdir -p $(@D)
	$(Q)$(INFLATE$(suffix $(LINUX26_SOURCE))) $(DL_DIR)/$(LINUX26_SOURCE) | \
		tar -C $(@D) $(TAR_STRIP_COMPONENTS)=1 $(TAR_OPTIONS) -
	$(Q)touch $@

# Patch
$(LINUX26_DIR)/.stamp_patched: $(LINUX26_DIR)/.stamp_extracted
	@$(call MESSAGE,"Patching kernel")
ifneq ($(LINUX26_PATCH),)
ifneq ($(filter ftp://% http://%,$(LINUX26_PATCH)),)
	toolchain/patch-kernel.sh $(@D) $(DL_DIR) $(notdir $(LINUX26_PATCH))
else ifeq ($(shell test -d $(LINUX26_PATCH) && echo "dir"),dir)
	toolchain/patch-kernel.sh $(@D) $(LINUX26_PATCH) linux-\*.patch
else
	toolchain/patch-kernel.sh $(@D) $(dir $(LINUX26_PATCH)) $(notdir $(LINUX26_PATCH))
endif
endif
	$(Q)touch $@


# Configuration
$(LINUX26_DIR)/.stamp_configured: $(LINUX26_DIR)/.stamp_patched
	@$(call MESSAGE,"Configuring kernel")
ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
	$(TARGET_MAKE_ENV) $(MAKE1) $(LINUX26_MAKE_FLAGS) -C $(@D) $(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG))_defconfig
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
	cp $(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE) $(@D)/.config
endif
ifeq ($(BR2_ARM_EABI),y)
	$(call KCONFIG_ENABLE_OPT,CONFIG_AEABI,$(@D)/.config)
else
	$(call KCONFIG_DISABLE_OPT,CONFIG_AEABI,$(@D)/.config)
endif
ifeq ($(BR2_INET_IPV6),y)
	$(call KCONFIG_ENABLE_OPT,CONFIG_IPV6,$(@D)/.config)
else
	$(call KCONFIG_DISABLE_OPT,CONFIG_IPV6,$(@D)/.config)
endif
ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
	# As the kernel gets compiled before root filesystems are
	# built, we create a fake initramfs file list. It'll be
	# replaced later by the real list, and the kernel will be
	# rebuilt using the linux26-rebuild-with-initramfs target.
	touch $(BINARIES_DIR)/rootfs.initramfs
	$(call KCONFIG_ENABLE_OPT,CONFIG_BLK_DEV_INITRD,$(@D)/.config)
	$(call KCONFIG_SET_OPT,CONFIG_INITRAMFS_SOURCE,\"$(BINARIES_DIR)/rootfs.initramfs\",$(@D)/.config)
	$(call KCONFIG_ENABLE_OPT,CONFIG_INITRAMFS_COMPRESSION_GZIP,$(@D)/.config)
endif
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) oldconfig
	$(Q)touch $@

# Compilation. We make sure the kernel gets rebuilt when the
# configuration has changed.
$(LINUX26_DIR)/.stamp_compiled: $(LINUX26_DIR)/.stamp_configured $(LINUX26_DIR)/.config
	@$(call MESSAGE,"Compiling kernel")
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) $(LINUX26_IMAGE_NAME)
	@if [ $(shell grep -c "CONFIG_MODULES=y" $(LINUX26_DIR)/.config) != 0 ] ; then 	\
		$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) modules ;	\
	fi
	$(Q)touch $@

# Installation
$(LINUX26_DIR)/.stamp_installed: $(LINUX26_DIR)/.stamp_compiled
	@$(call MESSAGE,"Installing kernel")
	cp $(LINUX26_IMAGE_PATH) $(BINARIES_DIR)
	# Install modules and remove symbolic links pointing to build
	# directories, not relevant on the target
	@if [ $(shell grep -c "CONFIG_MODULES=y" $(LINUX26_DIR)/.config) != 0 ] ; then 	\
		$(TARGET_MAKE_ENV) $(MAKE1) $(LINUX26_MAKE_FLAGS) -C $(@D) 		\
			INSTALL_MOD_PATH=$(TARGET_DIR) modules_install ;		\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION_PROBED)/build ;	\
		rm -f $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION_PROBED)/source ;	\
	fi
	$(Q)touch $@

linux26: host-module-init-tools $(LINUX26_DEPENDENCIES) $(LINUX26_DIR)/.stamp_installed

linux26-menuconfig linux26-xconfig linux26-gconfig: dirs $(LINUX26_DIR)/.stamp_configured
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) $(subst linux26-,,$@)

# Support for rebuilding the kernel after the initramfs file list has
# been generated in $(BINARIES_DIR)/rootfs.initramfs.
$(LINUX26_DIR)/.stamp_initramfs_rebuilt: $(LINUX26_DIR)/.stamp_installed $(BINARIES_DIR)/rootfs.initramfs
	@$(call MESSAGE,"Rebuilding kernel with initramfs")
	# Remove the previously generated initramfs which was empty,
	# to make sure the kernel will actually regenerate it.
	$(RM) -f $(@D)/usr/initramfs_data.cpio.*
	# Build the kernel.
	$(TARGET_MAKE_ENV) $(MAKE) $(LINUX26_MAKE_FLAGS) -C $(@D) $(LINUX26_IMAGE_NAME)
	# Copy the kernel image to its final destination
	cp $(LINUX26_IMAGE_PATH) $(BINARIES_DIR)
	$(Q)touch $@

# The initramfs building code must make sure this target gets called
# after it generated the initramfs list of files.
linux26-rebuild-with-initramfs: $(LINUX26_DIR)/.stamp_initramfs_rebuilt

ifeq ($(BR2_LINUX_KERNEL),y)
TARGETS+=linux26
endif

# Checks to give errors that the user can understand
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(BR2_LINUX_KERNEL_USE_DEFCONFIG),y)
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_DEFCONFIG)),)
$(error No kernel defconfig name specified, check your BR2_LINUX_KERNEL_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG),y)
ifeq ($(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE)),)
$(error No kernel configuration file specified, check your BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE setting)
endif
endif

endif
