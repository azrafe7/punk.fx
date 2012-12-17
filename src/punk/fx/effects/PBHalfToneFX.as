package punk.fx.effects 
{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import net.flashpunk.FP;
	
	/**
	 * Wrapper for Pixel Bender HalfTone effect by SuperKarthik.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=1698153
	 * 
	 * @author azrafe7
	 */
	public class PBHalfToneFX extends PBBaseFX
	{
		/** @private */
		protected var _maskBMD:BitmapData;
		
		/** Embedded Shader Class. */
		[Embed(source = "pbj/HalfTone.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;		
		
		/** Whether to use a draw mask. */
		public var useDrawMask:Boolean = false;
		
		/**
		 * Creates a new PBHalfToneFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	dotSpacing		spacing between the dots in the grid (recommended range [5, 40]).
		 * @param	angle			angle at which you wish to draw the halftone image (in degrees).
		 * @param	maxDotSize		maximum size of the dots used for the halftone (recommended range [3, 20]).
		 * @param	gamma			gamma correction (recommended range [0.5, 5]). 
		 */
		public function PBHalfToneFX(dotSpacing:Number=12, angle:Number=45, maxDotSize:Number=7, gamma:Number=1):void 
		{
			super();
			
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
			
			// setup the draw mask, creating a new bitmapData if the current one is too small
			if (useDrawMask) {
				if (!_maskBMD || _maskBMD.rect.width < clipRect.width || _maskBMD.rect.height < clipRect.height) {			
					_maskBMD = new BitmapData(clipRect.width, clipRect.height, true, 0);
				}
				_maskBMD.fillRect(_maskBMD.rect, 0);
				_maskBMD.threshold(bitmapData, clipRect, FP.zero, ">", 0x00000000, 0xFF000000, 0xFFFFFFFF);
			}
			
			super.applyTo(bitmapData, clipRect);
			
			if (useDrawMask) bitmapData.copyPixels(bitmapData, clipRect, clipRect.topLeft, _maskBMD, clipRect.topLeft);
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