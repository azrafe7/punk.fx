package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	
	/**
	 * Wrapper for Pixel Bender Dot effect by Shogo Kimura.
	 * 
	 * @see http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&extid=2277525
	 * 
	 * @author azrafe7
	 */
	public class PBDotFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/Dot.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;
		

		/**
		 * Creates a new PBDotFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	circleSize		size of the circle.
		 * @param	cellWidth		width of the grid's cells.
		 * @param	cellHeight		height of the grid's cells.
		 * @param	angle			angle of the grid (in deg).
		 */
		public function PBDotFX(circleSize:Number=8, cellWidth:Number=10, cellHeight:Number=10, angle:Number=0):void 
		{
			super();

			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			this.circleSize= circleSize;
			this.cellWidth = cellWidth;
			this.cellHeight = cellHeight;
			this.angle = angle;
		}
		
		/** Size of the circle. */
		public function get circleSize():Number 
		{
			return shader.data.circle_size.value[0];
		}
		
		/** @private */
		public function set circleSize(value:Number):void 
		{
			shader.data.circle_size.value[0] = value;
		}
		
		/** Width of the grid's cells. */
		public function get cellWidth():Number 
		{
			return shader.data.size.value[0];
		}
		
		/** @private */
		public function set cellWidth(value:Number):void 
		{
			shader.data.size.value[0] = value;
		}
		
		/** Height of the grid's cells. */
		public function get cellHeight():Number 
		{
			return shader.data.size.value[1];
		}
		
		/** @private */
		public function set cellHeight(value:Number):void 
		{
			shader.data.size.value[1] = value;
		}
		
		/** Angle of the cells (in deg). */
		public function get angle():Number
		{
			return shader.data.rotate.value[0] * FP.DEG;
		}
		
		/** @private */
		public function set angle(value:Number):void 
		{
			shader.data.rotate.value[0] = value * FP.RAD;
		}
		
		/** X offset of the grid's cells. */
		public function get offsetX():Number 
		{
			return shader.data.start.value[0];
		}
		
		/** @private */
		public function set offsetX(value:Number):void 
		{
			shader.data.start.value[0] = value;
		}
		
		/** Y offset of the grid's cells. */
		public function get offsetY():Number 
		{
			return shader.data.start.value[1];
		}
		
		/** @private */
		public function set offsetY(value:Number):void 
		{
			shader.data.start.value[1] = value;
		}

		/** Circle glow (in the range [0, 1]). */
		public function get glow():Number 
		{
			return shader.data.gradation.value[0];
		}
		
		/** @private */
		public function set glow(value:Number):void 
		{
			shader.data.gradation.value[0] = value;
		}
	}

}