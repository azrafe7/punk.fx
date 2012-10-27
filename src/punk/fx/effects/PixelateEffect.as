package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import punk.fx.FXImage;

	/**
	 * Pixelate Effect.
	 * 
	 * @author azrafe7
	 */
	public class PixelateEffect extends Effect
	{
		
		/** @private matrix used to scale the BitmapData */
		protected var _scaleMatrix:Matrix = new Matrix();

		
		/** Scale factor to be used by the effect. */
		public var scale:Number = 1;
		
		/** Whether to smooth the image when scaling. */
		public var smooth:Boolean = false;
		
		
		/**
		 * Creates a new PixelateEffect with the specified scale.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	scale		scale factor to be used by the effect.
		 */
		public function PixelateEffect(scale:Number = 1) 
		{
			super();
			
			this.scale = scale;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			// exit early if scale == 1
			if (scale != 1.0) {
				
				// only the inverse of scale is needed
				var invScale:Number = 1 / scale;
				
				var tempW:Number = Math.ceil(clipRect.width * invScale);
				//tempW = tempW < 1 ? 1 : tempW;
				var tempH:Number = Math.ceil(clipRect.height * invScale);
				//tempH = tempH < 1 ? 1 : tempH;
				var tempBMD:BitmapData = new BitmapData(tempW, tempH, true, 0);
				
				// scale down (and translate using clipRect position)
				_scaleMatrix.identity();
				_scaleMatrix.translate(-clipRect.x, -clipRect.y);
				_scaleMatrix.scale(invScale, invScale);
				
				tempBMD.draw(bitmapData, _scaleMatrix);
				
				// scale back (and translate back)
				_scaleMatrix.identity();
				_scaleMatrix.scale(clipRect.width/tempW, clipRect.height/tempH);
				_scaleMatrix.translate(clipRect.x, clipRect.y);

				bitmapData.fillRect(clipRect, 0);
				bitmapData.draw(tempBMD, _scaleMatrix, null, null, null, smooth);
				
				tempBMD.dispose();
				tempBMD = null;
			}
			
			super.applyTo(bitmapData, clipRect);
		}
	}

}