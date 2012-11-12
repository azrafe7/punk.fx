package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Glitch effect (random linear disturb).
	 * 
	 * @author azrafe7
	 */
	public class GlitchFX extends FX
	{
		/** @private Temp BitmapData to store the source BMD. */
		protected var _tempBMD:BitmapData;
		
		/** @private Rectangle used to slide portions of the image. */
		protected var _rect:Rectangle = new Rectangle;

		/** @private Point used to draw slided portions of the image. */
		protected var _point:Point = new Point;
		
		
		/** Max amount of x displacement of the sliding stripes. */
		public var maxSlide:Number;
		
		/** Min height of the sliding stripes. */
		public var minHeight:Number;
		
		/** Max height of the sliding stripes. */
		public var maxHeight:Number;
		
		
		/**
		 * Creates a new GlitchFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	maxSlide	max amount of x displacement of the sliding stripes.
		 * @param	maxHeight	max height of the sliding stripes.
		 * @param	minHeight	min height of the sliding stripes.
		 */
		public function GlitchFX(maxSlide:Number = 0, maxHeight:Number = 10, minHeight:Number=5) 
		{
			super();
			
			this.maxSlide = maxSlide;
			this.maxHeight = maxHeight;
			this.minHeight = minHeight;
		}
			
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			if (maxSlide > 0 && (maxHeight - minHeight >= 1)) {
				
				_tempBMD = bitmapData.clone();
				
				// width of sliding stripes
				_rect.width = clipRect.width;
				_rect.y = clipRect.y;
				
				bitmapData.fillRect(clipRect, 0);
			
				for (var y:int = 0; y < clipRect.height; ) {
					// random sliding stripe height
					_rect.height = Math.ceil(minHeight + (maxHeight - minHeight) * Math.random());
					if (_rect.y + _rect.height > clipRect.height) _rect.height = clipRect.height - _rect.y;
					
					// random sliding stripe x pos
					_point.x = clipRect.x + int((Math.random()*2-1) * Math.random() * maxSlide);
					_point.y = y;
					
					bitmapData.copyPixels(_tempBMD, _rect, _point);
					
					y += _rect.height;
					_rect.y += _rect.height;
				}
				
				_tempBMD.dispose();
				_tempBMD = null;
			}
			
			super.applyTo(bitmapData, clipRect);
		}
	}

}