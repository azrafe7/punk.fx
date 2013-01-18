package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender Pixelate effect by azrafe7.
	 * 
	 * @author azrafe7
	 */
	public class PBPixelateFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/pixelate.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		
		/**
		 * Creates a new PBPixelateFX with the specified scale and pivot values.
		 * 
		 * @param	scale		scale factor to be used by the effect.
		 * @param	pivotX		x position of pivot in percent of image size (default to 50.0).
		 * @param	pivotY		y position of pivot in percent of image size (default to 50.0).
		 */
		public function PBPixelateFX(scale:Number=1, pivotX:Number=50.0, pivotY:Number=50.0):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.scale = scale;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void 
		{
			// set imageSize on the shader
			shader.data.imageSize.value[0] = clipRect ? clipRect.width : bitmapData.rect.width;
			shader.data.imageSize.value[1] = clipRect ? clipRect.height : bitmapData.rect.height;
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** Scale factor. */
		public function get scale():Number 
		{
			return shader.data.scale.value[0];
		}
		
		/** @private */
		public function set scale(value:Number):void 
		{
			shader.data.scale.value[0] = value;
		}

		/** X position of pivot in percent of image size. */
		public function get pivotX():Number 
		{
			return shader.data.pivot.value[0];
		}
		
		/** @private */
		public function set pivotX(value:Number):void 
		{
			shader.data.pivot.value[0] = value;
		}

		/** Y position of pivot in percent of image size. */
		public function get pivotY():Number 
		{
			return shader.data.pivot.value[1];
		}
		
		/** @private */
		public function set pivotY(value:Number):void 
		{
			shader.data.pivot.value[1] = value;
		}
	}

}