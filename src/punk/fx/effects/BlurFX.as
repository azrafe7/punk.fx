package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;

	/**
	 * Blurring effect.
	 * 
	 * @author azrafe7
	 */
	public class BlurFX extends FX
	{
		
		/** @private filter used for the blur effect */
		protected var _filter:BlurFilter = new BlurFilter();
		
		/** @private Blur factor of the effect (assigned to both blurX and blurY) */
		protected var _blur:Number;

		
		/** Amount of blur in the x direction */
		public var blurX:Number;

		/** Amount of blur in the y direction */
		public var blurY:Number;

		/** Quality of the blur effect (in the range [1, 3] where 3 means highest quality) */
		public var quality:Number = 1;
		
		
		/**
		 * Creates a new BlurFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	blur		blur factor of the effect.
		 * @param	quality		quality of the blur effect (in the range [1, 3] where 3 means highest quality).
		 */
		public function BlurFX(blur:Number = 0, quality:Number = 1) 
		{
			super();
			
			this.blur = blur;
			this.quality = quality;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			_filter.blurX = blurX;
			_filter.blurY = blurY;
			_filter.quality = quality;
			
			bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, _filter);

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