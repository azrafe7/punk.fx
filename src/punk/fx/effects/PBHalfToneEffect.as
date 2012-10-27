package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender HalfTone Effect by SuperKarthik.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=1698153
	 * 
	 * @author azrafe7
	 */
	public class PBHalfToneEffect extends Effect
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/halftone.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		/** Shader instance created from the pbj data. */
		public var shader:Shader;
		
		/** ShaderFilter instance created from shader (you can pass this to a FilterEffect). @see FilterEffect */
		public var filter:ShaderFilter;
		
		
		/**
		 * Creates a new PBHalfToneEffect with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	dotSpacing		spacing between the dots in the grid (recommended range [5, 40]).
		 * @param	angle			angle at which you wish to draw the halftone image (in degrees).
		 * @param	maxDotSize		maximum size of the dots used for the halftone (recommended range [3, 20]).
		 * @param	gamma			gamma correction (recommended range [0.5, 5]). 
		 */
		public function PBHalfToneEffect(dotSpacing:Number=12, angle:Number=45, maxDotSize:Number=7, gamma:Number=1):void 
		{
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.dotSpacing = dotSpacing;
			this.angle = angle;
			this.maxDotSize = maxDotSize;
			this.gamma = gamma;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, filter);

			super.applyTo(bitmapData, clipRect);
		}
		
		/** Angle at which you wish to draw the halftone image (in degrees). */
		public function get angle():Number 
		{
			return shader.data.angle.value[0];
		}
		
		/** @private */
		public function set angle(value:Number):void 
		{
			shader.data.angle.value[0] = value;
		}
		
		/** Spacing between the dots in the grid (recommended range [5, 40]). */
		public function get dotSpacing():Number 
		{
			return shader.data.dot_spacing.value[0];
		}
		
		/** @private */
		public function set dotSpacing(value:Number):void 
		{
			shader.data.dot_spacing.value[0] = value;
		}
		
		/** Maximum size of the dots used for the halftone (recommended range [3, 20]). */
		public function get maxDotSize():Number 
		{
			return shader.data.max_dot_size.value[0];
		}
		
		/** @private */
		public function set maxDotSize(value:Number):void 
		{
			shader.data.max_dot_size.value[0] = value;
		}
		
		/** Gamma correction (recommended range [0.5, 5]). */
		public function get gamma():Number 
		{
			return shader.data.gamma.value[0];
		}
		
		/** @private */
		public function set gamma(value:Number):void 
		{
			shader.data.gamma.value[0] = value;
		}
	}

}