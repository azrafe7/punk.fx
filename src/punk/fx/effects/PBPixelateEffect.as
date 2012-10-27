package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender Pixelate Effect by RIAstar.
	 * 
	 * @author azrafe7
	 */
	public class PBPixelateEffect extends Effect
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/pixelate.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		/** Shader instance created from the pbj data. */
		public var shader:Shader;
		
		/** ShaderFilter instance created from shader (you can pass this to a FilterEffect). @see FilterEffect */
		public var filter:ShaderFilter;
		
		
		/**
		 * Creates a new PBPixelateEffect with the specified scale.
		 * 
		 * @param	scale		scale factor to be used by the effect.
		 */
		public function PBPixelateEffect(scale:Number=1):void 
		{
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.scale = scale;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, filter);

			super.applyTo(bitmapData, clipRect);
		}
		
		/** Angle at which you wish to draw the halftone image (in degrees). */
		public function get scale():Number 
		{
			return shader.data.size.value[0];
		}
		
		/** @private */
		public function set scale(value:Number):void 
		{
			shader.data.size.value[0] = value;
		}
	}

}