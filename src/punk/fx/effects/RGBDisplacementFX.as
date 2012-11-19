package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import net.flashpunk.FP;

	/**
	 * RGB channels displacement effect.
	 * 
	 * Builds up from Cadin Batrack's code.
	 * 
	 * @see http://active.tutsplus.com/tutorials/effects/create-a-retro-crt-distortion-effect-using-rgb-shifting/
	 * 
	 * @author azrafe7
	 */
	public class RGBDisplacementFX extends FX
	{
		/** @private Rectangle used for tracking the max BitmapData size used so far */
		protected var _rect:Rectangle = new Rectangle;

		/** @private BitmapData used for the red channel */
		protected var _redBMD:BitmapData;

		/** @private BitmapData used for the green channel */
		protected var _greenBMD:BitmapData;

		/** @private BitmapData used for the blue channel */
		protected var _blueBMD:BitmapData;

		/** @private Offset of the red channel */
		protected var _redOffset:Point = new Point;

		/** @private Offset of the green channel */
		protected var _greenOffset:Point = new Point;

		/** @private Offset of the blue channel */
		protected var _blueOffset:Point = new Point;

		/** @private ColorTransform used to isolate the channels. */
		protected var _colorTransform:ColorTransform = new ColorTransform(0, 0, 0, 1);
		
		
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

		/** Wheter the red channel should be visible. */
		public var showRedChannel:Boolean = true;
		
		/** Wheter the red channel should be visible. */
		public var showGreenChannel:Boolean = true;
		
		/** Wheter the red channel should be visible. */
		public var showBlueChannel:Boolean = true;

		
		/**
		 * Creates a new RGBDisplacementFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	offsets			Array containing the offsets for each channel in order [redOffsetX, redOffsetY, greenOffsetX, greenOffsetY, blueOffsetX, blueOffsetY]. Defaults to [0, 0, 0, 0, 0, 0].
		 */
		public function RGBDisplacementFX(offsets:Array = null) 
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

				// adjust rect size
				_rect.width = clipRect.width;
				_rect.height = clipRect.height;

				//trace("RGB disp: new BMD", bitmapData.rect)
			}
			
			if (redOffsetX == 0 && redOffsetY == 0 && 
				greenOffsetX == 0 && greenOffsetY == 0 && 
				blueOffsetX == 0 && blueOffsetY == 0 && 
				showRedChannel && showGreenChannel && showBlueChannel) {
				// no offsets && show all channels => do nothing
				//trace("no offsets")
			} else {
				// clear channel bitmapDatas
				_redBMD.fillRect(bitmapData.rect, 0x00000000);
				_greenBMD.fillRect(bitmapData.rect, 0x00000000);
				_blueBMD.fillRect(bitmapData.rect, 0x00000000);
				
				// update offset points
				_redOffset.x = redOffsetX; 			_redOffset.y = redOffsetY;
				_greenOffset.x = greenOffsetX; 		_greenOffset.y = greenOffsetY;
				_blueOffset.x = blueOffsetX; 		_blueOffset.y = blueOffsetY;
				
				// copy RGB channels to respective bitmapDatas with relative offsets
				if (showRedChannel) {
					// update matrix to draw to proper position
					_mat.identity();
					_mat.translate(redOffsetX, redOffsetY);
					
					// update colorTransform
					_colorTransform.redMultiplier = 1;
					_colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 0;
					
					// draw
					_redBMD.draw(bitmapData, _mat, _colorTransform);
				}
				if (showGreenChannel) {
					// update matrix to draw to proper position
					_mat.identity();
					_mat.translate(greenOffsetX, greenOffsetY);
					
					// update colorTransform
					_colorTransform.greenMultiplier = 1;
					_colorTransform.redMultiplier = _colorTransform.blueMultiplier = 0;
					
					// draw
					_greenBMD.draw(bitmapData, _mat, _colorTransform);
				}
				if (showBlueChannel) {
					// update matrix to draw to proper position
					_mat.identity();
					_mat.translate(blueOffsetX, blueOffsetY);
					
					// update colorTransform
					_colorTransform.blueMultiplier = 1;
					_colorTransform.greenMultiplier = _colorTransform.redMultiplier = 0;
					
					// draw
					_blueBMD.draw(bitmapData, _mat, _colorTransform);
				}
				
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
	}

}