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

# get the uuid for the root device
uuid := $(shell grep UUID /etc/fstab | cut -f 1)

all: install-boot edp-overlay

# apply an overlay such that will be applied on subsequent boots.
edp-overlay:
	armbian-add-overlay edp.dts

# byte compile boot.cmd to boot.scr
boot-scr: boot.cmd
	mkimage -A arm -T script -O linux -d boot.cmd boot.scr

show-uuid:
	@echo 'root device:' $(uuid)

# fixup armbianEnv.txt with the proper device uuid.
set-rootdev-UUID: show-uuid
	@sed 's/UUID=.*/$(uuid)/' armbianEnvOrig.txt > armbianEnv.txt
	@echo 'armbianEnv:' 
	@echo '-------------------------' 
	@cat armbianEnv.txt

# fix it, make it, and copy it all to boot.
install-boot: set-rootdev-UUID boot-scr
	cp armbianEnv.txt /boot/
	cp boot.cmd /boot/
	cp boot.scr /boot/


