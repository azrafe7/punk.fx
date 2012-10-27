punk.fx
=======

A library for applying graphic effects in FlashPunk v1.6.

Still a *work in progress* but the core functionality is there.


Overview
--------

**TO DO**

_Note_: TestWorld.as is a complete mess but it's just what I'm using to test all the stuff. 

I know, I know... but I'm lazy ;)


List of currently supported effects
-----------------------------------
		AdjustEffect			- color adjustment effect (contrast, hue, saturation, brightness)
		BloomEffect				- bloom effect
		BlurEffect				- blur effect
		FadeEffect				- fade effect (opaque/transparent)
		FilterEffect			- wrapper to use standard Flash filters (DropShadow, BlurFilter, etc.)
		GlowEffect				- glow filter effect
		PBHalfToneEffect		- Pixel Bender halftone effect
		PBPixelateEffect		- Pixel Bender pixelate effect
		PixelateEffect			- pixelate effect
		PixelBenderEffect		- wrapper to load and apply Pixel Bender effect at run-time
		RetroCRTEffect			- retro CRT monitor effect (with scanlines, noise and RGB channel displacement)


ChangeLog
---------

* ver 0.1
  - mem optimizations
  - Pixel Bender support
  - added more effects
  - improved ASDoc documentation
  - renamed a few things to keep naming style consistent
