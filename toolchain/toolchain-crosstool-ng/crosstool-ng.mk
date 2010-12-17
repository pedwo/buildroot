# Makefile fragment for building toolchain with crosstool-NG

# As a reference, you can look at toolchain/toolchain-external/ext-tool.mk
# for a generic approach to external toolchains.
# crosstool-NG as a backend is but a kind of external toolchains,
# except that it is not pre-built.

#-----------------------------------------------------------------------------
# 'uclibc' is the target to depend on to get the toolchain and prepare
# the staging directory and co.
uclibc: dependencies $(STAMP_DIR)/ct-ng-toolchain-installed

#-----------------------------------------------------------------------------
# Internal variables

# Crostool-NG hard-coded configuration options
CTNG_VERSION:=1.8.0
CTNG_SITE:=http://ymorin.is-a-geek.org/download/crosstool-ng/
CTNG_SOURCE:=crosstool-ng-$(CTNG_VERSION).tar.bz2
CTNG_DIR:=$(BUILD_DIR)/crosstool-ng-$(CTNG_VERSION)
CTNG_CAT:=bzcat
CTNG_PATCH_DIR:=toolchain/toolchain-crosstool-ng
CTNG_CONFIG_FILE:=$(call qstrip,$(BR2_TOOLCHAIN_CTNG_CONFIG))
CTNG_UCLIBC_CONFIG_FILE := $(TOPDIR)/toolchain/toolchain-crosstool-ng/uClibc.config

# Hack! ct-ng is in fact a Makefile script. As such, it accepts all
# make options, such as -C, which makes it uneeded to chdir prior
# to calling ct-ng.
# $1: the set of arguments to pass to ct-ng
define ctng
$(CTNG_DIR)/ct-ng -C $(CTNG_DIR) --no-print-directory $(1)
endef

#-----------------------------------------------------------------------------
# Installing the libs to target/ and staging/

#--------------
# The generic system libraries (in /lib)
CTNG_LIBS_LIB := libc.so libcrypt.so libdl.so libgcc_s.so libm.so libnsl.so libpthread.so libresolv.so librt.so libutil.so

#--------------
# The libc-specific system libraries (in /lib)
# Note: it may be needed to tweak the NSS libs in the glibc and eglibc cases...
CTNG_LIBS_uClibc := ld-uClibc.so
CTNG_LIBS_glibc  := ld-linux.so libnss_files.so libnss_dns.so
CTNG_LIBS_eglibc := $(CTNG_LIBS_glibc)

#--------------
# All that we need in /lib
CTNG_LIBS_LIB += $(CTNG_LIBS_$(call qstrip,$(BR2_TOOLCHAIN_CTNG_LIBC)))

#--------------
# All that we need in /usr/lib
ifneq ($(BR2_INSTALL_LIBSTDCPP),)
CTNG_LIBS_USR_LIB += libstdc++.so
endif

#--------------
# Actual copy
$(STAMP_DIR)/ct-ng-toolchain-installed: $(STAMP_DIR)/ct-ng-toolchain-built
	$(Q)mkdir -p $(TARGET_DIR)/lib
	$(Q)CTNG_TUPLE="$$( $(call ctng,show-tuple) )";                     \
	    CTNG_SYSROOT="$(TOOLCHAIN_DIR)/$${CTNG_TUPLE}/sys-root";        \
	    echo "CTNG_TUPLE='$${CTNG_TUPLE}'";                             \
	    echo "CTNG_SYSROOT='$${CTNG_SYSROOT}'";                         \
	    echo "Copy external toolchain libraries to target...";          \
	    for libs in $(CTNG_LIBS_LIB); do                                \
	        $(call copy_toolchain_lib_root,$${CTNG_SYSROOT},$$libs,/lib,$(BR2_TOOLCHAIN_CTNG_STRIP_LIBS)); \
	    done;                                                           \
	    for libs in $(CTNG_LIBS_USR_LIB); do                            \
	        $(call copy_toolchain_lib_root,$${CTNG_SYSROOT},$$libs,/usr/lib,$(BR2_TOOLCHAIN_CTNG_STRIP_LIBS)); \
	    done;                                                           \
	    echo "Copy external toolchain sysroot to staging...";           \
	    $(call copy_toolchain_sysroot,$${CTNG_SYSROOT},$${CTNG_SYSROOT},)
	$(Q)touch $@

#-----------------------------------------------------------------------------
# Building the toolchain

$(STAMP_DIR)/ct-ng-toolchain-built: $(CTNG_DIR)/.config
	$(Q)$(call ctng,build.$(BR2_JLEVEL))
	$(Q)printf "\n"
	$(Q)touch $@

#-----------------------------------------------------------------------------
# Configuring the toolchain

# Note: a lot of the following tricks would become unneeded if one day
# buildroot and crosstool-NG had matching options, especially for the
# target description: arch name, bitness, endianness...

# Note-2: missing conformity check between BR's .config and libc features.
# Use check_uclibc or check_glibc.

#--------------
# Massage BR2_ARCH so that it matches CT-NG's ARCH
# Defaults:
CTNG_ARCH   := $(CTNG_BR2_ARCH)
CTNG_ENDIAN :=
CTNG_BIT    :=
# Architecture overides, only overide pertinent vars:
ifeq      ($(BR2_arm),y)
CTNG_ARCH   := arm
CTNG_ENDIAN := LE
else ifeq ($(BR2_armeb),y)
CTNG_ARCH   := arm
CTNG_ENDIAN := BE
else ifeq ($(BR2_i386),y)
CTNG_ARCH   := x86
CTNG_BIT    := 32
else ifeq ($(BR2_mips),y)
CTNG_ARCH   := mips
CTNG_ENDIAN := BE
else ifeq ($(BR2_mipsel),y)
CTNG_ARCH   := mips
CTNG_ENDIAN := LE
else ifeq ($(BR2_powerpc),y)
CTNG_ARCH   := powerpc
CTNG_BIT    := 32
else ifeq ($(BR2_x86_64),y)
CTNG_ARCH   := x86
CTNG_BIT    := 64
# Add other architecture overides below:
#  - keep alphabetic order
#  - duplicate next 4 lines, and uncomment
#       else ifeq ($(BR2_<arch_name_here>),y)
#       CTNG_ARCH   :=
#       CTNG_ENDIAN :=
#       CTNG_BIT    :=
#  - remove unneeded vars
#  - add BR arch-name on ifeq line
#  - fill-in required CTNG_* vars
endif

#--------------
# Massage BR options into CTNG .config file
# CT_ARCH                   : handled by the backend mechanism
# CT_ARCH_[BL]E             : endianness
# CT_ARCH_(32|64)           : bitness
# CT_PREFIX_DIR             : install into BR's toolchain dir
# CT_INSTALL_DIR_RO         : do *not* chmod a-w the toolchain dir
# CT_LOCAL_TARBALLS_DIR     : share downloads with BR
# CT_SYSROOT_DIR_PREFIX     : no prefix needed, really
# CT_TARGET_VENDOR          : try to set a unique vendor string, to avoid clashing with BR's vendor string
# CT_TARGET_ALIAS           : set the target tuple alias to REAL_GNU_TARGET_NAME so that packages' ./configure find the compiler
# CT_DEBUG_gdb              : deselect gdb+gdbserver if buildroot builds its own
# CT_CC_LANG_CXX            : required if we copy libstdc++.so, and build C++
# CT_LIBC_UCLIBC_CONFIG_FILE: uClibc config file, if needed
#
# Lots of other awfull sed manipulations go here, to override CT-NG's .config
# with BR2 config options.
# Known missing: arch variant & options, floating point (HW/SW), uClibc/eglibc config...
#

CTNG_FIX_DOT_CONFIG_SED :=
CTNG_FIX_DOT_CONFIG_SED += s:^(CT_INSTALL_DIR_RO)=y:\# \1 is not set:;
CTNG_FIX_DOT_CONFIG_SED += s:^(|\# )(CT_ARCH_[BL]E).*:\# \2 is not set:;
CTNG_FIX_DOT_CONFIG_SED += s:^\# (CT_ARCH_$(CTNG_ENDIAN)) is not set:\1=y:;
CTNG_FIX_DOT_CONFIG_SED += s:^(|\# )(CT_ARCH_(32|64)).*:\# \2 is not set:;
CTNG_FIX_DOT_CONFIG_SED += s:^\# (CT_ARCH_$(CTNG_BIT)) is not set:\1=y:;
CTNG_FIX_DOT_CONFIG_SED += s:^\# (CT_ARCH_USE_MMU) is not set:\1=y:;
CTNG_FIX_DOT_CONFIG_SED += s:^(CT_TARGET_VENDOR)=.*:\1="buildroot_ctng":;
CTNG_FIX_DOT_CONFIG_SED += s:^(CT_TARGET_ALIAS)=.*:\1="$(REAL_GNU_TARGET_NAME)":;
CTNG_FIX_DOT_CONFIG_SED += s:^(CT_CC_PKGVERSION)="(.*)":\1="crosstool-NG $(CTNG_VERSION) - buildroot $(BR2_VERSION_FULL)":;
ifneq ($(call qstrip,$(BR2_PACKAGE_GDB_SERVER))$(call qstrip,$(BR2_PACKAGE_GDB_HOST)),)
CTNG_FIX_DOT_CONFIG_SED += s:^(CT_DEBUG_gdb)=.*:\# \1 is not set:;
endif
ifneq ($(call qstrip,$(BR2_INSTALL_LIBSTDCPP)),)
CTNG_FIX_DOT_CONFIG_SED += s:^\# (CT_CC_LANG_CXX) is not set:\1=y:;
else
CTNG_FIX_DOT_CONFIG_SED += s:^(CT_CC_LANG_CXX)=.*:\# \1 is not set:;
endif

#--------------
# And the specials for paths
CTNG_FIX_DOT_CONFIG_PATHS_SED :=
CTNG_FIX_DOT_CONFIG_PATHS_SED += s:^(CT_PREFIX_DIR)=.*:\1="$(TOOLCHAIN_DIR)":;
CTNG_FIX_DOT_CONFIG_PATHS_SED += s:^(CT_LOCAL_TARBALLS_DIR)=.*:\1="$(DL_DIR)":;
CTNG_FIX_DOT_CONFIG_PATHS_SED += s:^(CT_SYSROOT_DIR_PREFIX)=.*:\1="":;
ifeq ($(BR2_TOOLCHAIN_CTNG_uClibc),y)
CTNG_FIX_DOT_CONFIG_PATHS_SED += s:^(CT_LIBC_UCLIBC_CONFIG_FILE)=.*:\1="$(CTNG_UCLIBC_CONFIG_FILE)":;
endif

#--------------
# Small functions to shoe-horn the above into crosstool-NG's .config
# $1: the .config file to munge
# $2: the sed expression to apply
define ctng-fix-dot-config
	$(Q)sed -r -e '$(2)' $(1) >$(1).sed
	$(Q)cmp $(1) $(1).sed >/dev/null 2>&1 && rm -f $(1).sed || mv -f $(1).sed $(1)
endef

# Function to update the .config
# We first munge the .config to shoe-horn defaults, then we push that unto
# crosstool-NG's oldconfig process, to sort out wizy-wazy deps, and then we
# shoe-horn paths again, as they get ripped-out by oldconfig (is that a bug
# or a feature of kconfig?)
# $1: the .config file to munge
define ctng-oldconfig
	$(call ctng-fix-dot-config,$(1),$(CTNG_FIX_DOT_CONFIG_SED))
	$(Q)yes ''                                             |\
	$(call ctng,CT_IS_A_BACKEND=y                           \
	            CT_BACKEND_ARCH=$(CTNG_ARCH)                \
	            CT_BACKEND_KERNEL=linux                     \
	            CT_BACKEND_LIBC=$(BR2_TOOLCHAIN_CTNG_LIBC)  \
	            oldconfig                                   )
	$(call ctng-fix-dot-config,$(1),$(CTNG_FIX_DOT_CONFIG_PATHS_SED))
endef

# This function checks the confguration of the toolchain did actually change
# If not changed, then current .config will be touched with reference to the
# stamp file. If the configuration did change, nothing is done.
# $1: the current .config to check
# $2: the time-stamped .config file
define ctng-check-config-changed
	$(Q)old_md5="$$( grep -v -E '^(#|$$)' $(2) 2>/dev/null  \
	                 |md5sum                                \
	                 |cut -d ' ' -f 1                       \
	               )";                                      \
	    new_md5="$$( grep -v -E '^(#|$$)' $(1) 2>/dev/null  \
	                 |md5sum                                \
	                 |cut -d ' ' -f 1                       \
	               )";                                      \
	    if [ $${old_md5} = $${new_md5} -a -f $(2) ]; then   \
	        touch -r $(2) $(1);                             \
	    fi
endef

# Default configuration
# Depends on top-level .config because it has options we have to shoe-horn
# into crosstool-NG's .config
# Only copy the original .config file if we don't have one already
$(CTNG_DIR)/.config: $(CTNG_CONFIG_FILE) $(CTNG_DIR)/ct-ng $(CONFIG_DIR)/.config
	$(Q)[ -f $@ ] && cp -a $@ $@.timestamp || cp -f $< $@
	$(call ctng-oldconfig,$@)
	$(call ctng-check-config-changed,$@,$@.timestamp)
	$(Q)rm -f $@.timestamp

# Manual configuration
ctng-menuconfig: $(CTNG_DIR)/.config
	$(Q)cp -a $< $<.timestamp
	$(Q)$(call ctng,CT_IS_A_BACKEND=y                           \
	                CT_BACKEND_ARCH=$(CTNG_ARCH)                \
	                CT_BACKEND_KERNEL=linux                     \
	                CT_BACKEND_LIBC=$(BR2_TOOLCHAIN_CTNG_LIBC)  \
	                menuconfig                                  )
	$(call ctng-oldconfig,$<)
	$(call ctng-check-config-changed,$<,$<.timestamp)
	$(Q)rm -f $<.timestamp

#-----------------------------------------------------------------------------
# Retrieving, configuring and building crosstool-NG (as a package)

$(DL_DIR)/$(CTNG_SOURCE):
	$(Q)$(call DOWNLOAD,$(CTNG_SITE),$(CTNG_SOURCE))

$(CTNG_DIR)/.unpacked: $(DL_DIR)/$(CTNG_SOURCE)
	$(Q)rm -rf $(CTNG_DIR)
	$(Q)mkdir -p $(BUILD_DIR)
	$(Q)$(CTNG_CAT) $(DL_DIR)/$(CTNG_SOURCE) |tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(Q)touch $@

$(CTNG_DIR)/.patched: $(CTNG_DIR)/.unpacked
	$(Q)toolchain/patch-kernel.sh $(CTNG_DIR)       \
	                              $(CTNG_PATCH_DIR) \
	                              \*.patch          \
	                              \*.patch.$(ARCH)
	$(Q)touch $@

$(CTNG_DIR)/.configured: $(CTNG_DIR)/.patched
	$(Q)cd $(CTNG_DIR) && ./configure --local
	$(Q)touch $@

$(CTNG_DIR)/ct-ng: $(CTNG_DIR)/.configured
	$(Q)$(MAKE) -C $(CTNG_DIR) --no-print-directory
	$(Q)touch $@
