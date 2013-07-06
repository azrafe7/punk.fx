package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender RadialFocus effect (used internally by DynaLightFX).
	 * 
	 * @see DynaLightFX
	 * 
	 * Inspired by code from:
	 * @see http://www.catalinzima.com/2010/07/my-technique-for-the-shader-based-dynamic-2d-shadows/
	 * @see http://wonderfl.net/c/foPH
	 * 
	 * @author azrafe7
	 */
	public class PBRadialFocusFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/RadialFocus.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;		
		
		
		/**
		 * Creates a new PBRadialFocusFX with the specified values.
		 * 
		 * Applies a kind of radial blur to the input image.
		 * 
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	centerX			X center of the effect (in pixels).
		 * @param	centerY			Y center of the effect (in pixels).
		 * @param	scale			scale factor of the effect.
		 * @param	threshold		distance threshold (in pixels).
		 */
		public function PBRadialFocusFX(centerX:Number=0, centerY:Number=0, scale:Number=.2, threshold:Number=5):void 
		{
			super();
			
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			
			this.centerX = centerX;
			this.centerY = centerY;
			this.scale = scale;
			this.threshold = threshold;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			shader.data.inputSize.value[0] = clipRect.width;
			shader.data.inputSize.value[1] = clipRect.height;
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** X center of the effect (in pixels). */
		public function get centerX():Number
		{
			return shader.data.center.value[0];
		}
		
		/** @private */
		public function set centerX(value:Number):void
		{
			shader.data.center.value[0] = value;
		}
		
		/** Y center of the effect (in pixels). */
		public function get centerY():Number
		{
			return shader.data.center.value[1];
		}
		
		/** @private */
		public function set centerY(value:Number):void
		{
			shader.data.center.value[1] = value;
		}

		/** Scale factor of the effect. */
		public function get scale():Number
		{
			return shader.data.scaleFactor.value[0];
		}
		
		/** @private */
		public function set scale(value:Number):void
		{
			shader.data.scaleFactor.value[0] = value;
		}

		/** Threshold distance (in pixels). */
		public function get threshold():Number
		{
			return shader.data.threshold.value[0];
		}
		
		/** @private */
		public function set threshold(value:Number):void
		{
			shader.data.threshold.value[0] = value;
		}
	}
}