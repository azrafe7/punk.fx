package punk.fx.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;

	/**
	 * Static noise and scanlines effect.
	 * 
	 * Builds up from Cadin Batrack's code.
	 * 
	 * @see http://active.tutsplus.com/tutorials/effects/create-a-retro-crt-distortion-effect-using-rgb-shifting/
	 * 
	 * @author azrafe7
	 */
	public class ScanLinesFX extends FX
	{
		/** @private Rectangle used for tracking the max BitmapData size used so far */
		protected var _rect:Rectangle = new Rectangle;

		/** @private Internal var used to signal that the scan lines need to be redrawn */
		protected var _updateScanLines:Boolean = false;

		/** @private BitmapData used for the noise */
		protected var _noiseBMD:BitmapData;

		/** @private BitmapData used for the scan lines */
		protected var _scanLinesBMD:BitmapData;

		/** @private BitmapData used for the draw mask */
		protected var _maskBMD:BitmapData;

		
		/** Identifies horizontal scan lines. */
		public static const HORIZONTAL:int = 0;
		
		/** Identifies vertical scan lines. */
		public static const VERTICAL:int = 1;
		
		/** @private Distance between scan lines. */
		protected var _scanLinesGap:Number = 2;
		
		/** @private Thickness of each scan line. */
		protected var _scanLinesThickness:Number = 1;
		
		/** @private Scan lines color. */
		protected var _scanLinesColor:uint = 0x333333;

		/** @private Scan lines alpha. */
		protected var _scanLinesAlpha:Number = .2;
		
		/** @private Scan lines direction. */
		protected var _scanLinesDir:int = ScanLinesFX.HORIZONTAL;
		
		/** @private Scan lines offset. */
		protected var _scanLinesOffset:Number = 0;
		
		/** @private Whether to use a draw mask. */
		protected var _useDrawMask:Boolean = false;

		/** Whether to draw the scan lines. */
		public var scanLines:Boolean;

		/** Scan lines blend mode. */
		public var scanLinesBlendMode:String = BlendMode.ADD;
		
		/** Amount of noise to draw (0..255). Set this to 0 for no noise. */
		public var noiseAmount:uint;

		/** Noise blend mode. */
		public var noiseBlendMode:String = BlendMode.ADD;
		
		/** Random seed to use for noise generation (set this to a negative number for random generation). */
		public var noiseSeed:int = -1;

		
		/**
		 * Creates a new ScanLinesFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	scanLines		whether to draw the scan lines.
		 * @param	noiseAmount		amount of noise to draw (0..255). Set this to 0 for no noise.
		 */
		public function ScanLinesFX(scanLines:Boolean = true, noiseAmount:uint = 25) 
		{
			super();
			
			this.scanLines = scanLines;
			this.noiseAmount = noiseAmount;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			// create new bitmapDatas if the current ones are too small
			if (_rect.width < clipRect.width || _rect.height < clipRect.height) {			
				_noiseBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);
				_scanLinesBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);
				_maskBMD = new BitmapData(clipRect.width, clipRect.height, true, 0);

				// set flag to redraw scan lines
				_updateScanLines = true;

				// adjust rect size
				_rect.width = clipRect.width;
				_rect.height = clipRect.height;

				//trace("ScanLines: new BMD", bitmapData.rect)
			}
			
			// draw scan lines
			if (_updateScanLines) {
				redrawScanLines();
				_updateScanLines = false;
			}
			
			// update matrix to draw to proper position
			_mat.identity();
			_mat.translate(clipRect.x, clipRect.y);
			
			// create mask
			if (_useDrawMask) {
				_maskBMD.fillRect(_maskBMD.rect, 0);
				_maskBMD.threshold(bitmapData, clipRect, FP.zero, ">", 0x00000000, 0xFF000000, 0xFFFFFFFF);
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

			// apply mask
			if (_useDrawMask) {
				bitmapData.copyPixels(bitmapData, clipRect, clipRect.topLeft, _maskBMD, clipRect.topLeft);
			}
			
			super.applyTo(bitmapData, clipRect);
		}

		/** @private */
		protected function redrawScanLines():void 
		{
			var g:Graphics = FP.sprite.graphics;
			g.clear();
			g.lineStyle(scanLinesThickness, scanLinesColor & 0xFFFFFF, scanLinesAlpha);
			if (scanLinesDir == ScanLinesFX.HORIZONTAL) {
				for (var y:Number = _scanLinesOffset % _scanLinesGap; y < _scanLinesBMD.height; y += scanLinesGap) {
					g.moveTo(_scanLinesBMD.rect.x, y);
					g.lineTo(_scanLinesBMD.rect.width, y);
				}
			} else {
				for (var x:Number = _scanLinesOffset % _scanLinesGap; x < _scanLinesBMD.width; x += scanLinesGap) {
					g.moveTo(x, _scanLinesBMD.rect.y);
					g.lineTo(x, _scanLinesBMD.rect.height);
				}
			}
			_scanLinesBMD.fillRect(_scanLinesBMD.rect, 0);
			_scanLinesBMD.draw(FP.sprite);
		}
		
		/** Distance between scan lines. */
		public function get scanLinesGap():Number 
		{
			return _scanLinesGap;
		}
		
		/** @private */
		public function set scanLinesGap(value:Number):void 
		{
			if (value != _scanLinesGap) _updateScanLines = true;
			_scanLinesGap = value;
		}
		
		/** Thickness of each scan line. */
		public function get scanLinesThickness():Number 
		{
			return _scanLinesThickness;
		}
		
		/** @private */
		public function set scanLinesThickness(value:Number):void 
		{
			if (value != _scanLinesThickness) _updateScanLines = true;
			_scanLinesThickness = value;
		}
				
		/** Scan lines color. */
		public function get scanLinesColor():uint 
		{
			return _scanLinesColor;
		}
		
		/** @private */
		public function set scanLinesColor(value:uint):void 
		{
			if (value != _scanLinesColor) _updateScanLines = true;
			_scanLinesColor = value;
		}
		
		/** Scan lines alpha. */
		public function get scanLinesAlpha():Number 
		{
			return _scanLinesAlpha;
		}
		
		/** @private */
		public function set scanLinesAlpha(value:Number):void 
		{
			if (value != _scanLinesAlpha) _updateScanLines = true;
			_scanLinesAlpha = value;
		}
		
		/** Scan lines direction. */
		public function get scanLinesDir():int 
		{
			return _scanLinesDir;
		}
		
		/** @private */
		public function set scanLinesDir(value:int):void 
		{
			if (value != _scanLinesDir) _updateScanLines = true;
			_scanLinesDir = value;
		}
		
		/** Scan lines offset. */
		public function get scanLinesOffset():Number 
		{
			return _scanLinesOffset;
		}
		
		/** @private */
		public function set scanLinesOffset(value:Number):void 
		{
			if (value != _scanLinesOffset) _updateScanLines = true;
			_scanLinesOffset = value;
		}
		
		/** Whether to use a draw mask. */
		public function get useDrawMask():Boolean 
		{
			return _useDrawMask;
		}
		
		/** @private */
		public function set useDrawMask(value:Boolean):void 
		{
			_useDrawMask = value;
		}
		
	}

}