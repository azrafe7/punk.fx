package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender ZoomBlur effect by Ryan Phelan.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&loc=en_us&extid=1698058
	 * 
	 * @author azrafe7
	 */
	public class PBZoomBlurFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/ZoomBlur.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		/** Circle center will follow this object position (must have x and y properties). */
		public var trackedObj:* = null;
		
		/**
		 * Creates a new PBZoomBlurFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	centerX			X position of the circle center.
		 * @param	centerY			Y position of the circle center.
		 * @param	amount			amount of effect to apply (recommended range [0.0, 0.5]).
		 */
		public function PBZoomBlurFX(centerX:Number=200, centerY:Number=200, amount:Number=1):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.centerX = centerX;
			this.centerY = centerY;
			this.amount = amount;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void 
		{
			if (trackedObj) {
				centerX = trackedObj.x;
				centerY = trackedObj.y;
			}
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** X position of the circle center. */
		public function get centerX():Number 
		{
			return shader.data.center.value[0];
		}
		
		/** @private */
		public function set centerX(value:Number):void 
		{
			shader.data.center.value[0] = value;
		}
		
		/** Y position of the circle center. */
		public function get centerY():Number 
		{
			return shader.data.center.value[1];
		}
		
		/** @private */
		public function set centerY(value:Number):void 
		{
			shader.data.center.value[1] = value;
		}
		
		/** Amount of effect to apply (recommended range [0.0, 0.5]). */
		public function get amount():Number 
		{
			return shader.data.amount.value[0];
		}
		
		/** @private */
		public function set amount(value:Number):void 
		{
			shader.data.amount.value[0] = value;
		}
		
	}

}