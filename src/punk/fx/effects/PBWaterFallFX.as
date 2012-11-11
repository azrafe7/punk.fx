package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender WaterFall effect by Kevin Goldsmith.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=1603519
	 * 
	 * @author azrafe7
	 */
	public class PBWaterFallFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/WaterFall.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		/** Direction of the water fall effect from top. */
		public static const TOP:int = 0;
		
		/** Direction of the water fall effect from bottom. */
		public static const BOTTOM:int = 1;
		
		/** Direction of the water fall effect from left. */
		public static const LEFT:int = 2;
		
		/** Direction of the water fall effect from right. */
		public static const RIGHT:int = 3;
		
		
		/**
		 * Creates a new PBWaterFallFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	percent			percent of effect to apply (in the range [0, 1]).
		 * @param	direction		direction of the effect (one of PBWaterFallFX.TOP, PBWaterFallFX.BOTTOM, PBWaterFallFX.LEFT, PBWaterFallFX.RIGHT).
		 */
		public function PBWaterFallFX(percent:Number=0, direction:int=PBWaterFallFX.TOP):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.percent = percent;
			this.direction = direction;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void 
		{
			// set imageW and imageH on the shader
			shader.data.imageW.value[0] = clipRect ? clipRect.width : bitmapData.rect.width;
			shader.data.imageH.value[0] = clipRect ? clipRect.height : bitmapData.rect.height;
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** Percent of effect to apply (in the range [0, 1]). */
		public function get percent():Number 
		{
			return shader.data.percent.value[0];
		}
		
		/** @private */
		public function set percent(value:Number):void 
		{
			shader.data.percent.value[0] = value;
		}
		
		/** Direction of the effect (one of PBWaterFallFX.TOP, PBWaterFallFX.BOTTOM, PBWaterFallFX.LEFT, PBWaterFallFX.RIGHT). */
		public function get direction():int
		{
			return shader.data.direction.value[0];
		}
		
		/** @private */
		public function set direction(value:int):void 
		{
			shader.data.direction.value[0] = value % 4;
		}
		
	}

}