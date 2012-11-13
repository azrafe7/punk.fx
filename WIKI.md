**punk.fx** is a `[WIP]` library that tries to make it easy to apply effects to graphics in FlashPunk 1.6.


<a id="dependencies"></a>Dependencies
-------------------------------------

Its only dependencies are [FlashPunk](http://flashpunk.net/forums/index.php?topic=2831.0) and [ColorMatrix](http://gskinner.com/blog/archives/2007/12/colormatrix_cla.html) (the other packages present in the repo are only needed to compile the demo).

You can download them from the official sites or use the copies in the repo (respectively in `src/net/flashpunk` and `src/com/gskinner`).


<a id="overview"></a>Brief Overview
-----------------------------

The core of the package is [`FXImage`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html), a class that extends FlashPunk's `Image` and that exposes functionalities to apply effects to the underlying graphics (plus other useful functions).

<small>NB: You'll obviously need to add the FXImage to an Entity and add the latter to the World to make it render to screen (same process you's use with a normal FlashPunk Image).</small>

A bunch of effects are supported (here's the [full list](#effects "list of supported effects")), and the user can easily apply them to multiple images, the whole screen, or to `BitmapData` objects (with the possibility to pass a `Rectangle` representing the region of the object that will be affected by the tranforms).

Here's a link to the whole [documentation](http://azrafe7.github.com/punk.fx/docs "punk.fx docs") of the punk.fx classes.

###<a id="index"></a>Index
  - [Dependencies](#dependencies)
  - [Brief Overview](#overview)
  - [Getting Started](#gettingStarted)
    - [Simple Usage](#simpleUsage)
    - [Using Standard Flash Filters](#flashFilters)
    - [Changing Multiple Properties](#multipleProps)
    - [Applying Multiple Effects](#multipleEffects)
  - [Supported Effects](#effects)
  - [FAQ](#faq)

###<a id="gettingStarted"></a>Getting Started

Once you've downloaded the punk.fx package and the needed [dependencies](#dependencies) you're ready to get started and to 
experiment with it. The examples below will show you how to achieve some simple tasks and how to effectively ( _no pun intended_ ) use the library.


####<a id="simpleUsage"></a>Simple Usage
All you have to do to use the effects is:

  1. create a new [`FXImage`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html) instance
  2. instantiate one (or more) of the supported effects
  3. apply the instantiated effects to the FXImage object

In code, the process is not unlike the way you apply standard Flash filters to `DisplayObjects`. 

Let's assume you have an embedded `Bitmap` named `TURRET`. Then you can use the following snippet:

        var fxImage:FXImage = new FXImage(TURRET);
        var fx:AdjustFX = new AdjustFX();
        fxImage.effects.add(fx);

At this point you can modify the effect's parameters and they will be automatically reflected to the image graphics.


####<a id="flashFilters"></a>Using Standard Flash Filters

You can add standard Flash filters and PixelBender filters to the effect list of an FXImage and they will be handled right away by the library (they are internally wrapped in proper classes).

It's as simple as this:

       var shadowFilter:DropShadowFilter = new DropShadowFilter(10);
       fxImage.effects.add(shadowFilter);
       shadowFilter.alpha = .6;


####<a id="multipleProps"></a>Changing Multiple Properties

You can modify more than one property of an effect (instance/subclass of [`FX`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html)) at once by using the convenient [`setProps`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#setProps(\)) method.

       var commonProps:* = {blur: 10, quality:2};
       var fx:FX = new BloomFX();
       var glowFX:GlowFX = new GlowFX(10);
       fx.setProps({threshold: 125}).setProps(commonProps);
       glowFX.setProps(commonProps);


####<a id="multipleEffects"></a>Applying Multiple Effects

Multiple effects can be applied to the same FXImage, thus resulting in a combination of them.

The [`effects`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#effects) property (which is of type [`FXList`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html)) in each FXImage makes it easy to do so by exposing some useful methods like [`add`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#add(\)) and [`insert`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#insert(\)).

       fxImage.add([FadeFX, new DropShadowFilter(10)]);
       var adjustFX:AdjustFX = new AdjustFX();
       fxImage.insert(adjustFX, 1);


<a id="effects"></a>Supported Effects
-------------------------------------

		01 • AdjustFX           - color adjustment effect (contrast, hue, saturation, brightness)
		02 • BloomFX            - bloom effect
		03 • BlurFX             - blur filter effect
		04 • FadeFX             - fade effect (opaque/transparent)
		05 • FilterFX           - wrapper to use standard Flash filters (DropShadow, BlurFilter, etc.) and Pixel Bender ShaderFilters
		06 • GlitchFX           - glitch effect (random linear disturb)
		07 • GlowFX             - glow filter effect
		08 • PixelateFX         - pixelate effect
		09 • RGBDisplacementFX  - RGB channels displacement
		10 • ScanLinesFX        - Scanlines and noise effect
		11 • PBCircleSplashFX   - Pixel Bender circle splash effect
		12 • PBDot              - Pixel Bender dot effect
		13 • PBHalfToneFX       - Pixel Bender halftone effect
		14 • PBLineSlideFX      - Pixel Bender lineslide effect
		15 • PBPixelateFX       - Pixel Bender pixelate effect
		16 • PBShaderFilterFX   - wrapper to load and apply Pixel Bender effects at run-time
		17 • PBWaterFallFX      - Pixel Bender waterfall effect


<a id="faq"></a>FAQ
-------------------

<small>TA-DAH TO-DOOH</small>