package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	
	/**
	 * Wrapper for Pixel Bender LineSlide effect by Shogo Kimura.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=2266022
	 * 
	 * @author azrafe7
	 */
	public class PBLineSlideFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/LineSlide.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		
		/**
		 * Creates a new PBLineSlideFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	slide			amount of pixels to slide (can be negative).
		 * @param	thickness		thickness of each sliding stripe.
		 * @param	angle			angle of the stripes (in deg).
		 */
		public function PBLineSlideFX(slide:Number=0, thickness:Number=10, angle:Number=0):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.slide = slide;
			this.thickness = thickness;
			this.angle = angle;
		}
		
		/** Amount of pixels to slide (can be negative). */
		public function get slide():Number 
		{
			return shader.data.slide.value[0];
		}
		
		/** @private */
		public function set slide(value:Number):void 
		{
			shader.data.slide.value[0] = value;
		}
		
		/** Thickness of each sliding stripe. */
		public function get thickness():Number
		{
			return shader.data.thickness.value[0];
		}
		
		/** @private */
		public function set thickness(value:Number):void 
		{
			shader.data.thickness.value[0] = value;
		}

		/** Angle of the stripes (in deg). */
		public function get angle():Number
		{
			return shader.data.rotate.value[0] * FP.DEG;
		}
		
		/** @private */
		public function set angle(value:Number):void 
		{
			shader.data.rotate.value[0] = value * FP.RAD;
		}
		
	}

}