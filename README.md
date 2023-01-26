# Armbian boot with edp device tree overlay. 

 Turn an armbian media iso into a full uboot so that dts overlays work.
 Then apply an eDP overlay to get the eDP touchscreen working.

## A Makefile and some files.

 This is really a __Makefile__ with a some rules and dependencies to 
 document and automate the steps that I have done to my nanopc-t4.

 You can read about it here, but the guts are in the __Makefile__.

 If you dont want to read, and you know what you want you can
 just pull the trigger and __make all__. If you like to go slow, 
 read this, read the __Makefile__,
 look at your _/boot/_.  Maybe do one __make__ rule at a time so
 you can watch every step.
 

Note: 
 This is still not quite working. The eDP panel I have is the K116E from 
 Friendy Elec the K116E is supported in 4.4 Friendly Elec Lubuntu, 
 but not 5.x and 6.x. 

 Until there is more overlay to address that, this will result in a lit, 
 but blank screen.
 
 The first two dts files edp.dts1, and 2, work for an edp panel
 which matches this one, which is part of mainline. 

 __LG or lp079qx1-sp0v__ is a __7.9"__ display at __2048x1536__ which is used 
 in the ipad mini.

 This works for others but I do not have that panel.


# The process 

Basically, create __armbianEnv.txt__ and __boot.scr__ then put them and __boot.cmd__ 
in _/boot/_.
Move /boot/extlinux out of the way. Then apply a device tree overlay.

## Files

  - __boot.cmd__       - This is the boot script we turn into boot.scr.
  - __armbianEnvOrig__ - This is a minimal version that we start with. 
  - __armbianEnv__     - This is the configuration data for boot.cmd.
  - __edp.dts1,2__     - These are the edp device tree overlays. Chronological.
  - __edp.dts__        - The current edp device tree overlay.


## The Steps applied here.

  - Put the root device UUID into _armbianEnv.txt_
    - Make sure there are no spaces around '='.
  - Build _boot.scr_ from boot.cmd with __mkimage__
    - This is shadowed by extlinux which must be moved.
  - Move __/boot/extlinux__ to **/boot/_extlinux**.
  - Copy all three files to _/boot/_.
  - Apply the _edp.dts_ overlay.
    - Requires that __armbianEnv.txt__ and __boot.cmd__ are in _/boot/_.
    - Modifies _/boot/armbianEnv.txt_, 
  - Reboot when ready.

## Make commands

 The overlay is the last step as it will not work until there is
 _boot.cmd_ and _armbianEnv.txt_ in _/boot/_.
 The last step is applying an overlay to enable the edp on a rk3399, nanopc-t4
 _/boot/armbianEnv.txt_ will be modified by this step to add the overlay.

There are smaller make targets, but these should do it.

 - __make all__   -- does it all.
    - __install__     :  Set up _/boot/_ for dts overlays.
    - __edp-overlay__ :  Apply the overlay for subsequent boots.

 - __make install__   -- Just the _/boot/_ setup.
    - __show-uuid__:        Show the root device UUID as detected.
    - __set-rootdev-uuid__: Make an _armbianEnv.txt_ with the root device uuid.
    - __boot-scr__:         Use __mkimage__ to create _boot.scr_ from _boot.cmd_.
    - __install-boot__:     Copy _armbianEnv.txt_, _boot.cmd_ and _boot.scr_ to _/boot/_.
    - __extlinux-out__:     Move _extlinux_ out of the way.

 - __make edp-overlay__
    - Add the _edp.dts_ overlay to _/boot/_ with __armbian-add-overlay__.
   
 Read the Makefile for more.

## Conclusion

This is fairly straightforward, but we have had some problems, I think mostly
my mistakes. And I am just learning a lot of this and trying to follow the 
instructions I'm being given. For which I am very thankful.

I've made a few mistakes along the way. This seems
like a good way to document this and help it be repeatable.

Most of this is to get dts overlays working for a _-media_ Armbian distribution
which does not support dts overlays. 
In my case this is Armbian 'Jammy' for a FriendlyElec nanopc-t4.

The second part is that the screen I have, the FriendlyElec K116E, an 11.6", 1920x1084 
touchscreen is not supported in the mainline kernel. It is supported in 
the 4.4 kernel, so migration should be reasonable.  -- For someone who knows how.
