#
# Makefile for the process of fixing an Armbian media install so
# that it can use dts overlays.
#
# make all   -- does it all.
#
# make install-boot
#   - make an armbianEnv.txt with the rootdev uuid.
#   - use mkimage to create boot.scr from boot.cmd
#   - copy armbianEnv.txt boot.cmd and boot.scr to /boot/
#
# make edp-overlay
#   - Add the edp.dts overlay to /boot with armbian-add-overlay.
#
# The overlay is the last step as it will not work until there is
# boot.cmd and armbianEnv.txt in /boot/.
# The last step is applying an overlay to enable the edp on a rk3399, nanopc-t4
# /boot/armbianEnv.txt will be modified by this step to add the overlay.


# This is still not quite working. The eDP panel I have from FriendyElec the
# K116E is supported in 4.4 but not mainline. Until there is that,
# this will result in a lit, but blank screen.


# get the uuid for the root device mounted at /.
uuid := $(shell grep UUID /etc/fstab | sed 's/\t/ /g' | grep ' / ' | cut -f 1 -d ' ')

all: install edp-overlay

# move extlinux out of the way, keep it just in case
# if there are failures, boot from sdcard, move extlinux back, investigate.
.PHONY: extlinux-out
extlinux-out:
	mv /boot/extlinux /boot/_extlinux

# move it back.
.PHONY: extlinux-in
extlinux-in:
	mv /boot/_extlinux /boot/extlinux

# byte compile boot.cmd to boot.scr
.PHONY: boot-scr
boot-scr: boot.cmd extlinux-out
	mkimage -A arm -T script -O linux -d boot.cmd boot.scr

.PHONY: show-uuid
show-uuid:
	@echo 'root device:' $(uuid)

# fixup armbianEnv.txt with the proper device uuid.
.PHONY: set-rootdev-uuid
set-rootdev-uuid: show-uuid
	@sed 's/UUID=.*/$(uuid)/' armbianEnvOrig.txt > armbianEnv.txt
	@echo 'armbianEnv:'
	@echo '-------------------------'
	@cat armbianEnv.txt

# copy them to /boot/
.PHONY: install-boot
install-boot:
	cp armbianEnv.txt /boot/
	cp boot.cmd /boot/
	cp boot.scr /boot/

# fix it, make it, and copy it all to boot.
.PHONY: install
install: set-rootdev-uuid boot-scr install-boot

# apply an overlay such that will be applied on subsequent boots.
.PHONY: edp-overlay
edp-overlay:
	armbian-add-overlay edp.dts
