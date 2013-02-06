package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;

	/**
	 * Glitch effect (random linear disturb).
	 * 
	 * Based on PhotonStorm's idea @see http://www.photonstorm.com/flixel-power-tools/flxspecialfx
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
		
		/** Callback function that computes how much to slide the x based on yPercent, height, maxSlide and time
		 * (signature: <code>function(yPercent:Number, rect:Rectangle, maxSlide:Number, time:Number):Number </code>). 
		 * @see #GlitchFX.sineWave()
		 */
		public var slideFunction:Function = null;
		
		/** Total elapsed time (passed to slideFunction). */
		public static var totalTime:Number = 0;
		
		/**
		 * Creates a new GlitchFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	maxSlide		max amount of x displacement of the sliding stripes.
		 * @param	maxHeight		max height of the sliding stripes.
		 * @param	minHeight		min height of the sliding stripes.
		 * @param	slideFunction	optional sliding function.
		 */
		public function GlitchFX(maxSlide:Number = 0, maxHeight:Number = 10, minHeight:Number=5, slideFunction:Function = null) 
		{
			super();
			
			this.maxSlide = maxSlide;
			this.maxHeight = maxHeight;
			this.minHeight = minHeight;
			
			if (slideFunction != null && slideFunction is Function) this.slideFunction = slideFunction;
		}
			
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			if (maxSlide > 0 && (maxHeight - minHeight >= 0)) {
				
				_tempBMD = bitmapData.clone();
				
				// width of sliding stripes
				_rect.width = clipRect.width;
				_rect.y = clipRect.y;
				
				bitmapData.fillRect(clipRect, 0);
			
				for (var y:int = 0; y < clipRect.height; ) {
					// random sliding stripe height
					_rect.height = Math.ceil(.5 + minHeight + (maxHeight - minHeight) * Math.random());
					
					if (_rect.y + _rect.height > clipRect.height) _rect.height = clipRect.height - _rect.y;
					
					// slide the stripe horizontally (applying slideFunction if defined or go random)
					if (slideFunction != null && slideFunction is Function) {
						_point.x = clipRect.x + int(slideFunction(y/clipRect.height, clipRect, maxSlide, totalTime));
					} else {
						_point.x = clipRect.x + int((Math.random() * 2 - 1) * Math.random() * maxSlide);
					}
					_point.y = y;
					
					bitmapData.copyPixels(_tempBMD, _rect, _point);
					
					y += _rect.height;
					_rect.y += _rect.height;
				}
				
				_tempBMD.dispose();
				_tempBMD = null;
			}
			
			totalTime += FP.elapsed;
			super.applyTo(bitmapData, clipRect);
		}
		
		/**
		 * Example of slideFunction that simulates a sine wave displacement.
		 * 
		 * @param	yPercent	value of y being processed (in percent of clipRect.height).
		 * @param	rect		rectangle of the image being processed.
		 * @param	maxSlide	max horizontal slide assigned to the effect.
		 * @param	time		total elapsed time.
		 * 
		 * @return the amount of pixels to slide for the currently processed strip.
		 */
		public static function sineWave(yPercent:Number, rect:Rectangle, maxSlide:Number, time:Number):Number 
		{
			// obviously this could be optimized by precomputing a vector of values beforehand
			// but I'll leave it as is to show how the parameters can be used
			return Math.sin((yPercent - time * .2) * (Math.PI * 2) * 2) * maxSlide;
		}
	}

}