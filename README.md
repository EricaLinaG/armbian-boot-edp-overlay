### Armbian boot with edp device tree overlay. 

 turn media iso into a full uboot so that dts overlays work.

 Makefile and files for the process of fixing an Armbian media install so
 that it can use dts overlays.

Note: This still doesnt work so I still dont know what Im doing.
      I think it must be close.

## files
  - boot.cmd  - this is the boot script we turn into boot.scr
  - armbianEnvOrig - this is a minimal version that we start with. 
  - armbianEnv - this is the configuration data for boot.cmd.
  - edp.dts1,2  - these are the edp device tree overlays. Chronological.
  - edp.dts  - the current edp device tree overlays.

## The Steps applied here.

  - Put the root device UUID into armbianEnv.txt
  - Build boot.scr from boot.cmd with mkimage
  - Copy all three to /boot/
  - Apply the edp.dts overlay
  - Reboot.

## make commands

 These enumerate the steps needed. The order is important.

 - make all   -- does it all.

 - make install-boot  
   - make an armbianEnv.txt with the rootdev uuid.
   - use mkimage to create boot.scr from boot.cmd
   - copy armbianEnv.txt boot.cmd and boot.scr to /boot/

 - make edp-overlay
   - Add the edp.dts overlay to /boot with armbian-add-overlay.


 The overlay is the last step as it will not work until there is
 boot.cmd and armbianEnv.txt in /boot/.
 The last step is applying an overlay to enable the edp on a rk3399, nanopc-t4
 /boot/armbianEnv.txt will be modified by this step to add the overlay.



