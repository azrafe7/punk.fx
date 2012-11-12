package  
{
	import com.bit101.components.Accordion;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Power3;
	import com.greensock.easing.SteppedEase;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import punk.fx.effects.AdjustFX;
	import punk.fx.effects.BloomFX;
	import punk.fx.effects.BlurFX;
	import punk.fx.effects.FadeFX;
	import punk.fx.effects.FilterFX;
	import punk.fx.effects.FX;
	import punk.fx.effects.GlitchFX;
	import punk.fx.effects.GlowFX;
	import punk.fx.effects.PBBaseFX;
	import punk.fx.effects.PBDotFX;
	import punk.fx.effects.PBHalfToneFX;
	import punk.fx.effects.PBCircleSplashFX;
	import punk.fx.effects.PBLineSlideFX;
	import punk.fx.effects.PBPixelateFX;
	import punk.fx.effects.PBShaderFilterFX;
	import punk.fx.effects.PBWaterFallFX;
	import punk.fx.effects.PixelateFX;
	import punk.fx.effects.RGBDisplacementFX;
	import punk.fx.effects.ScanLinesFX;
	import punk.fx.FXImage;
	import punk.fx.FXList;
	import punk.fx.FXMan;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author azrafe7
	 */
	public class TestWorld extends World 
	{
		
		AdjustFX;
		BloomFX;
		BlurFX;
		FadeFX;
		GlitchFX;
		GlowFX;
		PBCircleSplashFX;
		PBDotFX;
		PBHalfToneFX;
		PBLineSlideFX;
		PBPixelateFX;
		PBWaterFallFX;
		PixelateFX;
		RGBDisplacementFX;
		ScanLinesFX;
		
		private var xml:XML;
		private var effectsWin:Window;
		private var hideAccordion:Tween;
		private var maskBMD:BitmapData;
		private var maskImg:FXImage;
		private var circle:Object;
		private var blurFilter:BlurFilter;
		
		public var tweens:Vector.<TweenMax> = new Vector.<TweenMax>;
		
		public var components:Dictionary = new Dictionary(true); // key=<fx name>.<prop> value={comp:<component>, fx:<fx>, defValue:*}
		
		public var wholeScreenImage:FXImage;
		public var tween:TweenMax;
		public var swordguy:Spritemap;
		public var spriteFX:FXImage;
		public var maskPixelate:PixelateFX;
		public var clone:FXImage;
		public var shadowFilter:DropShadowFilter;
		public var filtersFX:FilterFX;
		public var bevelFilter:BevelFilter;


		public var pxbFX:PBShaderFilterFX;
		public var halfToneFX:PBHalfToneFX;
		public var benderFX:PBBaseFX;

		[Embed(source="effects.xml", mimeType="application/octet-stream")]
		public var EFFECTS_XML:Class;
		
		[Embed(source = "assets/longBackground.png")]
		public var BACKGROUND:Class;
		
		[Embed(source = "assets/flashpunk.png")]
		public var IMAGE:Class;
		
		[Embed(source = "assets/alien2.png")]
		public var ALIEN:Class;
		
		public var imageFX:FXImage;
		public var background:Backdrop;
		
		public var fadeFX:FadeFX;
		
		public var fx:FX;
		public var blurFX:FX;
		public var pixelateFX:FX;
		public var glowFX:FX;
		public var adjustFX:FX;
		public var retroCRTFX:FX;
		public var bloomFX:FX;
		
		public static var player:Player;
		
		public var fxList:FXList = new FXList;
		
		public function TestWorld() 
		{
			
		}
		
		override public function begin():void 
		{
			super.begin();
			
			background = new Backdrop(BACKGROUND, false, false);
			addGraphic(background);
			
			imageFX = new FXImage(null);
			imageFX.name = "imageFX";
			//imageFX.alpha = .4;
			addGraphic(imageFX, -4, 200, 100);
			
			circle = {r:0};
			TweenMax.to(circle, 1, {r:100, yoyo:true, repeat:-1, ease:Linear.ease});
			maskBMD = new BitmapData(imageFX.width, imageFX.height, true, 0xFF000000);
			maskImg = new FXImage(maskBMD);
			maskPixelate = new PixelateFX(6);
			
			maskImg.onPreRender = function(imgFX:FXImage):void {
				/*var g:Graphics = FP.sprite.graphics;
				var mtx:Matrix = FP.matrix;
				mtx.createGradientBox(circle.r * 2, circle.r * 2, 0, -circle.r + player.x-200, -circle.r +player.y-100);
				g.clear();
				g.beginGradientFill(GradientType.RADIAL, [0xFF000000, 0xFFFFFFFF], [0, 1], [200, 244], mtx);
				g.drawRect(0, 0, imgFX.width, imgFX.height);
				g.endFill();
				maskBMD.fillRect(maskBMD.rect, 0x0);
				maskBMD.draw(FP.sprite, null, null, BlendMode.NORMAL);
				maskImg.setSource(maskBMD, maskBMD.rect, false);*/
			}
				
			
			imageFX.centerOO();
			imageFX.x += imageFX.width>>1;
			imageFX.y += imageFX.height>>1;

			add(player = new Player(400, 240));
			player.layer = -2;
			

			swordguy = player.sprSwordguy;
			swordguy.centerOO();
			
			for (var i:int = 0; i < 12; i++) {
				//var imgFX:FXImage = FXImage.createCircle(40, 0xff0000);
				var imgFX:FXImage = new FXImage(ALIEN);
				imgFX.scale = 4;
				addGraphic(imgFX, -1, Math.random() * FP.width, Math.random() * FP.height);
				//imgFX.drawMask = imgFX.getSource();
				//FXMan.add(imgFX, [filtersFX/*pixelateFX, bloomFX/*retroCRTFX/*, fx, pixelateFX*/]);
			}
		
			
			trace(FXMan);
			
			xml = FP.getXML(EFFECTS_XML);
			
			//trace(typeof xml.effect[0])
			
			Style.setStyle(Style.LIGHT);
			
			effectsWin = new Window(FP.engine, 5, 25, "Effects Explorer - ver " + FXMan.VERSION);
			var effectsAccordion:Accordion = new Accordion(effectsWin, 0, 0);
			effectsAccordion.width = 190;
			effectsWin.alpha = .9;
			effectsWin.hasMinimizeButton = true;
			
			//effectsWin.minimized = true;
			effectsWin.addEventListener(MouseEvent.ROLL_OVER, function (e:Event):void 
			{
				trace("win OVER");
				effectsWin.minimized = false;
				if (hideAccordion) hideAccordion.cancel();
			});
			effectsWin.addEventListener(MouseEvent.ROLL_OUT, function (e:Event):void 
			{
				trace("win OUT");
				hideAccordion = FP.alarm(.5, function():void { effectsWin.minimized = true; });
			});

			FXMan.clear();
			
			for each (var o:XML in xml.effect) createUIFor(o, effectsAccordion);

			effectsAccordion.onMinimize = onAccordionChanged;
			effectsAccordion.onMaximize = onAccordionChanged;
			
			effectsWin.setSize(effectsAccordion.width + 1, effectsAccordion.height + 1 + 20);
			
			imageFX.onPreRender = function(imageFX:FXImage):void {
				var g:Graphics = FP.sprite.graphics;
				var mtx:Matrix = FP.matrix;
				mtx.createGradientBox(circle.r * 2, circle.r * 2, 0, -circle.r + player.x-200, -circle.r +player.y-100);
				g.clear();
				g.beginGradientFill(GradientType.RADIAL, [0xFF000000, 0xFFFFFFFF], [0, 1], [200, 244], mtx);
				g.drawRect(0, 0, imageFX.buffer.rect.width, imageFX.buffer.rect.height);
				g.endFill();
				maskBMD = new BitmapData(imageFX.buffer.rect.width, imageFX.buffer.rect.height, true, 0x0);
				maskBMD.draw(FP.sprite, null, null, BlendMode.NORMAL);
				//maskPixelate.update(maskImg);
				//maskPixelate.preRender(maskImg);
				//imgFX.setSource(maskImg.getSource(), maskBMD.rect, false);
				//imgFX.drawMask = maskImg.getSource();
				maskPixelate.applyTo(maskBMD);
				//Draw.graphic(new Image(maskBMD));
				//imageFX.drawMask = maskBMD;
				imageFX.applyMask(maskBMD);
				//maskPixelate.postRender(maskImg);
			}
			
			trace(imageFX.effects);
			
			var pbsf:PBShaderFilterFX = new PBShaderFilterFX("../../effects/dot.pbj", function ():void 
			{
				trace(pbsf.info, "\n\nloaded");
				trace(FXMan.BUILD_DATE);
			});
		}
		
		public function onAccordionChanged(accordion:Accordion, win:Window, idx:int):void 
		{
			trace(win.minimized ? "min" : "max", idx);
			imageFX.effects.at(idx).active = !win.minimized;
			effectsWin.setSize(accordion.width + 1, accordion.height + 1 + 20);
			trace(imageFX.effects.at(idx), imageFX.effects.at(idx).active);
		}
		
		public function createUIFor(xmlDesc:XML, accordion:Accordion):void 
		{
			trace(xmlDesc);
			
			var comp:*;
			var paramType:String;
			var paramClass:Class;
			var fxClassPath:String;
			var fxClass:Class;
			var min:*;
			var max:*;
			var value:*;
			var fx:FX;
			var win:Window;
			var winH:Number;
			var vbox:VBox;
			var hbox:HBox;
			var btn:PushButton;
			
			var dictEntry:* = {};
			var tweenFrom:* = {};
			var tweenTo:* = {};
			var defaults:* = {};
			var tween:TweenMax;
			
			fxClassPath = "punk.fx.effects." + xmlDesc.@className;
			fxClass = getDefinitionByName(fxClassPath) as Class;
			
			fx = new fxClass;
			FXMan.add(imageFX, fx);
			//imageFX.effects.add(fx);
			fx.active = false;
			
			accordion.addWindow(xmlDesc.@className);
			win = accordion.getWindowAt(accordion.numWindows - 1);
			win.hasMinimizeButton = true;
			winH = win.height;
			vbox = new VBox(win, 5, 2);
			vbox.spacing = 2;
			
			for each (var param:XML in xmlDesc.param) {
				paramType = param.@type;
				paramClass = getDefinitionByName(paramType) as Class;
				min = new paramClass(param.@min);
				max = new paramClass(param.@max);
				value = new paramClass(paramType == "Boolean" ? param.@default == "true" : param.@default);
				
				fx[param.@name] = value;
				
				if (param.@tweenFrom != undefined) tweenFrom[param.@name] = new paramClass(param.@tweenFrom);
				if (param.@tweenTo != undefined) {
					if (param.@name == "color" && paramType == "uint") {
						tweenTo.hexColors = {}; 
						tweenTo.hexColors[param.@name] = new paramClass(param.@tweenTo);
					} else {
						tweenTo[param.@name] = new paramClass(param.@tweenTo);	
					}
				}
				defaults[param.@name] = value;
				
				if (paramType == "Boolean") {
					hbox = new HBox(vbox);
					hbox.addChild(new Label(null, 0, 0, param.@name + ": "));
					comp = new CheckBox(hbox, 0, vbox.spacing*2, "") as CheckBox;
					comp.selected = value;
					comp.addEventListener(MouseEvent.CLICK, createEventDelegate(comp, fx, param.@name));
				} else if (paramType == "uint" && max >= 0xFFFFFF) {
					hbox = new HBox(vbox);
					hbox.addChild(new Label(null, 0, 0, param.@name + ": "));
					comp = new ColorChooser(hbox, 0, 0, value) as ColorChooser;
					comp.usePopup = true;
					comp.addEventListener(Event.CHANGE, createEventDelegate(comp, fx, param.@name));
				} else {
					comp = new HUISlider(vbox, 0, 0, param.@name + ": ") as HUISlider;
					comp.minimum = min;
					comp.maximum = max;
					comp.value = value;
					if (paramType == "int" || paramType == "uint") {
						comp.tick = 1;
						comp.labelPrecision = 0;
					}
					comp.addEventListener(Event.CHANGE, createEventDelegate(comp, fx, param.@name));
				}
				comp.name = param.@name;
				dictEntry = { comp:comp, fx:fx, defValue:value };
				components[xmlDesc.@className + "." + param.@name] = dictEntry;
				
				winH += 18 + vbox.spacing;
			}
			
			tweenTo["overwrite"] = "all";
			tweenTo["yoyo"] = true;
			tweenTo["repeat"] = 1;
			tween = new TweenMax(fx.setProps(defaults), 3.5, tweenTo);
			tween.pause();
			tweens[tweens.length] = tween;
			
			tween.eventCallback("onUpdate", function ():void 
			{
				var entry:*;
				
				for (var prop:String in tween.vars) {
					if (prop == "hexColors") prop = "color";
					entry = components[xmlDesc.@className + "." + prop];
					if (entry != undefined) {
						entry.comp.value = entry.fx[prop];
						entry.comp.enabled = false;
					}
				}
				
				//imageFX.updateBuffer();
			});
			
			tween.eventCallback("onComplete", function ():void 
			{
				var entry:*;
				
				for (var prop:String in tween.vars) {
					if (prop == "hexColors") prop = "color";
					entry = components[xmlDesc.@className + "." + prop];
					if (entry != undefined) {
						entry.comp.enabled = true;
					}
				}
			});
			
			hbox = new HBox(vbox);
			
			btn = new PushButton(hbox, 30, 0, "tween", function (e:Event):void 
			{
				for (var prop:String in tween.vars) {
					if (defaults.hasOwnProperty(prop)) fx.setProps(defaults[prop]);
				}
				tween.restart();
			});
			btn.width = 100;

			btn = new PushButton(hbox, 30, 0, "reset", function (e:Event):void 
			{
				tween.pause();
				fx.setProps(defaults);
				var entry:*;
				
				for (var prop:String in defaults) {
					entry = components[xmlDesc.@className + "." + prop];
					if (entry != undefined) {
						entry.comp.value = entry.defValue;
						entry.comp.enabled = true;
					}
				}
			});
			btn.width = 75;
			
			winH += 18 + vbox.spacing;
			win.setSize(accordion.width, winH + 5);
			
			//if (fx is GlowFX) vbox.enabled = false;

		}
		
		/**
		 * Sets the properties specified by the props Object on target.
		 * 
		 * @example This will set the <code>color</code> and <code>quality</code> properties of <code>effect</code>, 
		 * while skipping the <code>foobar</code> property without throwing an <code>Exception</code> 
		 * since <code>strictMode</code> is set to <code>false</code>.
		 * 
		 * <listing version="3.0">
		 * 
		 * effect.setProps(fadeFX, {color:0xff0000, quality:2, foobar:"dsjghkjdgh"}, false);
		 * </listing>
		 * 
		 * @param	target			the target object on which properties will be set.
		 * @param	props			an Object containing key/value pairs to be set on the FX instance.
		 * @param	strictMode		if true (default) an Excpetion will be thrown when trying to assign to properties/vars that don't exist in the FX instance.
		 * @return the target itself for chaining.
		 */
		public function setPropsOf(target:*, props:*, strictMode:Boolean=true):* 
		{
			for (var prop:* in props) {
				if (target.hasOwnProperty(prop)) target[prop] = props[prop];
				else if (strictMode) throw new Error("Cannot find property " + prop + " on " + target + ".");
			}
			
			return target;
		}

		public function createEventDelegate(comp:Component, obj:*, param:String):Function 
		{
			return function (e:Event):void 
			{
				var value:*;
				trace(comp, obj, param);
				if (comp is CheckBox) {
					value = (comp as CheckBox).selected;
				} else if (comp is HUISlider) {
					value = (comp as HUISlider).value;
				} else if (comp is ColorChooser) {
					value = (comp as ColorChooser).value;
				} else {
					throw new Error("Component " + comp + " not supported!");
				}
				obj[param] = value;

				//if (param.indexOf("scanLines") == 0) (fx as RetroCRTFX).updateScanLines(); 
				
				trace(obj, param, obj[param]);
				trace("del");
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (key(Key.SPACE, false)) {
				trace("imgrect", imageFX.clipRect);
				imageFX.setSource(FP.buffer, new Rectangle(40, 40, 140, 140));
				trace(imageFX.clipRect);
				//trace(imageFX.getSource().rect);
				trace("imgrect", imageFX.clipRect);
				//trace("bufrect", imageFX.buffer.rect);
			}
			if (key(Key.B, true)) {
				if (!clone) {
					clone = new FXImage();
					addGraphic(clone, -4, 400, 100);
					clone.scale = .5;
				}
				//clone.syncWith(ALIEN);
				FXMan.add(clone, adjustFX);
			}
			if (key(Key.X, false)) {
				wholeScreenImage = new FXImage();
				addGraphic(wholeScreenImage, -2);
				FXMan.add(wholeScreenImage, adjustFX);
			}
			
			var camHorzMove:Number;
			var camVertMove:Number;
			
			camHorzMove = uint(key(Key.LEFT)) * 1 + uint(key(Key.RIGHT)) * -1;
			camVertMove = uint(key(Key.UP)) * 1 + uint(key(Key.DOWN)) * -1;
			
			FP.camera.x += camHorzMove * 2;
			FP.camera.y += camVertMove * 2;
			
			//trace(blurFX.active, fx.active);
			//trace(imageFX.sourceIsScreen);
			//trace(wholeScreenImage && wholeScreenImage.sourceIsScreen);
		}
		
		override public function render():void 
		{
			if (Input.pressed(Key.L)) {
				TweenMax.fromTo(blurFilter, 3, { blurX:0 }, { blurX:20, overwrite:"all" } );
			}
			if (key(Key.F, true)) {
				Input.clear();
				trace(fx);
				//TweenMax.fromTo(fx, 4, {to:0}, { to:1 } );
				//imageFX.scale = 1.4;
				TweenMax.to(glowFX.setProps({active:true, color:0xff4499, blur:0, strength:0}, false), 4, { blur:6, strength:4, immediateRender:true, overwrite:"all" } );
				TweenMax.to(pixelateFX.setProps({scale:1, f:2}, false), 4, { scale:40, yoyo:true, repeat:-1, immediateRender:true, overwrite:"all" } );
				TweenMax.to(fx.setProps({active:true, alpha:0, f:2}, false), 4, { alpha:1, immediateRender:true, overwrite:"all" } );
				tween = TweenMax.to(blurFX.setProps( { active:true, blur:1, blurX:1}), 4, { blur:2, blurX:4, immediateRender:true, overwrite:"all" } );
				tween = TweenMax.to(bloomFX.setProps( { active:true, quality:1, blur:2, threshold:255}), 2, { blur:12, threshold:190, immediateRender:true, overwrite:"all" } );
				TweenMax.to(adjustFX.setProps({saturation:0, contrast:0, hue:0}), 4, { saturation:-.8, contrast:0, hue:0, brightness:-.4, immediateRender:true, overwrite:"all" } );
				tweenRetro();
				imageFX.angle = 0;
				TweenMax.to(shadowFilter, 4, { strength:10 } );
				TweenMax.to(halfToneFX.setProps({ angle:90, maxDotSize:8}), 3, { maxDotSize:8, repeat:-1, yoyo:true } );
				TweenMax.to(benderFX.setProps({direction:PBWaterFallFX.BOTTOM, percent:0}), 2, { percent:1, repeat:-1, yoyo:true, overwrite:"all" } );
				trace(FXMan);
				//imageFX.clipRect.width = imageFX.clipRect.height = 200;
				//imageFX.clipRect.x = imageFX.clipRect.y = 100;
				//TweenMax.to(benderFX.setProps({centerX:40, centerY:40, radius:1}), 3, { radius:50, repeat:-1, yoyo:true, immediateRender:true, overwrite:"all" } );
				//TweenMax.to(benderFX.setProps({scale:1}), 3, { scale:10, repeat:-1, yoyo:true, immediateRender:true, overwrite:"all" } );
				//TweenMax.to(PBFX.params.edgeHardness.value, 2, { "0":[1], yoyo:true, repeat:-1 } );
				//imageFX.color = 0xFFFFFF;
				//TweenMax.to(spriteFX, 4, { hexColors:{color:0x222222 }} );
				//imageFX.alpha = 0;
				//FP.tween(fx.setProps({alpha:0, color:0xff0000, f:2}, false), { alpha:1 }, 4 );
				TweenMax.delayedCall(2, function ():void 
				{
					//blurFX.active = false;
					//imageFX.active = false;
					//tween.pause();
					//blurFX.active = false;
					//trace("delayed");
					//trace(imageFX.tintMode, imageFX.color);
					//FXMan.clear();
					//fx.visible = fx.active = !fx.active;
				});
			}
				/*var g:Graphics = FP.sprite.graphics;
				var mtx:Matrix = FP.matrix;
				mtx.createGradientBox(circle.r * 2, circle.r * 2, 0, -circle.r + player.x-200, -circle.r +player.y-100);
				g.clear();
				g.beginGradientFill(GradientType.RADIAL, [0xFF000000, 0xFFFFFFFF], [0, 1], [200, 244], mtx);
				g.drawRect(0, 0, imageFX.width, imageFX.height);
				g.endFill();
				maskBMD.fillRect(maskBMD.rect, 0x0);
				maskBMD.draw(FP.sprite, null, null, BlendMode.NORMAL);
				//maskPixelate.update(maskImg);
				//maskPixelate.preRender(maskImg);
				//imgFX.setSource(maskImg.getSource(), maskBMD.rect, false);
				//imgFX.drawMask = maskImg.getSource();
				maskPixelate.applyTo(maskBMD);
				//Draw.graphic(new Image(maskBMD));
				imageFX.drawMask = maskBMD;
				//maskPixelate.postRender(maskImg);*/

			super.render();
			if (clone) clone.cloneGraphicsFrom(spriteFX);
			if (key(Key.C, true)) {
				maskPixelate.applyTo(FP.buffer);
			}
			Draw.rectPlus(40+FP.camera.x, 40+FP.camera.y, 140, 140, 0xFFFFFF, 1, false);
			Draw.rectPlus(200, 100, 140, 140, 0xFF000000, 1, false);
			Draw.rectPlus(400-5, 100-5, 10, 10, 0xFFFF0000, 1, false);
			Draw.rectPlus(40-1, 140-1, 4, 4, 0xFFFF00, 1, false);

		}

		public function tweenRetro():void 
		{
			//imageFX.alpha = 1-Math.random()*.2;
			TweenMax.to(retroCRTFX.setProps( { redOffsetY:randRange( -4, 4), greenOffsetY:randRange( -4, 4), blueOffsetY:randRange( -4, 4) } ), .2, { redOffsetY:randRange( -4, 4), greenOffsetY:randRange( -4, 4), blueOffsetY:randRange( -4, 4), immediateRender:true, overwrite:"all", onComplete:function ():void { tweenRetro(); }} );
		}

		public function randRange(min:Number, max:Number):Number 
		{
			var randomNum:Number = Math.random() * (max - min + 1) + min;
			return randomNum;
		}
		
		public function drawRegularPoly():void 
		{
			
		}
		
		public function key(input:*, check:Boolean = true):Boolean 
		{
			var checkFunc:Function = check ? Input.check : Input.pressed;
			return checkFunc(input);
		}
	}

}