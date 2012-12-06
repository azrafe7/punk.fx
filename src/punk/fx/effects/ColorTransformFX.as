package punk.fx.effects 
{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	/**
	 * Wrapper effect for ColorTransform (RGBA multiplication/offset).
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/ColorTransform.html
	 *
	 * @author azrafe7
	 */
	public class ColorTransformFX extends FX
	{
		/** The ColorTranform used by the effect. */
		public var colorTransform:ColorTransform = new ColorTransform;
		
		
		/**
		 * Creates a new ColorTransformFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 *
		 * @param	redMultiplier		value for the red multiplier, in the range from 0 to 1.
		 * @param	greenMultiplier		value for the green multiplier, in the range from 0 to 1.
		 * @param	blueMultiplier		value for the blue multiplier, in the range from 0 to 1.
		 * @param	alphaMultiplier		value for the alpha transparency multiplier, in the range from 0 to 1.
		 * @param	redOffset			offset value for the red color channel, in the range from -255 to 255.
		 * @param	greenOffset			offset value for the green color channel, in the range from -255 to 255.
		 * @param	blueOffset			offset for the blue color channel value, in the range from -255 to 255.
		 * @param	alphaOffset			offset for alpha transparency channel value, in the range from -255 to 255.
		 */
		public function ColorTransformFX(redMultiplier:Number = 1.0, greenMultiplier:Number = 1.0, blueMultiplier:Number = 1.0, alphaMultiplier:Number = 1.0, redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0):void
		{
			super();
			
			this.redMultiplier = redMultiplier;
			this.greenMultiplier = greenMultiplier;
			this.blueMultiplier = blueMultiplier;
			this.alphaMultiplier = alphaMultiplier;
			this.redOffset = redOffset;
			this.greenOffset = greenOffset;
			this.blueOffset = blueOffset;
			this.alphaOffset = alphaOffset;
		}
		
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void 
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			bitmapData.colorTransform(clipRect, colorTransform);
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** Decimal value that is multiplied with the red channel value. */
		public function get redMultiplier():Number 
		{
			return colorTransform.redMultiplier;
		}
		
		/** @private */
		public function set redMultiplier(value:Number):void 
		{
			colorTransform.redMultiplier = value;
		}
		
		/** Decimal value that is multiplied with the green channel value. */
		public function get greenMultiplier():Number 
		{
			return colorTransform.greenMultiplier;
		}
		
		/** @private */
		public function set greenMultiplier(value:Number):void 
		{
			colorTransform.greenMultiplier = value;
		}
		
		/** Decimal value that is multiplied with the blue channel value. */
		public function get blueMultiplier():Number 
		{
			return colorTransform.blueMultiplier;
		}
		
		/** @private */
		public function set blueMultiplier(value:Number):void 
		{
			colorTransform.blueMultiplier = value;
		}
		
		/** Decimal value that is multiplied with the alpha channel value. */
		public function get alphaMultiplier():Number 
		{
			return colorTransform.alphaMultiplier;
		}
		
		/** @private */
		public function set alphaMultiplier(value:Number):void 
		{
			colorTransform.alphaMultiplier = value;
		}

		/**  Number from -255 to 255 that is added to the red channel value after it has been multiplied by the redMultiplier value. */
		public function get redOffset():Number 
		{
			return colorTransform.redOffset;
		}
		
		/** @private */
		public function set redOffset(value:Number):void 
		{
			colorTransform.redOffset = value;
		}

		/**  Number from -255 to 255 that is added to the green channel value after it has been multiplied by the greenMultiplier value. */
		public function get greenOffset():Number 
		{
			return colorTransform.greenOffset;
		}
		
		/** @private */
		public function set greenOffset(value:Number):void 
		{
			colorTransform.greenOffset = value;
		}

		/**  Number from -255 to 255 that is added to the blue channel value after it has been multiplied by the blueMultiplier value. */
		public function get blueOffset():Number 
		{
			return colorTransform.blueOffset;
		}
		
		/** @private */
		public function set blueOffset(value:Number):void 
		{
			colorTransform.blueOffset = value;
		}

		/**  Number from -255 to 255 that is added to the alpha channel value after it has been multiplied by the alphaMultiplier value. */
		public function get alphaOffset():Number 
		{
			return colorTransform.alphaOffset;
		}
		
		/** @private */
		public function set alphaOffset(value:Number):void 
		{
			colorTransform.alphaOffset = value;
		}

		/**  RGB color of the ColorTransform (in the format 0xRRGGBB). */
		public function get color():uint 
		{
			return colorTransform.color;
		}
		
		/** @private */
		public function set color(value:uint):void 
		{
			colorTransform.color = value;
		}
		
		
		/** 
		 * Concatenates the specified otherColorTransform object to the current ColorTransform object and sets the current object 
		 * as the result, which is an additive combination of the two color transformations. 
		 * When you apply the concatenated ColorTransform object, the effect is the same as applying the second color 
		 * transformation after the original color transformation.
		 */
		public function concat(otherColorTransform:*):void 
		{
			if (otherColorTransform is ColorTransform) this.colorTransform.concat(otherColorTransform);
			else if (otherColorTransform is ColorTransformFX) this.colorTransform.concat(otherColorTransform.colorTransform);
			else throw new Error("Parameter must be of type ColorTransform or ColorTransformFX.");
		}
	}

}