package  
{
	import com.bit101.components.*;
	import com.greensock.*;
	import flash.events.*;
	import flash.utils.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import punk.fx.*;
	import punk.fx.effects.*;
	import punk.fx.graphics.*;
	
	/**
	 * punk.fx demo world
	 * 
	 * @author azrafe7
	 */
	public class TestWorld extends World 
	{
		// declare all FXs so that the compiler knows them
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
		
		// declare all FXGraphicss so that the compiler knows them
		FXText;
		FXImage;
		FXPreRotation;
		FXSpritemap;
		FXTiledImage;
		FXTiledSpritemap;
		
		[Embed(source="effects.xml", mimeType="application/octet-stream")]
		public var EFFECTS_XML:Class;
		
		[Embed(source = "assets/background.png")]
		public var BACKGROUND:Class;
				
		
		private var xml:XML;
		private var effectsWin:Window;
		private var hideAccordion:Tween;
		public var components:Dictionary = new Dictionary(true); // key=<fx name>.<prop> value={comp:<component>, fx:<fx>, defValue:*}
		public var tween:TweenMax;

		public var fxImage:FXImage;			// whole screen
		public var fxSpritemap:FXSpritemap;	// swordguy
		public var fxTarget:IFXGraphic;		// switches between fxImage and fxSpritemap
		public var background:Backdrop;
		public var fx:FX;
		public static var player:Player;
		
		
		public function TestWorld() 
		{
			
		}
		
		override public function begin():void 
		{
			super.begin();
			
			background = new Backdrop(BACKGROUND, false, false);
			background.y = 100;
			addGraphic(background);
			
			add(player = new Player(400, 260));
			player.layer = -2;
			
			fxSpritemap = player.sprSwordguy;
			fxSpritemap.name = "FXSwordguy";
			fxSpritemap.scale = 1;
			fxSpritemap.autoUpdate = true;
			
			fxImage = new FXImage;	// no source passed as first parameter => represents the whole screen
			fxImage.name = "FXScreen";
			fxImage.autoUpdate = false;
			addGraphic(fxImage, -3);	// layers matter... try changing this to -1
			
			// clear the screen before drawing fxImage
			fxImage.onPreRender = function (img:FXImage):void 
			{
				FP.screen.refresh();
			}
			
			fxTarget = fxImage;
			
			createUI();
		}

		// creates the EffectExplorer win
		public function createUI():void 
		{
			xml = FP.getXML(EFFECTS_XML);
			
			Style.setStyle(Style.LIGHT);
			
			effectsWin = new Window(FP.engine, 5, 25, "Effects Explorer - ver " + FXMan.VERSION);
			
			// create target radio buttons
			createTargetUI();
			
			var effectsAccordion:Accordion = new Accordion(effectsWin, 0, 0);
			effectsAccordion.width = 190;
			effectsWin.alpha = .9;
			effectsWin.hasMinimizeButton = true;
			
			//effectsWin.minimized = true;
			effectsWin.addEventListener(MouseEvent.ROLL_OVER, function (e:Event):void 
			{
				effectsWin.minimized = false;
				if (hideAccordion) hideAccordion.cancel();
			});
			effectsWin.addEventListener(MouseEvent.ROLL_OUT, function (e:Event):void 
			{
				hideAccordion = FP.alarm(.5, function():void { effectsWin.minimized = true; });
			});

			// create UI for each effect in the xml
			for each (var o:XML in xml.effect) createUIFor(o, effectsAccordion);

			effectsAccordion.onMinimize = onAccordionChanged;
			effectsAccordion.onMaximize = onAccordionChanged;
			
			effectsWin.setSize(effectsAccordion.width + 1, effectsAccordion.height + 1 + 20);
		}
		
		// fired when an accordion is minimized/maximized
		public function onAccordionChanged(accordion:Accordion, win:Window, idx:int):void 
		{
			fxTarget.effects.at(idx).active = !win.minimized;
			effectsWin.setSize(accordion.width + 1, accordion.height + 1 + 20);
		}
		
		// create UI for target selection
		public function createTargetUI():void 
		{
			
			var win:Window = new Window(FP.engine, FP.width-150, 25, "Target Selection:");
			win.alpha = .9;
			win.hasMinimizeButton = false;
			var winH:Number = win.titleBar.height;
			var vbox:VBox = new VBox(win, 8, 5);
			
			var radio:RadioButton;
			radio = new RadioButton(vbox, 0, 0, "FXImage (screen)", fxTarget == fxImage, switchTarget);
			radio = new RadioButton(vbox, 0, 0, "FXSpritemap (swordguy)", fxTarget == fxSpritemap, switchTarget);
			
			winH += 18 * 2;
			win.setSize(145, winH);
		}
		
		
		// switch target
		public function switchTarget(e:Event):void 
		{
			var radio:RadioButton = RadioButton(e.target);
			if ((radio.label.indexOf("FXImage") >= 0 && fxTarget == fxImage) || (radio.label.indexOf("FXSpritemap") >= 0 && fxTarget == fxSpritemap)) return;
			var oldTarget:IFXGraphic = fxTarget;
			fxTarget = (oldTarget == fxSpritemap ? fxImage : fxSpritemap);
			fxTarget.effects.clear();
			FXMan.add(fxTarget, oldTarget.effects.getAll());
			FXMan.removeTargets(oldTarget);
		}
		
		// create components and add them to accordion by parsing the xml. Also binding it all together (comps, tween, fx).
		public function createUIFor(xmlDesc:XML, accordion:Accordion):void 
		{
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
			FXMan.add(fxTarget, fx);
			fx.active = false;
			
			accordion.addWindow(xmlDesc.@className);
			win = accordion.getWindowAt(accordion.numWindows - 1);
			win.hasMinimizeButton = true;
			winH = win.height;
			vbox = new VBox(win, 5, 2);
			vbox.spacing = 2;
			
			// prepare fx, components and tween by parsing the xml
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
			
			// setup tween props
			tweenTo["overwrite"] = "all";
			tweenTo["yoyo"] = true;
			tweenTo["repeat"] = 1;
			tween = new TweenMax(fx.setProps(defaults), 3, tweenTo);
			tween.pause();
			
			// disable componenst while the tween is running
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
			});
			
			// reenable components when the tween ends
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
			
			// tweeen button
			btn = new PushButton(hbox, 30, 0, "tween", function (e:Event):void 
			{
				for (var prop:String in tween.vars) {
					if (defaults.hasOwnProperty(prop)) fx.setProps(defaults[prop]);
				}
				tween.restart();
			});
			btn.width = 100;

			// reset button
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
		}

		// returns a delegate function that responds to the "main" comp event
		public function createEventDelegate(comp:Component, obj:*, param:String):Function 
		{
			return function (e:Event):void 
			{
				var value:*;
				//trace(comp, obj, param);
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
			}
		}
		
	}

}