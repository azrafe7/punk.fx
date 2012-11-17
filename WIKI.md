You can consult the [wiki](https://github.com/azrafe7/punk.fx/wiki) (also copied below) to get started with punk.fx or read the 
full package [documentation](http://azrafe7.github.com/punk.fx/docs) to better understand the library's internal classes and methods.
You can also take a look at this messy [demo](http://dl.dropbox.com/u/32864004/dev/FPDemo/FX%20Project%20PlayTest.swf) to 
get an idea of what this all is about. 

_______________________________________________________________________________________________________

## WIKI

**punk.fx** is a `[WIP]` library that tries to make it easy to apply effects to graphics in FlashPunk 1.6.


<a id="dependencies"></a>

Dependencies
------------

Its only dependencies are [FlashPunk](http://flashpunk.net/forums/index.php?topic=2831.0) and [ColorMatrix](http://gskinner.com/blog/archives/2007/12/colormatrix_cla.html) (the other packages present in the repo are only needed to compile the demo).

You can download them from the official sites or use the copies in the repo (respectively in `src/net/flashpunk` and `src/com/gskinner`).


<a id="overview"></a>

Brief Overview
--------------

The core of the package is [`FXImage`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html), a class that extends FlashPunk's `Image` and that exposes functionalities to apply effects to the underlying graphics (plus other useful functions).

<small>NB: You'll obviously need to add the FXImage to an Entity and add the latter to the World to make it render to screen (same process you'd use with a normal FlashPunk Image).</small>

A bunch of effects are supported (here's the [full list](#effects "list of supported effects")), and the user can easily apply them to multiple images, the whole screen, or to `BitmapData` objects (with the possibility to pass a `Rectangle` representing the region of the object that will be affected by the tranforms).

Here's a link to the whole [documentation](http://azrafe7.github.com/punk.fx/docs "punk.fx docs") of the punk.fx classes.


<a id="index"></a>

### Index

  - [Dependencies](#dependencies)
  - [Brief Overview](#overview)
  - [Getting Started](#gettingStarted)
    - [Simple Usage](#simpleUsage)
    - [Using Standard Flash Filters](#flashFilters)
    - [Changing Multiple Properties](#multipleProps)
    - [Applying Multiple Effects](#multipleEffects)
    - [Applying Effects to Multiple Targets](#shareEffects)
    - [Applying Effects to the Whole Screen](#screenEffects)
  - [Currently Supported Effects](#effects)
  - [In-Depth View](#inDepth)
    - [FXImage](#FXImage)
    - [FXList](#FXList)
    - [FXMan](#FXMan)
    - [FX](#FX)
  - [How Does It Work](#internals)
  - [FAQ](#faq)


<a id="gettingStarted"></a>

### Getting Started

Once you've downloaded the punk.fx package and the needed [dependencies](#dependencies) you're ready to get started and to 
experiment with it. The examples below will show you how to achieve some simple tasks and how to _effect_-ively ( _pun intended_ ) use the library.


<a id="simpleUsage"></a>

#### Simple Usage

All you have to do to use the effects is:

  1. create a new [`FXImage`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html) instance
  2. instantiate one (or more) of the supported effects
  3. add the instantiated effects to the FXImage object

In code, the process is very similar to the way you apply standard Flash filters to `DisplayObjects`. 

Let's assume you have an embedded `Bitmap` named `TURRET`. Then you can use the following snippet:

        var fxImage:FXImage = new FXImage(TURRET);
        var fx:AdjustFX = new AdjustFX();
        fxImage.effects.add(fx);

At this point you can modify the effect's parameters and they will be automatically reflected to the image graphics.


<a id="flashFilters"></a>

#### Using Standard Flash Filters

You can add standard Flash filters and PixelBender filters to the effect list of an FXImage and they will be handled right away by the library (they are internally wrapped in proper classes).

It's as simple as this:

       var shadowFilter:DropShadowFilter = new DropShadowFilter(10);
       fxImage.effects.add(shadowFilter);
       shadowFilter.alpha = .6;


<a id="multipleProps"></a>

#### Changing Multiple Properties

You can modify more than one property of an effect (instance/subclass of [`FX`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html)) at once by using the convenient [`setProps()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#setProps(\)) method.

       var commonProps:* = {blur: 10, quality:2};
       var fx:FX = new BloomFX();
       var glowFX:GlowFX = new GlowFX(10);
       fx.setProps({threshold: 125}).setProps(commonProps);
       glowFX.setProps(commonProps);


<a id="multipleEffects"></a>

#### Applying Multiple Effects

Multiple effects can be applied to the same FXImage, thus resulting in a combination of them.

The [`effects`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#effects) property (which is of type [`FXList`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html)) in FXImage makes it easy to do so by exposing some useful methods like [`add()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#add(\)) and [`insert()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#insert(\)).

       fxImage.add([FadeFX, new DropShadowFilter(10)]);
       var adjustFX:AdjustFX = new AdjustFX();
       fxImage.insert(adjustFX, 1);


<a id="shareEffects"></a>

#### Applying Effects to Multiple Targets

The same list of effects can be applied to different FXImages. In this way, when you modify the parameters of a specific effect, all the FXImages that share that same effect will reflect the changes.

You can manually add the effects to separate FXImages in this way:

       var pixelateFX:PixelateFX = new PixelateFX();
       var fadeFX:FadeFX = new FadeFX(.5);
       fxImageOne.add([pixelateFX, fadeFX]);
       fxImageTwo.add([pixelateFX, fadeFX]);
       fxImageThree.add([pixelateFX, fadeFX]);
       pixelateFX.scale = 10;

Or use [`FXMan`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html) (more on it [later](#FXMan)) to do it with less code:

       var pixelateFX:PixelateFX = new PixelateFX();
       var fadeFX:FadeFX = new FadeFX(.5);
       FXMan.add([fxImageOne, fxImageTwo, fxImageThree], [pixelateFX, fadeFX]);
       pixelateFX.scale = 10;


<a id="screenEffects"></a>

#### Applying Effects to the Whole Screen

Applying effects to the whole screen can be achieved easily and in different ways, all of which resort to setting the FXImage source to `FP.buffer`, explicitly or implicitly.

* *Method 1* (pass `null` to the constructor, which is the default):

        var fxScreen:FXImage = new FXImage();
	    fxScreen.effects.add(new PixelateFX(5));

* *Method 2* (explicitly pass `FP.buffer` to the constructor):

        var fxScreen:FXImage = new FXImage(FP.buffer);
	    fxScreen.effects.add(new PixelateFX(5));

* *Method 3* (explicitly [set the source](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#setSource(\)) to `FP.buffer`):

		fxScreen.setSource(FP.buffer);
	    fxScreen.effects.add(new PixelateFX(5));

All of these methods are equivalent, with the latter requiring the variable fxScreen to be already instantiated.

It's worth noting that an FXImage representing the whole screen will trigger the update of the effects at the end of every frame, so it can be quite resource intensive (expecially in terms of CPU usage and rendering time).

Another thing to keep in mind is that the FXImage will actually be drawn on top of the screen buffer, so if you're applying a fade effect to it you will see the _real_ screen below show through. To prevent this you can simply clear the FP.buffer before rendering the FXImage.


<a id="effects"></a>

Currently Supported Effects
---------------------------

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


<a id="inDepth"></a>

In-Depth View
-------------

In the next sections a more in-depth view of the package classes will be shown, documenting their role in the framework and how to take advantage of their methods/properties.


<a id="FXImage"></a>

#### FXImage

Let's start with the main class, [`FXImage`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html).

As stated above, this class inherits from `net.flashpunk.graphics.Image`, and provides properties and methods to easily apply effects to the underlying BitmapData.

When you instantiate an FXImage an _incremental_ `id` will be automatically assigned to it.

##### Properties

  - [`effects`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#effects)
    
	Used to add or remove effects associated with the FXImage instance.

  - [`data`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#data)
    
	You can use this `Dictionary` to store custom data to associate with the instance.

    	fxImage.data["playerPos"] = { x: player.x, y: player.y };
		...
		trace(fxImage.data["playerPos"].x);

  - [`name`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#name)
    
	You can assign a name to the instance making it easy to identify a particular instance when debugging.

		fxImage.name = "playerImage";
		...
		trace(fxImage.toString());	// outputs "FXImage@playerImage"

  - [`buffer`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#buffer)
    
	Gets/sets the underlying BitmapData buffer (the one inherited from FlashPunk's Image).

  - [`syncWith`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#syncWith)

	By setting this property to a valid graphic object, the graphics of the current instance will be synced to that of the object at every frame (calls `cloneGraphicsFrom()` internally).

		fxImage.syncWith = player.spriteMap;
		// or...
		fxImage.syncWith = TURRET;
		// or...
		fxImage.syncWith = myBitmapData;

  - [`onPreRender`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#onPreRender)

	You can assign to this property a callback function that will be called just before the render step of the current instance. A reference to the current FXImage instance will be passed as first parameter to the function.

		function preProcess(img:FXImage):void {
			img.color = Math.random()*0xFFFFFF;
			// img.onPreRender = null;		// just run once => disable the callback
		}
		...
		fxImage.onPreRender = preProcess;


##### Methods

  - [`FXImage`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#FXImage(\))
    
	Constructor. Pass `null` as first parameter or `FP.buffer` to set the source to the whole screen. The second parameter is an optional clipping rectangle.

  - [`applyMask()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#applyMask(\))
    
	Used to apply a draw mask to the image (in some cases can be convenient to use this instead of the `drawMask` property, bypassing the execution of `updateBuffer()` and so avoiding _re_-applying the effects in the same frame).

		fxImage.drawMask = myMaskBitmapData;
		// ~ equivalent to
		fxImage.applyMask(myMaskBitmapData);

  - [`getSource()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#getSource(\))
    
	Returns the BitmapData used as source for the image.

  - [`setSource()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#setSource(\))
    
	Sets the BitmapData to use as source for the image. You can also pass an embedded Class holding a Bitmap, a Bitmap object or a BitmapData, and specify a clipping rectangle. 

		fxImage.setSource(FP.buffer);
		// or...
		fxImage.setSource(myBitmapData, new Rectangle(30, 30, 50, 100));
		// or...
		fxImage.setSource(TURRET);

  - [`cloneGraphicsFrom()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#cloneGraphicsFrom(\))
    
	Copies the graphics from the target object and sets it as the source for the current instance.

		fxImage.cloneGraphicsFrom(player.spriteMap);
		// or...
		fxImage.cloneGraphicsFrom(anotherFXImage);
		// or...
		fxImage.cloneGraphicsFrom(TURRET);

  - [`toString()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#toString(\))
    
	Returns a String representation of the instance (useful for debugging) in the format `<class name>@<id OR name>`.

		// if the name property is not set the id will be used
		trace(fxImage.toString());		// "FXImage@1"
		// with the name property set to "fooImage"
		trace(fxImage.toString());		// "FXImage@fooImage"

  - `static` [`getBitmapData()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#getBitmapData(\))
    
	Returns a BitmapData object from the passed object, which can be a Class holding a Bitmap, a Bitmap or a BitmapData object.


<a id="FXList"></a>

#### FXList

[`FXList`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html) is the class used by FXImage to hold the effects (see [`FXImage.effects`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXImage.html#effects)).

It provides methods to add, remove, and generally access the contained effects.

Most of the methods of FXList return the instance itself for chaining, making it possible to write code like this:

	var fxList:FXList = fxImage.effects;
	fxList.clear().add([BloomFX, new FadeFX(.6)]).insert(DropShadowFilter, 1);

##### Properties

  - [`length`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#length)
    
	Returns the number of effects contained in the FXList instance.

##### Methods

  - [`FXList()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#FXList(\))
    
	Constructor. You can pass a single FX or a Vector/Array of FXs to be added to the list.

  - [`add()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#add(\))
    
	Adds one or more effects to the list. You can pass a single FX or a Vector/Array of FXs to be added to the list.

  - [`insert()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#insert(\))
    
	Inserts one or more effects to the list. You can pass a single FX or a Vector/Array of FXs to be added to the list and optionally specify the index at which to insert them (index defaults to 0).

  - [`remove()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#remove(\))
    
	Removes one or more effects from the list. You can pass a single FX or a Vector/Array of FXs to be removed from the list.

  - [`removeAt()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#removeAt(\))
    
	Removes the effect at the specified index.

  - [`clear()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#clear(\))
    
	Removes all the effects from the list.

  - [`contains()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#contains(\))
    
	Checks if one or more FXs are in the FXList. Returns true only if _all_ of the effects passed in the first parameter are present in the list.

		var blurFX:BlurFX = new BlurFX();
		var bloomFX:BloomFX = new BloomFX();
		var glowFX:GlowFX = new GlowFX();
		var fxList:FXList = new FXList([blurFX, bloomFX]);
		trace(fxList.contains(blurFX));				// true
		trace(fxList.contains([bloomFX, glowFX]));	// false

  - [`at()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#at(\))
    
	Returns the effect at the specified index.

  - [`indexOf()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#indexOf(\))
    
	Returns the index of the specified effect or -1 if it's not present in the list.

		var blurFX:BlurFX = new BlurFX();
		var bloomFX:BloomFX = new BloomFX();
		var glowFX:GlowFX = new GlowFX();
		var fxList:FXList = new FXList([blurFX, bloomFX]);
		trace(fxList.indexOf(bloomFX));		// 1
		trace(fxList.indexOf(glowFX));		// -1

  - [`getAll()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#getAll(\))
    
	Returns the internal Vector of FXs containing all the FXs in the FXList (it's not a copy so _beware_).

		var fxVector:Vector.<FX> = fxImage.effects.getAll();
		fxVector[1].setProps(...);

  - [`forEach()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#forEach(\))
    
	Executes a callback function passing each FX in the FXList as the first parameter.

		function modifyFX(fx:FX):void {
			fx.setProps({color: 0xFF0000}, false});
		}
		...
		fxList.forEach = modifyFX;

  - [`toString()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXList.html#toString(\))
    
	Returns a String representation of the instance (useful for debugging) in the format `<class name>[ <list of effects> ]`.


<a id="FXMan"></a>

#### FXMan

[`FXMan`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html) is a _static_ class that lets you manage FXs and the FXImages and get track of them. You can use FXMan to apply effects to FXImages instead of doing it direcly.

It provides methods to add, remove, retrieve and generally access the contained FXImages and the associated FXs.

Note that its methods _may_ only work on FXImages/FXs that were previously added via FXMan (so it's advisable to not mix FXMan usage and direct manipulation via specific FXImage instances - _choose your way and stick with it!_).

##### Properties

  - `static` [`VERSION`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#VERSION)
    
	Returns the version of the punk.fx library as a String.

  - `static` [`BUILD_DATE`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#BUILD_DATE)
    
	Returns the build date of the punk.fx library as a String in the format `DD/MM/YYYY`.

##### Methods

  - ``static`` [`add()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#add(\))

	Adds FXs to one or multiple targets.

		FXMan.add(fxImage, BlurFX);
		FXMan.add([fxImageOne, fxImageFive], [new FadeFX(.5), BlurFX]);

  - `static` [`removeEffects()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#removeEffects(\))

	Removes FXs _instances_ from every target (FXImages) that is using them.

		FXMan.removeEffects(blurFX);
		FXMan.removeEffects([fadeFX, blurFX]);

  - `static` [`removeTargets()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#removetargets(\))

	Removes targets (FXImages) from the manager _and_ their associated effects. Pass `null` to remove all the FXImages from the manager.

		FXMan.removeTargets([fxImageOne, fxImageThree]);	// remove effects from the specified FXImages (and the FXImages too)
		FXMan.removeTargets();		// same as FXMan.clear()

  - `static` [`clear()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#clear(\))

	Removes all targets (FXImages) from the manager _and_ their associated effects.

  - `static` [`getEffectsOf()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#getEffectsOf(\))

	Returns the list of effects associated with the target (as an FXList).

		var fxList:FXList;
		fxList = FXMan.getEffectsOf(fxImage);
		// same as...
		fxList = fxImage.effects;

  - `static` [`getAllEffects()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#getAllEffects(\))

	Returns all the effects in the manager, stored in a `Vector.<FX>`.

  - `static` [`getAllTargets()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#getAllTargets(\))

	Returns all the targets (FXImages) in the manager, stored in a `Vector.<FXImage>`.

  - `static` [`getTargetsWith()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#getTargetsWith(\))

	Returns a Vector.<FXImage> of all the FXImages in the manager that are using _all_ the specified effects.

		FXMan.getTargetsWith([glowFX, blurFX]);

  - `static` [`toString()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FXMan.html#toString(\))
    
	Returns a String representation of the FXMan (useful for debugging).


<a id="FX"></a>

#### FX

[`FX`](http://azrafe7.github.com/punk.fx/docs/punk/fx/FX.html) is the base class for all the effects. You can extend this class to create custom effects.

When you instantiate an FX an _incremental_ `id` will be automatically  assigned to it.

##### Properties

  - [`active`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#active)
    
	If you set this to `false` then the FXImages associated with this effect will not apply it.

  - [`name`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#name)
    
	You can assign a name to the instance making it easy to identify a particular instance when debugging.

		fx.name = "thisEffect";
		...
		trace(fx.toString());	// outputs "<FX class>@thisEffect"

  - [`onPostProcess`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#onPostProcess(\))

	You can assign to this property a callback function that will be called just after the effect has been applied. The source BitmapData and its clipping rectangle will be passed as parameters.

		function postProcessFX(bmd:BitmapData, rect:Rectangle):void {
			bmd.threshold(bmd, rect, FP.zero, "<=", 127, 0x00000000, 0x00FFFFFF, true);
		}
		...
		fx.onPostProcess = postProcessFX;

##### Methods

  - [`setProps()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#setProps(\))

	You can modify more than one property of an FX at once by using this method. If you pass `true` (default) as the second parameter an error will be thrown if any of the specified properties doesn't exist.

        var fx:FX = new BloomFX();
        fx.setProps({threshold: 125, quality: 2});		// OK
        fx.setProps({threshold: 125, color: 0xFFFFFF});	// ERROR: because "color" property doesn't exist

  - [`applyTo()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#applyTo(\))

	Applies the effect to the clipRect region of bitmapData.

        var fx:FX = new BloomFX();
		var rect:Rectangle = new Rectangle(10, 10, 150, 20); 
        fx.applyTo(myBMD, rect);

  - [`toString()`](http://azrafe7.github.com/punk.fx/docs/punk/fx/effects/FX.html#toString(\))
    
	Returns a String representation of the FX instance (useful for debugging) in the format `<class name>@<id OR name>`.


<a id="internals"></a>

How Does It Work
----------------

<small>TO-DOOH TA-DAH</small>


<a id="faq"></a>

FAQ
---

<small>TA-DAH TO-DOOH</small>