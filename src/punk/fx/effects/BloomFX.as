package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;

	/**
	 * Blooming effect.
	 * 
	 * @see http://philippseifried.com/blog/2011/07/30/real-time-bloom-effects-in-as3/
	 * 
	 * @author azrafe7
	 */
	public class BloomFX extends FX
	{
		
		/** @private filter used for the blur effect */
		protected var _filter:BlurFilter = new BlurFilter();

		/** @private BitmapData used for thresholding */
		protected var _thresholdBMD:BitmapData;

		/** @private Blur factor of the effect (assigned to both blurX and blurY) */
		protected var _blur:Number;

		
		/** Amount of blur in the x direction */
		public var blurX:Number;

		/** Amount of blur in the y direction */
		public var blurY:Number;

		/** Threshold level to use before the blur */
		public var threshold:uint;

		/** Quality of the blur effect (in the range [1, 3] where 3 means highest quality) */
		public var quality:int = 1;
		
		
		/**
		 * Creates a new BloomFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	blur		blur factor of the effect.
		 * @param	threshold	threshold level to use before the blur (in the range [0, 255]).
		 * @param	quality		quality of the blur effect (in the range [1, 3] where 3 means highest quality).
		 */
		public function BloomFX(blur:Number = 0, threshold:uint = 255, quality:int = 1) 
		{
			super();
			
			this.blur = blur;
			this.threshold = threshold;
			this.quality = quality;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			var _threshold:uint = 0xFF << 24 | threshold << 16 | threshold << 8 | threshold;
			
			_filter.blurX = blurX;
			_filter.blurY = blurY;
			_filter.quality = quality;

			// apply filter only if threshold is < 255
			if (threshold < 255) {
				// apply blur to thresholded data
				_thresholdBMD = new BitmapData(clipRect.width, clipRect.height, true, 0xFF000000);
				_thresholdBMD.threshold(bitmapData, clipRect, FP.zero, "<=", _threshold, 0x00000000, 0x00FFFFFF, true);
				_thresholdBMD.applyFilter(_thresholdBMD, _thresholdBMD.rect, FP.zero, _filter);
				
				// update matrix to draw to proper position
				_mat.identity();
				_mat.translate(clipRect.x, clipRect.y);
				
				bitmapData.draw(_thresholdBMD, _mat, null, BlendMode.ADD);
				
				_thresholdBMD.dispose();
				_thresholdBMD = null;
			}
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** Blur factor of the effect (assigned to both blurX and blurY) */
		public function get blur():Number 
		{
			return _blur;
		}
		
		/** @private */
		public function set blur(value:Number):void 
		{
			_blur = blurX = blurY = value;
		}
	}

}