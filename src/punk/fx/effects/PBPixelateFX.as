package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender Pixelate effect by RIAstar.
	 * 
	 * @author azrafe7
	 */
	public class PBPixelateFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/pixelate.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		
		/**
		 * Creates a new PBPixelateFX with the specified scale.
		 * 
		 * @param	scale		scale factor to be used by the effect.
		 */
		public function PBPixelateFX(scale:Number=1):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.scale = scale;
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