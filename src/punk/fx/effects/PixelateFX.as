package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Pixelate effect.
	 * 
	 * @author azrafe7
	 */
	public class PixelateFX extends FX
	{
		
		/** @private matrix used to scale the BitmapData */
		protected var _scaleMatrix:Matrix = new Matrix();

		
		/** Scale factor to be used by the effect. */
		public var scale:Number = 1;
		
		/** Whether to smooth the image when scaling. */
		public var smooth:Boolean = false;
		
		
		/**
		 * Creates a new PixelateFX with the specified scale.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	scale		scale factor to be used by the effect.
		 */
		public function PixelateFX(scale:Number = 1) 
		{
			super();
			
			this.scale = scale;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			// exit early if scale <= 1
			if (scale > 1.0) {
				
				// only the inverse of scale is needed
				var invScale:Number = 1 / scale;
				
				var tempW:Number = Math.ceil(clipRect.width * invScale);
				var tempH:Number = Math.ceil(clipRect.height * invScale);
				var tempBMD:BitmapData = new BitmapData(tempW, tempH, true, 0);
				
				// offsets != 0 if clipRect is not an integer multiple of scale
				var offsetX:Number = (scale - clipRect.width % scale) / 2;
				var offsetY:Number = (scale - clipRect.height % scale) / 2;
				
				// scale down (and translate using clipRect position)
				_scaleMatrix.identity();
				_scaleMatrix.translate(-clipRect.x + offsetX, -clipRect.y + offsetY);
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