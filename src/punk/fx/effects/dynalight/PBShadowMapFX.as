package punk.fx.effects.dynalight 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import punk.fx.effects.PBBaseFX;
	
	/**
	 * Wrapper for Pixel Bender ShadowMap effect (used internally by DynaLightFX).
	 * 
	 * @see DynaLightFX
	 * 
	 * Inspired by code from:
	 * @see http://www.catalinzima.com/2010/07/my-technique-for-the-shader-based-dynamic-2d-shadows/
	 * @see http://wonderfl.net/c/foPH
	 * 
	 * @author azrafe7
	 */
	public class PBShadowMapFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "../pbj/ShadowMap - multi opt.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;		
		
		/** Vector containing the 3 lights used by the effect. */
		public var lights:Vector.<Light>;
		
		
		/**
		 * Creates a new PBShadowMapFX with the specified values.
		 * 
		 * Generates a shadow map given a reducedDistanceMap and
		 * light sources properties.
		 * 
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	reducedDistanceMap		reduced distance map.
		 * @param	lightX					X position of the light (in pixels).
		 * @param	lightY					Y position of the light (in pixels).
		 * @param	lightRadius				radius of the light (in pixels).
		 * @param	penetration				penetration of light (in percent of lightRadius).
		 * @param	transparent				whether to use alpha transparency in the darkness.
		 */
		public function PBShadowMapFX(reducedDistanceMap:BitmapData, lightX:Number=0, lightY:Number=0, lightRadius:Number=256, penetration:Number=0, transparent:Boolean=false):void 
		{
			super();
			
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			
			this.reducedDistanceMap = reducedDistanceMap;

			lights = new Vector.<Light>;
			for (var i:int = 0; i < 3; ++i) lights.push(new Light(this, i));
			lights.fixed = true;
			
			lights[0].setProps({x: lightX, y: lightY, radius: lightRadius, penetration: penetration, transparent: transparent});
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			shader.data.inputSize.value[0] = clipRect.width;
			shader.data.inputSize.value[1] = clipRect.height;
			
			super.applyTo(bitmapData, clipRect);
		}
		
		
		/** Number of active lights. */
		public function get activeLights():int 
		{
			return lights[0].active + lights[1].active + lights[2].active;
		}

		/** Reduced distance map. */
		public function get reducedDistanceMap():BitmapData
		{
			return shader.data.reducedDistanceMap.input;
		}
		
		/** @private */
		public function set reducedDistanceMap(value:BitmapData):void
		{
			shader.data.reducedDistanceMap.input = value;
		}
	}
}
