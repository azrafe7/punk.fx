package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	
	/**
	 * Wrapper for Pixel Bender NormalLight effect by azrafe7.
	 * 
	 * @see https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson6 for info on how this works
	 * 
	 * @author azrafe7
	 */
	public class PBNormalLightFX extends PBBaseFX
	{
		/** Embedded Shader Class. */
		[Embed(source = "pbj/NormalLight.pbj", mimeType = "application/octet-stream")]
		public static var SHADER_DATA:Class;		
		
		/** Whether to calculate a new normalMap every frame automatically. */
		public var autoCalcNormalMap:Boolean;
		
		/** Effect used to calculate the normalMap if autoCalcNormalMap is set to true (you can freely change its parameters). */
		public var normalMapFX:PBNormalMapFX = new PBNormalMapFX;
		
		
		/**
		 * Creates a new PBNormalLightFX with the specified values.
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 *
		 * @see #setProps()
		 * 
		 * @param	normalMap		BitmapData to use as normalMap (pass null to turn autoCalcNormalMap on).
		 * @param	lightColor		color of the light (in 0xRRGGBB format).
		 * @param	lightX			X position of the light (in pixels).
		 * @param	lightY			Y position of the light (in pixels).
		 * @param	lightIntensity	intensity of the light (recommended range [0, 10]).
		 */
		public function PBNormalLightFX(normalMap:BitmapData=null, lightColor:uint=0xFFFFFF, lightX:Number=0, lightY:Number=0, lightIntensity:Number=1.85):void 
		{
			super();
			
			shader = new Shader(new SHADER_DATA);
			filter = new ShaderFilter(shader);
			
			// init shader values
			this.normalMap = normalMap;
			this.lightColor = lightColor;
			this.lightX = lightX;
			this.lightY = lightY;
			this.lightIntensity = lightIntensity;
			this.lightZ = .075;
			this.invertGreen = false;
			this.ambientColor = 0xCCCCCC;
			this.ambientIntensity = .3;
			setFallOff(.4, 3, 20);
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			shader.data.inputSize.value[0] = clipRect.width;
			shader.data.inputSize.value[1] = clipRect.height;
			
			// use normalMapFX to auto calc a new normalMap if needed
			if (autoCalcNormalMap) {
				var _normalMapBMD:BitmapData = bitmapData.clone();
				normalMapFX.applyTo(_normalMapBMD, clipRect);
				shader.data.normalMap.input = _normalMapBMD;
			}
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** BitmapData to use as normalMap (pass null to turn autoCalcNormalMap on). */
		public function get normalMap():BitmapData
		{
			return shader.data.normalMap.input;
		}
		
		/** @private */
		public function set normalMap(value:BitmapData):void 
		{
			this.autoCalcNormalMap = (value == null);
			if (value) shader.data.normalMap.input = value;
		}
		
		/** X position of the light (in pixels). */
		public function get lightX():Number
		{
			return shader.data.lightPos.value[0];
		}
		
		/** @private */
		public function set lightX(value:Number):void
		{
			shader.data.lightPos.value[0] = value;
		}
		
		/** Y position of the light (in pixels). */
		public function get lightY():Number
		{
			return shader.data.lightPos.value[1];
		}
		
		/** @private */
		public function set lightY(value:Number):void
		{
			shader.data.lightPos.value[1] = value;
		}
		
		/** Color of the light (in 0xRRGGBB format). */
		public function get lightColor():uint 
		{
			var lightRGB:Array = shader.data.lightColor.value;
			return ((lightRGB[0] * 255) << 16 | (lightRGB[1] * 255) << 8 | lightRGB[2] * 255);
		}
		
		/** @private */
		public function set lightColor(value:uint):void 
		{
			var r:Number = (value >> 16) & 0xFF;
			var g:Number = (value >> 8) & 0xFF;
			var b:Number = value & 0xFF;
			shader.data.lightColor.value[0] = r / 255;
			shader.data.lightColor.value[1] = g / 255;
			shader.data.lightColor.value[2] = b / 255;
		}
		
		/** Default Z-value of the light (recommended range [0, 1]). */
		public function get lightZ():Number 
		{
			return shader.data.lightZ.value[0];
		}
		
		/** @private */
		public function set lightZ(value:Number):void 
		{
			shader.data.lightZ.value[0] = value;
		}
		
		/** Intensity of the light (recommended range [0, 10]). */
		public function get lightIntensity():Number 
		{
			return shader.data.lightIntensity.value[0];
		}
		
		/** @private */
		public function set lightIntensity(value:Number):void 
		{
			shader.data.lightIntensity.value[0] = value;
		}
		
		/** Whether to invert the green component. */
		public function get invertGreen():Boolean 
		{
			return shader.data.invertGreen.value[0] > 0;
		}
		
		/** @private */
		public function set invertGreen(value:Boolean):void 
		{
			shader.data.invertGreen.value[0] = (value ? 1 : 0);
		}
		
		/** Ambient light color (in 0xRRGGBB format). */
		public function get ambientColor():uint 
		{
			var ambientRGB:Array = shader.data.ambientColor.value;
			return ((ambientRGB[0] * 255) << 16 | (ambientRGB[1] * 255) << 8 | ambientRGB[2] * 255);
		}
		
		/** @private */
		public function set ambientColor(value:uint):void 
		{
			var r:Number = (value >> 16) & 0xFF;
			var g:Number = (value >> 8) & 0xFF;
			var b:Number = value & 0xFF;
			shader.data.ambientColor.value[0] = r / 255;
			shader.data.ambientColor.value[1] = g / 255;
			shader.data.ambientColor.value[2] = b / 255;
		}
		
		/** Intensity of the ambient light (recommended range [0, 10]). */
		public function get ambientIntensity():Number 
		{
			return shader.data.ambientIntensity.value[0];
		}
		
		/** @private */
		public function set ambientIntensity(value:Number):void 
		{
			shader.data.ambientIntensity.value[0] = value;
		}
		
		/** Light fall-off in the three directions. */
		public function setFallOff(x:Number, y:Number, z:Number):void 
		{
			fallOffX = x;
			fallOffY = y;
			fallOffZ = z;
		}

		/** Light fall-off in the x direction. */
		public function get fallOffX():Number 
		{
			return shader.data.fallOff.value[0];
		}

		/** @private */
		public function set fallOffX(value:Number):void
		{
			shader.data.fallOff.value[0] = value;
		}
		
		/** Light fall-off in the y direction. */
		public function get fallOffY():Number 
		{
			return shader.data.fallOff.value[1];
		}

		/** @private */
		public function set fallOffY(value:Number):void
		{
			shader.data.fallOff.value[1] = value;
		}
		
		/** Light fall-off in the z direction. */
		public function get fallOffZ():Number 
		{
			return shader.data.fallOff.value[2];
		}

		/** @private */
		public function set fallOffZ(value:Number):void
		{
			shader.data.fallOff.value[2] = value;
		}
	}

}