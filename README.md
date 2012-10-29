punk.fx
=======

A library for applying graphic effects in FlashPunk v1.6.

Still a *work-in-progress* but the core functionality is more or less in place.


Overview
--------

**TO DO**

**Note**: <code>TestWorld.as</code> is a complete mess but it's just what I'm using to test all the stuff. 

I know, I know... but I'm laaezy ;)


Dependencies and other useful resources
----------------------------------------

Dependencies for the **punk.fx** package (already included if you download/clone the whole repo, but you may want to 
grab the latest versions from the links below):

 * [FlashPunk 1.6](http://flashpunk.net/forums/index.php?topic=2831.0) from ChevyRay, Draknek & the rest of the FP community - for obvious reasons
 * [ColorMatrix](http://gskinner.com/blog/archives/2007/12/colormatrix_cla.html) from gskinner - for the AdjustFX effect
		
You may also want to take a look at these:

 * [Pixel Bender Toolkit](http://www.adobe.com/devnet/pixelbender.html) - for experimenting with shaders
 * [PBJ2ShaderFilter](http://xperiments.es/blog/en/pbj2shaderfilter-air-tool-to-generate-a-shaderfilter-class-from-pixel-bender-files/) - tool to generate ShaderFilter classes from pbj files
 * [TweenMax](https://www.greensock.com/tweenmax/) - awesome tweening library 
		
List of currently supported effects
-----------------------------------
		01 • AdjustFX			- color adjustment effect (contrast, hue, saturation, brightness)
		02 • BloomFX			- bloom effect
		03 • BlurFX				- blur effect
		04 • FadeFX				- fade effect (opaque/transparent)
		05 • FilterFX			- wrapper to use standard Flash filters (DropShadow, BlurFilter, etc.) and Pixel Bender ShaderFilters
		06 • GlowFX				- glow filter effect
		07 • PBCircleSplashFX	- Pixel Bender circle splash effect
		08 • PBHalfToneFX		- Pixel Bender halftone effect
		09 • PBPixelateFX		- Pixel Bender pixelate effect
		10 • PBShaderFilterFX	- wrapper to load and apply Pixel Bender effects at run-time
		11 • PBWaterFallFX		- Pixel Bender waterfall effect
		12 • PixelateFX			- pixelate effect
		13 • RetroCRTFX			- retro CRT monitor effect (with scanlines, noise and RGB channel displacement)


ChangeLog
---------
* ver 0.1.009
  - improved Pixel Bender base effect classes
  - a couple more effects: CircleSplash, WaterFall
  - fix for Pixel Bender sourceRect ?bug
  - docs, renaming and other revisions
  
* ver 0.1
  - mem optimizations
  - Pixel Bender support
  - added more effects (totalling 10+1)
  - improved ASDoc documentation
  - renamed a few things to keep naming style consistent

* ver 0.0 (I _really_ liked the ascii emoticon ;)
  - initial release with a bunch of effects and bad performance
  
Copyrights & Credits
-------------------

*TO INTEGRATE*

Oooh... and thanks to ChevyRay, Draknek, ChrisKelly (that firestarted me) and all the awesome FlashPunk community, Grant Skinner, GreenSock, 
the FlashDevelop team, my girlfriend, Adobe, the PB filter coders, and the ones that I'm (_surely_) forgetting to mention that helped me feed 
this **embryo** (*quite probably inadvertently*).

<small>**azrafe7**</small> <small><code>(azrafe7[at]gmail[dot]com)</code></small>