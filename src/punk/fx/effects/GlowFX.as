package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	/**
	 * Glowing effect.
	 * 
	 * @author azrafe7
	 */
	public class GlowFX extends FX
	{
		
		/** @private filter used for the glow effect */
		protected var _filter:GlowFilter = new GlowFilter();

		
		/** Blur factor of the effect */
		public var blur:Number;

		/** Amount of blur in the x direction (gets multiplied by the blur factor) */
		public var blurX:Number = 1;

		/** Amount of blur in the y direction (gets multiplied by the blur factor) */
		public var blurY:Number = 1;

		/** Quality of the blur effect (in the range [1, 3] where 3 means highest quality) */
		public var quality:Number = 1;

		/** Color of the effect. */
		public var color:uint;
		
		/** Strength of the effect. */
		public var strength:Number = 0;
		
		/** Whether the glowing must be applied to the inside of the image. */
		public var inner:Boolean = false;
		
		/** Whether the image must be cut out. */
		public var knockout:Boolean = false;
		
		
		/**
		 * Creates a new GlowFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	blur		blur factor of the effect.
		 * @param	color		color of the effect.
		 * @param	strength	strenght value of the effect.
		 * @param	quality		quality of the blur effect (in the range [1, 3] where 3 means highest quality).
		 * @param	inner		whether the glowing must be applied to the inside of the image.
		 * @param	knockout	whether the image must be cut out.
		 */
		public function GlowFX(blur:Number = 0, color:uint = 0xffffff, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false) 
		{
			super();
			
			this.blur = blur;
			this.color = color;
			this.strength = strength;
			this.quality = quality;
			this.inner = inner;
			this.knockout = knockout;
		}

		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			_filter.blurX = _filter.blurY = blur;
			_filter.color = color;
			_filter.strength = strength;
			_filter.quality = quality;
			_filter.inner = inner;
			_filter.knockout = knockout;

			if (bitmapData.transparent) {
				bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, _filter);
			} else {
				//throw new Error("Cannot apply this effect to a non-transparent BitmapData.");
			}

			super.applyTo(bitmapData, clipRect);
		}
		
	}

}