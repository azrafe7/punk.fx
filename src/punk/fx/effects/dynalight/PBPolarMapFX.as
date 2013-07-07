package punk.fx.effects.dynalight 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import punk.fx.effects.PBBaseFX;
	
	/**
	 * Wrapper for Pixel Bender PolarMap effect (used internally by DynaLightFX).
	 * 
	 * @see DynaLightFX
	 * 
	 * Inspired by code from:
	 * @see http://www.catalinzima.com/2010/07/my-technique-for-the-shader-based-dynamic-2d-shadows/
	 * @see http://wonderfl.net/c/foPH
	 * 
	 * @author azrafe7
	 */
	public class PBPolarMapFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "../pbj/PolarMap - multi opt.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;		
		
		/** Vector containing the 3 center points used by the effect. */
		public var centerPoints:Vector.<CenterPoint>;
		
		/**
		 * Creates a new PBPolarMapFX with the specified values.
		 * 
		 * Converts an image to polar coordinates to indicate the prossimity to 
		 * the specified center points (the nearer the brighter) and radius fall-off.
		 * 
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	centerX				X position of the 1st center point (in pixels).
		 * @param	centerY				Y position of the 1st center point (in pixels).
		 * @param	radius				cut-off radius of the circle positioned at the 1st center point (in pixels).
		 * @param	useGrayScale		whether to compute the result in gray scale.
		 */
		public function PBPolarMapFX(centerX:Number=0, centerY:Number=0, radius:Number=256, useGrayScale:Boolean=true):void 
		{
			super();
			
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			
			centerPoints = new Vector.<CenterPoint>;
			for (var i:int = 0; i < 3; ++i) centerPoints.push(new CenterPoint(this, i));
			centerPoints.fixed = true;
			
			centerPoints[0].setProps({x: centerX, y: centerY, radius: radius});
			this.useGrayScale = useGrayScale;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			shader.data.inputSize.value[0] = clipRect.width;
			shader.data.inputSize.value[1] = clipRect.height;
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** Number of active center points. */
		public function get activeCenterPoints():int 
		{
			return centerPoints[0].active + centerPoints[1].active + centerPoints[2].active;
		}

		/** Whether to compute the result in gray scale. */
		public function get useGrayScale():Boolean
		{
			return shader.data.useGrayScale.value[0] != 0;
		}
		
		/** @private */
		public function set useGrayScale(value:Boolean):void
		{
			shader.data.useGrayScale.value[0] = value ? 1 : 0;
		}
	}
}