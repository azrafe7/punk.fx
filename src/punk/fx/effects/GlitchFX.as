package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Glitch effect.
	 * 
	 * @author azrafe7
	 */
	public class GlitchFX extends FX
	{
		
		/** @private Rectangle used to slide portions of the image. */
		protected var rect:Rectangle = new Rectangle;

		/** @private Point used to draw slided portions of the image. */
		protected var point:Point = new Point;
		
		
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
				
				var tempBMD:BitmapData = bitmapData.clone();
				
				// width of sliding stripes
				rect.width = clipRect.width;
				rect.y = clipRect.y;
				
				bitmapData.fillRect(clipRect, 0);
			
				for (var y:int = 0; y < clipRect.height; ) {
					// random sliding stripe height
					rect.height = Math.ceil(minHeight + (maxHeight - minHeight) * Math.random());
					if (rect.y + rect.height > clipRect.height) rect.height = clipRect.height - rect.y;
					
					// random sliding stripe x pos
					point.x = clipRect.x + int((Math.random()*2-1) * Math.random() * maxSlide);
					point.y = y;
					
					bitmapData.copyPixels(tempBMD, rect, point);
					
					y += rect.height;
					rect.y += rect.height;
				}
				
				tempBMD.dispose();
				tempBMD = null;
			}
			
			super.applyTo(bitmapData, clipRect);
		}
	}

}