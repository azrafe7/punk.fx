package  
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.RoughEase;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.motionPaths.RectanglePath2D;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import punk.fx.EffectList;
	import punk.fx.effects.BloomEffect;
	import punk.fx.effects.BlurEffect;
	import punk.fx.effects.AdjustEffect;
	import punk.fx.effects.Effect;
	import punk.fx.effects.FadeEffect;
	import punk.fx.effects.FilterEffect;
	import punk.fx.effects.GlowEffect;
	import punk.fx.effects.PBHalfToneEffect;
	import punk.fx.effects.PBPixelateEffect;
	import punk.fx.effects.PixelateEffect;
	import punk.fx.effects.PixelBenderEffect;
	import punk.fx.effects.RetroCRTEffect;
	import punk.fx.FXImage;
	import punk.fx.FXMan;
	import punk.fx.FXImage;
	
	/**
	 * ...
	 * @author azrafe7
	 */
	public class TestWorld extends World 
	{
		private var wholeScreenImage:FXImage;
		private var tween:TweenMax;
		private var swordguy:Spritemap;
		private var spriteFX:FXImage;
		private var maskPixelate:PixelateEffect;
		private var clone:FXImage;
		private var shadowFilter:DropShadowFilter;
		private var filtersFX:FilterEffect;
		private var bevelFilter:BevelFilter;


		[Embed("../bin/zoomBlurFocus.pbj", mimeType="application/octet-stream")]
		private var ZOOMBLURFOCUS:Class;		
		private var PBEffect:PixelBenderEffect;
		private var halfToneFX:PBHalfToneEffect;
		private var pbPixelFX:PBPixelateEffect;

		
		[Embed(source = "assets/longBackground.png")]
		protected var BACKGROUND:Class;
		
		[Embed(source = "assets/flashpunk.png")]
		protected var IMAGE:Class;
		
		[Embed(source = "assets/alien2.png")]
		protected var ALIEN:Class;
		
		protected var imageFX:FXImage;
		protected var background:Backdrop;
		
		protected var fadeFX:FadeEffect;
		
		protected var fx:Effect;
		protected var blurFX:Effect;
		protected var pixelateFX:Effect;
		protected var glowFX:Effect;
		protected var adjustFX:Effect;
		protected var retroCRTFX:Effect;
		protected var bloomFX:Effect;
		
		public static var player:Player;
		
		protected var fxList:EffectList = new EffectList;
		
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
			
			fadeFX = new FadeEffect();
			fx = fadeFX;
			fx.setProps( { opaque:false, color:0xfffffff0 } );
			blurFX = new BlurEffect;
			pixelateFX = new PixelateEffect;
			glowFX = new GlowEffect;
			adjustFX = new AdjustEffect;
			retroCRTFX = new RetroCRTEffect().setOffsets(0);
			bloomFX = new BloomEffect(4, 255);
			
			FXMan.clear();
			
			var circle:Object = {r:0};
			TweenMax.to(circle, 1, {r:100, yoyo:true, repeat:-1, ease:Linear.ease});
			var maskBMD:BitmapData = new BitmapData(imageFX.width, imageFX.height, true, 0xFF000000);
			var maskImg:FXImage = new FXImage(maskBMD);
			maskPixelate = new PixelateEffect(10);
			
			//addGraphic(maskImg, -2, -200);
			//FXMan.add(maskImg, [maskPixelate]);
			
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
				
			imageFX.onPreRender = function(imgFX:FXImage):void {
				var g:Graphics = FP.sprite.graphics;
				var mtx:Matrix = FP.matrix;
				mtx.createGradientBox(circle.r * 2, circle.r * 2, 0, -circle.r + player.x-200, -circle.r +player.y-100);
				g.clear();
				g.beginGradientFill(GradientType.RADIAL, [0xFF000000, 0xFFFFFFFF], [0, 1], [200, 244], mtx);
				g.drawRect(0, 0, imgFX.width, imgFX.height);
				g.endFill();
				maskBMD.fillRect(maskBMD.rect, 0x0);
				maskBMD.draw(FP.sprite, null, null, BlendMode.NORMAL);
				//maskPixelate.update(maskImg);
				//maskPixelate.preRender(maskImg);
				//imgFX.setSource(maskImg.getSource(), maskBMD.rect, false);
				//imgFX.drawMask = maskImg.getSource();
				maskPixelate.applyTo(maskBMD);
				//Draw.graphic(new Image(maskBMD));
				imgFX.drawMask = maskBMD;
				//maskPixelate.postRender(maskImg);
			}
			
			retroCRTFX.onPostProcess = function (bmd:BitmapData, clipRect:Rectangle = null):void 
			{
				//maskPixelate.applyTo(bmd);
				//blurFX.setProps({blur:1, blurX:3}).applyTo(bmd);
			}
			
			FXMan.add(imageFX, [bloomFX, pixelateFX/*, retroCRTFX.setProps({scanLinesColor:0x00ff00, noiseAmount:60})/*, bloomFX/*adjustFX, maskPixelate.setProps({scale:5})/*, pixelateFX*/]);
			imageFX.centerOO();
			imageFX.x += imageFX.width>>1;
			imageFX.y += imageFX.height>>1;
			//imageFX.blend = BlendMode.HARDLIGHT;
			trace(FXMan);

			add(player = new Player(400, 240));
			player.layer = -2;
			
			var rectImg:Image = Image.createRect(48, 26, 0xff0000);
			rectImg.scale = 2;
			rectImg.angle = 0;
			//rectImg.centerOO();
			//rectImg.originX -= 10;
			//addGraphic(rectImg, 0, 40, 140);
			
			

			swordguy = player.sprSwordguy;
			
			
			swordguy.centerOO();
			//swordguy.visible = false;
			//addGraphic(swordguy, 0, 40, 140);
			
			//swordguy.color = 0xff0000;

			// side size of the BitmapData that will contain the rotated image
			var size:Number = Math.sqrt(swordguy.scaledWidth * swordguy.scaledWidth + swordguy.scaledHeight * swordguy.scaledHeight);
			
			spriteFX = FXImage.createRect(size, size);

			//spriteFX.color = 0xff00ffff;
			spriteFX.centerOO();
			//spriteFX.originX = 12;
			//spriteFX.originY *=2;
			spriteFX.alpha = 1;
			spriteFX.scale = 2;
			//spriteFX.smooth = true;
			addGraphic(spriteFX, -1, 40, 140);
			FXMan.add(spriteFX, [bloomFX, pixelateFX/*retroCRTFX/*, glowFX, pixelateFX, fx/**/]);

			spriteFX.onPreRender = function(imgFX:FXImage):void {
				var bmd:BitmapData = spriteFX.getSource();
				bmd.fillRect(bmd.rect, 0);
				
				// set up transformation matrix
				var m:Matrix = new Matrix();
				m.translate(-swordguy.originX, -swordguy.originY);
				m.rotate(swordguy.angle * FP.RAD);
				m.translate(swordguy.originX, swordguy.originY);
				m.scale(swordguy.scaleX * swordguy.scale, swordguy.scaleY * swordguy.scale);

				// four corners of the bounding box after transformation
				var topLeft:Point = m.transformPoint(new Point(0, 0));
				var topRight:Point = m.transformPoint(new Point(swordguy.width, 0));
				var bottomLeft:Point = m.transformPoint(new Point(0, swordguy.height));
				var bottomRight:Point = m.transformPoint(new Point(swordguy.width, swordguy.height));
				
				// origin point after transformation
				var origin:Point = m.transformPoint(new Point(swordguy.originX, swordguy.originY));

				// bounding box distances
				var top:Number = Math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
				var bottom:Number = Math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
				var left:Number = Math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
				var right:Number = Math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);

				// size of the new BitmapData
				var height:Number = bottom - top;
				var width:Number = right - left;
								
				swordguy.render(bmd, new Point(origin.x - left, origin.y - top), FP.zero);
								
				// align spriteFX with source image position
				imgFX.x = imgFX.originX - origin.x + left;
				imgFX.y = imgFX.originY - origin.y + top;
								
				//maskPixelate.applyTo(bmd);

				spriteFX.setSource(bmd, bmd.rect);
				
				
				if (key(Key.Q)) swordguy.angle += .9;
				
			}
				
			shadowFilter = new DropShadowFilter;
			bevelFilter = new BevelFilter;
			filtersFX = new FilterEffect([shadowFilter, bevelFilter]);
			
			FXMan.removeTargets(imageFX);

			
			halfToneFX = new PBHalfToneEffect();
			//FXMan.add(imageFX, halfToneFX);

			pbPixelFX = new PBPixelateEffect;
			FXMan.add(imageFX, pbPixelFX);
			
			for (var i:int = 0; i < 10; i++) {
				//var imgFX:FXImage = FXImage.createCircle(40, 0xff0000);
				var imgFX:FXImage = new FXImage(ALIEN);
				imgFX.scale = 4;
				addGraphic(imgFX, -1, Math.random() * FP.width, Math.random() * FP.height);
				//imgFX.drawMask = imgFX.getSource();
				FXMan.add(imgFX, [filtersFX/*pixelateFX, bloomFX/*retroCRTFX/*, fx, pixelateFX*/]);
			}
		
			
			trace(FXMan);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (key(Key.SPACE, false)) {
				trace("imgrect", imageFX.clipRect);
				imageFX.setSource(FP.buffer, new Rectangle(40, 40, 140, 140));
				trace(imageFX.clipRect);
				trace(imageFX.getSource().rect);
				trace("imgrect", imageFX.clipRect);
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
				TweenMax.to(pbPixelFX, 3, { scale:40, repeat:-1, yoyo:true } );
				//TweenMax.to(PBEffect.params.edgeHardness.value, 2, { "0":[1], yoyo:true, repeat:-1 } );
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
			super.render();
			if (clone) clone.syncGFXWith(spriteFX);
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