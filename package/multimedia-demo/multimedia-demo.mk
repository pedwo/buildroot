#############################################################
#
# ren_mm_demo
# Installs Qt app, scripts and encoder control files to /root
# Installs sample media to /sample_media
#
#############################################################
REN_MM_DEMO_VERSION:=0.1.0
REN_MM_DEMO_SOURCE:=renesas-qt-demo-$(REN_MM_DEMO_VERSION).tar.gz
REN_MM_DEMO_SITE:=https://github.com/downloads/pedwo/Multimedia-Demo-UI

REN_MM_DEMO_DEPENDENCIES = qt

REN_MM_DEMO_LOC:=$(TARGET_DIR)/root

define REN_MM_DEMO_CONFIGURE_CMDS
	(cd $(@D); $(QT_QMAKE) menu.pro; $(QT_QMAKE))
endef

define REN_MM_DEMO_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define REN_MM_DEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/menu $(REN_MM_DEMO_LOC)/menu
	$(INSTALL) -D $(@D)/*.sh $(REN_MM_DEMO_LOC)
	cp -rf $(@D)/ctl $(REN_MM_DEMO_LOC)
endef

define REN_MM_DEMO_CLEAN_CMDS
	rm -f $(REN_MM_DEMO_LOC)/menu
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call AUTOTARGETS,package,ren_mm_demo))
