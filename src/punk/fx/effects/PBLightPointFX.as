package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender LightPoint effect by John Engler.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=1737524
	 * 
	 * @author azrafe7
	 */
	public class PBLightPointFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/SimplePointLight.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		/** Circle center will follow this object position (must have x and y properties). */
		public var trackedObj:* = null;
		
		/**
		 * Creates a new PBLightPointFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	centerX				X position of the circle center.
		 * @param	centerY				Y position of the circle center.
		 * @param	attenuationDelta	light attenuation delta.
		 */
		public function PBLightPointFX(radius:Number=1, centerX:Number=200, centerY:Number=200):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.centerX = centerX;
			this.centerY = centerY;
			this.attenuationDelta = attenuationDelta;
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
		
		/** Light attenuation delta. */
		public function get attenuationDelta():Number 
		{
			return shader.data.attenuationDelta.value[0];
		}
		
		/** @private */
		public function set attenuationDelta(value:Number):void 
		{
			shader.data.attenuationDelta.value[0] = value;
		}
		
		/** Light attenuation speed. */
		public function get attenuationSpeed():Number 
		{
			return shader.data.attenuationSpeed.value[0];
		}
		
		/** @private */
		public function set attenuationSpeed(value:Number):void 
		{
			shader.data.attenuationSpeed.value[0] = value;
		}
		
		/** Light attenuation decay. */
		public function get attenuationDecay():Number 
		{
			return shader.data.attenuationDecay.value[0];
		}
		
		/** @private */
		public function set attenuationDecay(value:Number):void 
		{
			shader.data.attenuationDecay.value[0] = value;
		}
		
	}

}