package punk.fx.effects
{
	import com.gskinner.geom.ColorMatrix;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;

	/**
	 * Color adjustment effect.
	 * 
	 * Uses the ColorMatrix class from gskinner.
	 * 
	 * @see http://gskinner.com/blog/archives/2007/12/colormatrix_cla.html
	 * 
	 * @author azrafe7
	 */
	public class AdjustFX extends FX
	{

		/** @private ColorMatrix used for color transform calculations */
		protected var _colorMatrix:ColorMatrix = new ColorMatrix();
		
		/** @private filter used for the color transforms */
		protected var _filter:ColorMatrixFilter;

		/** @private brightness value of the effect */
		protected var _brightness:Number;

		/** @private contrast value of the effect */
		protected var _contrast:Number;

		/** @private saturation value of the effect */
		protected var _saturation:Number;

		/** @private hue value of the effect */
		protected var _hue:Number;
		
		
		/**
		 * Creates a new AdjustFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * @param	brightness		brightness value to apply. Must be in the range [-1, 1] (defaults to 0).
		 * @param	contrast		contrast value to apply. Must be in the range [-1, 1] (defaults to 0).
		 * @param	saturation		saturation value to apply. Must be in the range [-1, 1] (defaults to 0).
		 * @param	hue				hue value to apply. Must be in the range [-180, 180] (defaults to 0).
		 */
		public function AdjustFX(brightness:Number = 0, contrast:Number = 0, saturation:Number = 0, hue:Number = 0) 
		{
			super();
			
			this.brightness = brightness;
			this.contrast = contrast;
			this.saturation = saturation;
			this.hue = hue;
			_filter = new ColorMatrixFilter(_colorMatrix);
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			_filter.matrix = _colorMatrix;

			bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, _filter);
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/**
		 * Brightness value to apply. Must be in the range [-1, 1].
		 */
		public function get brightness():Number 
		{
			return _brightness;
		}
		
		/**
		 * @private
		 */
		public function set brightness(value:Number):void 
		{
			_brightness = FP.clamp(value, -1, 1);
			updateColorMatrix();
		}
		
		/**
		 * Contrast value to apply. Must be in the range [-1, 1].
		 */
		public function get contrast():Number 
		{
			return _contrast;
		}
		
		/**
		 * @private
		 */
		public function set contrast(value:Number):void 
		{
			_contrast = FP.clamp(value, -1, 1);
			updateColorMatrix();
		}
		
		/**
		 * Saturation value to apply. Must be in the range [-1, 1].
		 */
		public function get saturation():Number 
		{
			return _saturation;
		}
		
		/**
		 * @private
		 */
		public function set saturation(value:Number):void 
		{
			_saturation = FP.clamp(value, -1, 1);
			updateColorMatrix();
		}
		
		/**
		 * Hue value to apply. Must be in the range [-180, 180].
		 */
		public function get hue():Number 
		{
			return _hue;
		}
		
		/**
		 * @private
		 */
		public function set hue(value:Number):void 
		{
			_hue = FP.clamp(value, -180, 180);
			updateColorMatrix();
		}
		
		/**
		 * Recalculates the color matrix.
		 */
		protected function updateColorMatrix():void 
		{
			_colorMatrix.reset();
			_colorMatrix.adjustColor(_brightness*100, _contrast*100, _saturation*100, _hue);
		}
		
		/**
		 * The ColorMatrix used by the effect.
		 */
		public function get colorMatrix():ColorMatrix 
		{
			return _colorMatrix;
		}

		/**
		 * The ColorMatrixFilter used by the effect.
		 */
		public function get colorMatrixFilter():ColorMatrixFilter
		{
			return _filter;
		}
	}

}