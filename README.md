# Armbian boot with edp device tree overlay. 

 Turn an armbian media iso into a full uboot so that dts overlays work.
 Then apply an eDP overlay to get the eDP touchscreen working.

 Makefile and files for the process of fixing an Armbian media install so
 that it can use dts overlays.

Note: 
 This is still not quite working. The eDP panel I have is the K116E from 
 Friendy Elec the K116E is supported in 4.4 Friendly Elec Lubuntu, 
 but not 5.x and 6.x. 

 Until there is more overlay to address that, this will result in a lit, 
 but blank screen.
 
 The first two dts files edp.dts1, and 2, work for an edp panel
 which matches this one, which is part of mainline. 

 _LG or lp079qx1-sp0v is a 7.9" display at 2048x1536 which is used 
 in the ipad mini.

 This works for others but I do not have that panel.


# The process 

## Files

  - __boot.cmd__       - This is the boot script we turn into boot.scr
  - __armbianEnvOrig__ - This is a minimal version that we start with. 
  - __armbianEnv__     - This is the configuration data for boot.cmd.
  - __edp.dts1,2__     - These are the edp device tree overlays. Chronological.
  - __edp.dts__        - The current edp device tree overlay.


## The Steps applied here.

  - Put the root device UUID into _armbianEnv.txt_
    - Make sure there are no spaces around '='.
  - Build _boot.scr_ from boot.cmd with __mkimage__
    - This is shadowed by extlinux which must be moved.
  - Move __/boot/extlinux__ to __/boot/_extlinux__
  - Copy all three files to _/boot/_
  - Apply the _edp.dts_ overlay
    - Requires __armbianEnv.txt__ and __boot.cmd__ in _/boot/_.
    - Modifies _/boot/armbianEnv.txt_, 
  - Reboot when ready.

## Make commands

 The overlay is the last step as it will not work until there is
 _boot.cmd_ and _armbianEnv.txt_ in _/boot/_.
 The last step is applying an overlay to enable the edp on a rk3399, nanopc-t4
 _/boot/armbianEnv.txt_ will be modified by this step to add the overlay.

There are smaller make targets, but these should do it.

 - __make all__   -- does it all.
    - install-boot
    - edp-overlay

 - __make install-boot__
    - Make an _armbianEnv.txt_ with the root device uuid.
    - Use mkimage to create boot.scr from boot.cmd
    - Copy _armbianEnv.txt_, _boot.cmd_ and _boot.scr_ to _/boot/_
    - Move _extlinux_ out of the way

 - __make edp-overlay__
    - Add the _edp.dts_ overlay to _/boot/_ with __armbian-add-overlay__.
   
### these are more granular and the others make them for you.

 - __make set-rootdev-UUID__
    - Create an _armbianEnv.txt_ with the root device UUID
   
 - __make show-UUID__
    - show the root device's UUID

 - __make boot-scr__
    - Use mkimage to create _boot.scr_ from _boot.cmd_

- __make extlinux-*<out/in>*__
    - Move _/boot/extlinux_ out of the way, or back in place

 Read the Makefile for more.

## Conclusion

This is fairly straightforward, but we have had some problems. And I am just 
learning a lot of this and trying to follow the instructions I'm being given.
For which I am very thankful.

I've made a few mistakes along the way. This seems
like a good way to document this and help it be repeatable.

Most of this is to get dts overlays working for a _-media_ Armbian distribution
which does not support dts overlays. 
In my case this is Armbian 'Jammy' for a FriendlyElec nanopc-t4.

The second part is that the screen I have, the FriendlyElec K116E, an 11.6", 1920x1084 
touchscreen is not supported in the mainline kernel. It is supported in 
the 4.4 kernel, so migration should be reasonable.  -- For someone who knows how.
