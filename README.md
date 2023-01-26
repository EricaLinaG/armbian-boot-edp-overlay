### Armbian boot with edp device tree overlay. 

 Turn an armbian media iso into a full uboot so that dts overlays work.
 Then apply an eDP overlay to get the eDP touchscreen working.

 Makefile and files for the process of fixing an Armbian media install so
 that it can use dts overlays.

Note: 
 This is still not quite working. The eDP panel I have is the K116E from 
 FriendyElec the K116E is supported in 4.4 but not mainline. 
 Until there is that, this will result in a lit, but blank screen.
 

## files
  - boot.cmd       - This is the boot script we turn into boot.scr
  - armbianEnvOrig - This is a minimal version that we start with. 
  - armbianEnv     - This is the configuration data for boot.cmd.
  - edp.dts1,2     - These are the edp device tree overlays. Chronological.
  - edp.dts        - The current edp device tree overlay.


## The Steps applied here.

  - Put the root device UUID into armbianEnv.txt
    - make sure there are no spaces around '='.
  - Build boot.scr from boot.cmd with mkimage
    - this is shadowed by extlinux which must be moved.
  - Move /boot/extlinux to /boot/_extlinux
  - Copy all three to /boot/
  - Apply the edp.dts overlay
    - requires armbianEnv.txt and boot.cmd in /boot/.
    - this modifies /boot/armbianEnv.txt, 
  - Reboot.

## make commands

There are smaller make targets, but these should do it.

 - make all   -- does it all.
    - install-boot
    - edp-overlay

 - make install-boot  
   - make an armbianEnv.txt with the root device uuid.
   - use mkimage to create boot.scr from boot.cmd
   - copy armbianEnv.txt boot.cmd and boot.scr to /boot/
   - move extlinux out of the way

 - make edp-overlay
   - Add the edp.dts overlay to /boot/ with armbian-add-overlay.

 The overlay is the last step as it will not work until there is
 boot.cmd and armbianEnv.txt in /boot/.
 The last step is applying an overlay to enable the edp on a rk3399, nanopc-t4
 /boot/armbianEnv.txt will be modified by this step to add the overlay.

## Conclusion

This is fairly straightforward, but we have had some problems.
Most of this is to get dts overlays working for a _-media_ Armbian distribution
which does not support dts overlays. 
In my case this is Armbian 'Jammy' for a FriendlyElec nanopc-t4.

The second part is that the screen I have, the FriendlyElec K116E, a 1920x1084 
touchscreen is not supported in the mainline kernel. It is supported in 
the 4.4 kernel, so migration should be reasonable.  -- For someone who knows how.
