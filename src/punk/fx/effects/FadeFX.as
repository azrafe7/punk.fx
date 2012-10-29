package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * Fading effect.
	 * 
	 * @author azrafe7
	 */
	public class FadeFX extends FX
	{
		/** @private ColorTransform used for the effect. */
		protected var _colorTransform:ColorTransform = new ColorTransform();

		
		/** Amount of alpha to be used for the effect (in the range [0, 1] where 1 is totally visible). */
		public var alpha:Number;
		
		/** Color tinting to apply. */
		public var color:uint;
		
		/** Set this to false if you want the effect to behave as transparent. */
		public var opaque:Boolean = true;
		
		
		/**
		 * Creates a new FadeFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	alpha		amount of alpha to be used for the effect (in the range [0, 1] where 1 is totally visible).
		 * @param	color		color tinting to apply.
		 * @param	opaque		set this to false if you want the effect to behave as transparent.
		 */
		public function FadeFX(alpha:Number = 0, color:uint = 0xFF000000, opaque:Boolean = true) 
		{
			super();
			
			this.alpha = alpha;
			this.color = color;
			this.opaque = opaque;
		}
			
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			if (opaque) bitmapData.fillRect(clipRect, 0xFFFFFFFF);
			
			_colorTransform.redMultiplier = Number(color >> 16 & 0xFF) / 255;
			_colorTransform.greenMultiplier = Number(color >> 8 & 0xFF) / 255;
			_colorTransform.blueMultiplier = Number(color & 0xFF) / 255;

			_colorTransform.alphaMultiplier = alpha;
			
			bitmapData.colorTransform(clipRect, _colorTransform);

			super.applyTo(bitmapData, clipRect);
		}
	}

}