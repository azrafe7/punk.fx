package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender CircleSplash effect by Jerrynet.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&loc=en_us&extid=1550021
	 * 
	 * @author azrafe7
	 */
	public class PBCircleSplashFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/CircleSplash.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		
		/** Circle center will follow this object position (must have x and y properties). */
		public var trackedObj:* = null;
		
		/**
		 * Creates a new PBCircleSplashFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	radius			radius of the circle.
		 * @param	centerX			X position of the circle center.
		 * @param	centerY			Y position of the circle center.
		 */
		public function PBCircleSplashFX(radius:Number=1, centerX:Number=200, centerY:Number=200):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.radius = radius;
			this.centerX = centerX;
			this.centerY = centerY;
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
		
		/** Radius of the circle. */
		public function get radius():Number 
		{
			return shader.data.Radius.value[0];
		}
		
		/** @private */
		public function set radius(value:Number):void 
		{
			shader.data.Radius.value[0] = value;
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
		
	}

}