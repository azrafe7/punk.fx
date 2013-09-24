**WARNING**: Adobe has recently (july/august 2013) pulled hardware/JIT support from their Pixel Bender library, causing _extreme lag_ to all apps using it.
This means that using effects with the **PB** suffix (like PBWaterFallFX, PBLineSlideFX, etc.) with **punk.fx** will dramatically reduce your FPS (**the other effects will still play nice!**).
You can avoid this drop in performance by ensuring the use of a Flash Player with a version below 11.7.

If you'd like to share your thoughts about Adobe's choice to severely degrade the performance of a crucial library without any advance warning, here's the bug report on Adobe's website: [https://bugbase.adobe.com/index.cfm?event=bug&id=3591185](https://bugbase.adobe.com/index.cfm?event=bug&id=3591185).

punk.fx
=======

A library for applying graphic effects in FlashPunk v1.6.


Overview & Usage
----------------

With **punk.fx** you can easily apply graphic effects to most of FlashPunk's graphic classes (by using the proper _FX-Graphic_ classes that extend the FP ones) or to whole entities (via FXLayer). 
The library provides a collection of built-in effects (Pixelate, Glow, Fade, etc.), and makes it possible to use the standard Flash filters (DropShadow, Blur, etc.) along with Pixel Bender filters, all just by writing a few lines of code.

You can consult the [wiki](https://github.com/azrafe7/punk.fx/wiki) to get started with **punk.fx** or read the 
full package [documentation](http://azrafe7.github.com/punk.fx/docs) to better understand the library's internal classes and methods.
You can also take a look at this [demo](http://dl.dropbox.com/u/32864004/dev/FPDemo/PunkFX%20latest%20demo.swf) to 
get an idea of what this all is about. 

For a real world example of what you can do with a wise use of this library you can check out [Separation Anxiety](http://tasteofmoonlight.com/games/separation-anxiety), a game by Jonathan Stoler, and this [blog post](http://tasteofmoonlight.com/blog/posts/all-glitched-out) where he explains how he managed to put it together. 


Dependencies & Other Useful Resources
---------------------------------------

Dependencies for the **punk.fx** package (already included if you download/clone the whole repo, but you may want to 
grab the latest versions from the links below):

 * [FlashPunk 1.6](http://flashpunk.net/forums/index.php?topic=2831.0) by ChevyRay, Draknek & the rest of the FP community - for obvious reasons
 * [ColorMatrix](http://gskinner.com/blog/archives/2007/12/colormatrix_cla.html) by gskinner - for the AdjustFX effect
	
You may also want to take a look at these (not needed to use the lib, but you may find them useful):

 * [Pixel Bender Toolkit](http://www.adobe.com/devnet/pixelbender.html) - for experimenting with shaders
 * [PBJ2ShaderFilter](http://xperiments.es/blog/en/pbj2shaderfilter-air-tool-to-generate-a-shaderfilter-class-from-pixel-bender-files/) - tool to generate ShaderFilter classes from pbj files
 * [TweenMax](https://www.greensock.com/tweenmax/) by Jack Doyle & Co. - awesome tweening library
 * [Pixel Bender Exchange](http://www.adobe.com/cfusion/exchange/index.cfm?s=5&from=1&o=desc&cat=-1&l=-1&event=productHome&exc=26) - a collection of free PB effects
 * [MinimalComps](http://www.minimalcomps.com/) by Keith Peters - Minimal ActionScript 3.0 UI Components for Flash
 
List of Currently Supported Effects
-----------------------------------

		01 • AdjustFX           - color adjustment effect (contrast, hue, saturation, brightness)
		02 • BloomFX            - bloom effect
		03 • BlurFX             - blur filter effect
		04 • ColorTransformFX   - wrapper for ColorTransform
		05 • FadeFX             - fade effect (opaque/transparent)
		06 • FilterFX           - wrapper to use standard Flash filters (DropShadow, BlurFilter, etc.) and Pixel Bender ShaderFilters
		07 • GlitchFX           - glitch effect (random linear disturb)
		08 • GlowFX             - glow filter effect
		09 • PixelateFX         - pixelate effect
		10 • RGBDisplacementFX  - RGB channels displacement
		11 • ScanLinesFX        - Scanlines and noise effect
		12 • PBCircleSplashFX   - Pixel Bender circle splash effect
		13 • PBDot              - Pixel Bender dot effect
		14 • PBHalfToneFX       - Pixel Bender halftone effect
		15 • PBLightPointFX     - Pixel Bender light point effect
		16 • PBLineSlideFX      - Pixel Bender lineslide effect
		17 • PBPixelateFX       - Pixel Bender pixelate effect
		18 • PBShaderFilterFX   - wrapper to load and apply Pixel Bender effects at run-time
		19 • PBWaterFallFX      - Pixel Bender waterfall effect
		20 • PBZoomBlurFX       - Pixel Bender zoom blur effect


ChangeLog
---------

* **ver 0.3.007**:
  - PBPixelateFX with pivot (pixelates from center by default)
  - added slideFunction to GlitchFX (and a sineWave() example of how to use it)
  - fixed scanLinesOffset: now updates properly
* **ver 0.3.001**:
  - powerful FXLayer added, for applying effects to entities
  - TList: lists reorganized into new package
  - ColorTransformFX
  - added particles to demo to show FXLayer capabilities
  - minor fixes
* **ver 0.2.029**:
  - PBLightPointFX and PBZoomBlurFX added
  - useDrawMask property added to a couple of effects
  - minor fixes
* **ver 0.2.023**:
  - autoUpdate property
  - all FP graphics classes that extend Image are now supported
  - preprocessing via FMPP with Ant to generate FXGraphics classes from template
  - introduced IFXGraphic interface
  - FXMan uses IFXGraphic under the hood
  - struggled with ASDoc... but finally won ;)
  - restructured bits here and there
* **ver 0.2.001**:
  - FXMan decoupled from FXImage (it's not mandatory anymore to use it, but it can be useful to do so)
  - more effects: PBDot, PBLineSlide, Glitch
  - RetroCRT split into 2: ScanLines & RGBDisplacement effects
  - FXImage.applyMask()
  - restructured MinimalComps/TweenMax/FX binding code
  - minor fixes/improvements
* **ver 0.1.015**:
  - added MinimimalComps to playtest the effects
  - minor improvements
* **ver 0.1.009**:
  - improved Pixel Bender base effect classes
  - a couple more effects: CircleSplash, WaterFall
  - fix for Pixel Bender applyFilter() sourceRect ?bug
  - docs, renaming and other revisions
* **ver 0.1**:
  - mem optimizations
  - Pixel Bender support
  - added more effects (totalling 10+1)
  - improved ASDoc documentation
  - renamed a few things to keep naming style consistent
* **ver 0.0** (I really liked the _relevant_ ascii emoticon ;)
  - initial release with a bunch of effects and bad performance

  
License (MIT) & Credits
--------------------

<pre>Permission is hereby granted, free of charge, to any person obtaining 
a copy of this software and associated documentation files (the 
"Software"), to deal in the Software without restriction, including 
without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to 
the following conditions: 

The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

Copyright (c) 2012 Giuseppe Di Mauro (aka azrafe7) 
		
</pre>		
Special thanks to ChevyRay, Draknek, ChrisKelly (that [firestarted](http://flashpunk.net/forums/index.php?topic=3544.0) me) and all the awesome FlashPunk community, 
Grant Skinner, GreenSock, the PB filters' coders, and the ones that I'm ( _surely_ ) forgetting to mention that helped me 
feed this little creature ( _quite probably unwittingly_ ).

<small><b>azrafe7</b></small> <small><code>(azrafe7[at]gmail[dot]com)</code></small>
