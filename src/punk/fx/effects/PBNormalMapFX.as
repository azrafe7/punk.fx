package punk.fx.effects 
{
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	
	/**
	 * Wrapper for Pixel Bender SmartNolrmalMap effect by Jan-C. Frischmuth.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=1817528
	 * 
	 * @author azrafe7
	 */
	public class PBNormalMapFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/SmartNormalMap.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;		
		
		
		/**
		 * Creates a new PBNormalMapFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	amount		strength of the effect (recommended range [0, 5]).
		 * @param	useSobel	wether to use Sobel algorithm.
		 * @param	scaleX		scale to apply horizontally (recommended range [-1, 1]).
		 * @param	scaleX		scale to apply vertically (recommended range [-1, 1]).
		 */
		public function PBNormalMapFX(amount:Number=1, useSobel:Boolean=false, scaleX:Number=1, scaleY:Number=1):void 
		{
			super();
			
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			
			this.amount = amount;
			this.useSobel = useSobel;
			this.scaleX = scaleX;
			this.scaleY = scaleY;
		}
		
		
		/** Strength of the effect (recommended range [0, 5]). */
		public function get amount():Number 
		{
			return shader.data.amount.value[0];
		}
		
		/** @private */
		public function set amount(value:Number):void 
		{
			shader.data.amount.value[0] = value;
		}
		
		/** Wether to use Sobel algorithm. */
		public function get useSobel():Boolean 
		{
			return shader.data.soft_sobel.value[0] == 1;
		}
		
		/** @private */
		public function set useSobel(value:Boolean):void 
		{
			shader.data.soft_sobel.value[0] = (value ? 1 : 0);
		}
		
		/** Scale to apply horizontally (recommended range [-1, 1]). */
		public function get scaleX():Number 
		{
			return shader.data.invert_red.value[0];
		}
		
		/** @private */
		public function set scaleX(value:Number):void 
		{
			value = (value < -1 ? -1 : value > 1 ? 1 : value);
			shader.data.invert_red.value[0] = value;
		}
		
		/** Scale to apply vertically (recommended range [-1, 1]). */
		public function get scaleY():Number 
		{
			return shader.data.invert_green.value[0];
		}
		
		/** @private */
		public function set scaleY(value:Number):void 
		{
			value = (value < -1 ? -1 : value > 1 ? 1 : value);
			shader.data.invert_green.value[0] = value;
		}
	}

}