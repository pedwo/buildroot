#!/bin/bash
#
echo "Renesas MS7724 development board: Post-build script"

INSTALL=`which install`
if [ -z "$INSTALL" ]; then
	INSTALL=`type -p install`
fi

ETC_DIR="output/target/etc"
SRC_DIR="target/device/Renesas/MS7724"


echo "  --> Add ttySC0-5"
$INSTALL -m 0755 $SRC_DIR/securetty $ETC_DIR

echo "  --> Create mdev script"
$INSTALL -m 0755 $SRC_DIR/S10mdev $ETC_DIR/init.d

echo "  --> Relocate sound devices for ALSA & handle USB/SD automount"
$INSTALL -m 0755 $SRC_DIR/mdev.conf $ETC_DIR

echo "  --> Create automount scripts"
$INSTALL -m 0755 $SRC_DIR/automount $ETC_DIR
pushd $ETC_DIR
ln -sf automount automount-add
ln -sf automount automount-remove
popd

echo "  --> Copy u-boot image to target"
cp -f output/build/u-boot-*/u-boot.bin output/target/boot


