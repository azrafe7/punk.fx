package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;

	/**
	 * Retro CRT effect with scanlines, noise and RGB channels displacement.
	 * 
	 * Adapted from Cadin Batrack's code.
	 * 
	 * @see http://active.tutsplus.com/tutorials/effects/create-a-retro-crt-distortion-effect-using-rgb-shifting/
	 * 
	 * @author azrafe7
	 */
	public class RetroCRTFX extends FX
	{
		/** @private Rectangle used for tracking the max BitmapData size used so far */
		protected var _rect:Rectangle = new Rectangle;

		/** @private Internal var used to signal that the scan lines need to be redrawn */
		protected var _updateScanLines:Boolean = false;

		/** @private BitmapData used for the red channel */
		protected var _redBMD:BitmapData;

		/** @private BitmapData used for the green channel */
		protected var _greenBMD:BitmapData;

		/** @private BitmapData used for the blue channel */
		protected var _blueBMD:BitmapData;

		/** @private BitmapData used for the noise */
		protected var _noiseBMD:BitmapData;

		/** @private BitmapData used for the scan lines */
		protected var _scanLinesBMD:BitmapData;

		/** @private Offset of the red channel */
		protected var _redOffset:Point = new Point;

		/** @private Offset of the green channel */
		protected var _greenOffset:Point = new Point;

		/** @private Offset of the blue channel */
		protected var _blueOffset:Point = new Point;

		/** Identifies horizontal scan lines. */
		public static const HORIZONTAL:int = 0;
		
		/** Identifies vertical scan lines. */
		public static const VERTICAL:int = 1;
		
		/** X offset of the red channel. */
		public var redOffsetX:Number;

		/** Y offset of the red channel. */
		public var redOffsetY:Number;

		/** X offset of the green channel. */
		public var greenOffsetX:Number;

		/** Y offset of the green channel. */
		public var greenOffsetY:Number;

		/** X offset of the blue channel. */
		public var blueOffsetX:Number;

		/** Y offset of the blue channel. */
		public var blueOffsetY:Number;

		/** Whether to draw the scan lines. */
		public var scanLines:Boolean;

		/** Distance between scan lines. */
		public var scanLinesGap:Number = 2;
		
		/** Thickness of each scan line. */
		public var scanLinesThickness:Number = 1;
		
		/** Scan lines color. */
		public var scanLinesColor:uint = 0x333333;

		/** Scan lines alpha. */
		public var scanLinesAlpha:Number = .2;
		
		/** Scan lines direction. */
		public var scanLinesDir:int = RetroCRTFX.HORIZONTAL;
		
		/** Scan lines blend mode. */
		public var scanLinesBlendMode:String = BlendMode.ADD;
		
		/** Amount of noise to draw (0..255). Set this to 0 for no noise. */
		public var noiseAmount:uint;

		/** Noise blend mode. */
		public var noiseBlendMode:String = BlendMode.ADD;
		
		/** Random seed to use for noise generation (set this to a negative number for random generation). */
		public var noiseSeed:int = -1;

		/** Wheter the red channel should be visible. */
		public var showRedChannel:Boolean = true;
		
		/** Wheter the red channel should be visible. */
		public var showGreenChannel:Boolean = true;
		
		/** Wheter the red channel should be visible. */
		public var showBlueChannel:Boolean = true;

		
		/**
		 * Creates a new RetroCRTFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	offsets			Array containing the offsets for each channel in order [redOffsetX, redOffsetY, greenOffsetX, greenOffsetY, blueOffsetX, blueOffsetY]. Defaults to [0, 0, 0, 0, 0, 0].
-		 * @param	scanLines		whether to draw the scan lines.
		 * @param	noiseAmount		amount of noise to draw (0..255). Set this to 0 for no noise.
		 */
		public function RetroCRTFX(offsets:Array = null, scanLines:Boolean = true, noiseAmount:uint = 25) 
		{
			super();
			
			var tmpOffsets:Array = [0, 0, 0, 0, 0, 0];
			if (offsets) {
				for (var i:int = 0; i < offsets.length; ++i) {
					if (i >= 6) break;
					tmpOffsets[i] = offsets[i];
				}
			}
			setOffsets.apply(null, tmpOffsets);
			this.scanLines = scanLines;
			this.noiseAmount = noiseAmount;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			// create new bitmapDatas if the current ones are too small
			if (_rect.width < clipRect.width || _rect.height < clipRect.height) {			
				_redBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);
				_greenBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);
				_blueBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);

				_noiseBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);
				_scanLinesBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);

				// set flag to redraw scan lines
				updateScanLines();

				// adjust rect size
				_rect.width = clipRect.width;
				_rect.height = clipRect.height;

				trace("new Data", bitmapData.rect)
			}
			
			// draw scan lines
			if (_updateScanLines) {
				redrawScanLines();
				_updateScanLines = false;
			}
			
			if (redOffsetX == 0 && redOffsetY == 0 && greenOffsetX == 0 && greenOffsetY == 0 && blueOffsetX == 0 && blueOffsetY == 0) {
				// no offsets => do nothing
				//trace("no offsets")
			} else {
				// clear channel bitmapDatas
				_redBMD.fillRect(bitmapData.rect, 0xFF000000);
				_greenBMD.fillRect(bitmapData.rect, 0xFF000000);
				_blueBMD.fillRect(bitmapData.rect, 0xFF000000);
				
				// update offset points
				_redOffset.x = redOffsetX; 			_redOffset.y = redOffsetY;
				_greenOffset.x = greenOffsetX; 		_greenOffset.y = greenOffsetY;
				_blueOffset.x = blueOffsetX; 		_blueOffset.y = blueOffsetY;
				
				// copy RGB channels to respective bitmapDatas with relative offsets
				if (showRedChannel) _redBMD.copyChannel(bitmapData, clipRect, _redOffset, BitmapDataChannel.RED, BitmapDataChannel.RED);
				if (showGreenChannel) _greenBMD.copyChannel(bitmapData, clipRect, _greenOffset, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
				if (showBlueChannel) _blueBMD.copyChannel(bitmapData, clipRect, _blueOffset, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
				
				// clear target
				bitmapData.fillRect(clipRect, 0);
				
				// update matrix to draw to proper position
				_mat.identity();
				_mat.translate(clipRect.x, clipRect.y);
				
				// draw channels to target
				if (showRedChannel) bitmapData.draw(_redBMD, _mat);
				if (showGreenChannel) bitmapData.draw(_greenBMD, _mat, null, BlendMode.SCREEN);
				if (showBlueChannel) bitmapData.draw(_blueBMD, _mat, null, BlendMode.SCREEN);
			}			
			
			// apply background noise
			if (noiseAmount > 0) {
				_noiseBMD.noise(noiseSeed < 0 ? Math.random() * 255 : noiseSeed, 0, noiseAmount, 7, true);
				bitmapData.draw(_noiseBMD, _mat, null, noiseBlendMode);
			}
			
			// apply scan lines
			if (scanLines) {
				bitmapData.draw(_scanLinesBMD, _mat, null, scanLinesBlendMode);
			}

			super.applyTo(bitmapData, clipRect);
		}

		/**
		 * Shortcut function to set the RGB channels offsets.
		 * 
		 * @return this FX for chaining.
		 */
		public function setOffsets(rx:Number=0, ry:Number=0, gx:Number=0, gy:Number=0, bx:Number=0, by:Number=0):*
		{
			redOffsetX = rx;
			redOffsetY = ry;
			greenOffsetX = gx;
			greenOffsetY = gy;
			blueOffsetX = bx;
			blueOffsetY = by;
			
			return this;
		}


		/** Updates the scan lines. You may need to call this if you modify the scan lines settings.
		 * 
		 * @return this FX for chaining.
		 */
		public function updateScanLines():* 
		{
			_updateScanLines = true;
			return this;
		}

		/** @private */
		protected function redrawScanLines():void 
		{
			var g:Graphics = FP.sprite.graphics;
			g.clear();
			g.lineStyle(scanLinesThickness, scanLinesColor, scanLinesAlpha);
			if (scanLinesDir == RetroCRTFX.HORIZONTAL) {
				for (var y:Number = 0; y < _scanLinesBMD.height; y += scanLinesGap) {
					g.moveTo(_scanLinesBMD.rect.x, y);
					g.lineTo(_scanLinesBMD.rect.width, y);
				}
			} else {
				for (var x:Number = 0; x < _scanLinesBMD.width; x += scanLinesGap) {
					g.moveTo(x, _scanLinesBMD.rect.y);
					g.lineTo(x, _scanLinesBMD.rect.height);
				}
			}
			_scanLinesBMD.draw(FP.sprite);
		}
		
	}

}