package punk.fx.effects
{
	import flash.display.BlendMode;
	import punk.fx.effects.dynalight.*;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import punk.fx.lists.FXList;

	/**
	 * Dynamic lighting/shadowing effect.
	 * 
	 * Wraps functionality from multiple effects:
	 * @see PBPolarMapFX
	 * @see PBShadowmMapFX
	 * 
	 * Inspired by code from:
	 * @see http://www.catalinzima.com/2010/07/my-technique-for-the-shader-based-dynamic-2d-shadows/
	 * @see http://wonderfl.net/c/foPH
	 * 
	 * @author azrafe7
	 */
	public class DynaLightFX extends FX
	{
		
		/** @private matrix used to scale the BitmapData */
		protected var _scaleMatrix:Matrix = new Matrix();

		/** @private scale factor to be used by the effect (initialized once). */
		protected var _scale:Number;
		
		/** @private polarMap effect (used internally). */
		protected var _polarMapFX:PBPolarMapFX;
		
		/** @private shadowMap effect (used internally). */
		protected var _shadowMapFX:PBShadowMapFX;
		
		/** @private polarMap (used internally). */
		public var _polarMapBMD:BitmapData;
		
		/** @private shadowMap (used internally). */
		public var _shadowMapBMD:BitmapData;
		
		/** @private reducedMap (used internally). */
		public var _reducedMapBMD:BitmapData;
		
		public static const R_MASK:uint = 0x00FF0000;
		public static const G_MASK:uint = 0x0000FF00;
		public static const B_MASK:uint = 0x000000FF;
		public static const A_MASK:uint = 0xFF000000;
		
		/** Vector containing the 3 lights used by the effect. */
		public var lights:Vector.<DynaLight>;
				
		/** Whether to smooth the image when scaling. */
		public var smooth:Boolean = false;
		
		/** BitmapData representing occluders (must have a transparent background - any pixel with non-zero alpha is considered an occluder to light). */
		public var occludersBMD:BitmapData;
		
		/** List of effect that should be applied just before scaling up (before the last step). 
		 * 	Faster than using effects later, 'cause in this case they will be applied to the scaled down BitmapData.
		 */
		public var postEffects:FXList = new FXList;
		
		
		/**
		 * Creates a new DynaLightFX with the specified properties.
		 * 
		 * Use the postEffects property to add effects to be applied before the last step 
		 * (especially useful for PBRadiusFocusFX, BlurFX and ColorTransformFX).
		 * 
		 * @see #postEffects
		 * 
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 * 
		 * @param	occludersBMD		BitmapData representing occluders (must have a atransparent background - any pixel with non-zero alpha is considered an occluder to light).
		 * @param	scale				scale factor to be used by the effect (lower means lower precision but better performance - cannot be modified later).
		 * @param	lightX				x position of the light source.
		 * @param	lightY				y position of the light source.
		 * @param	lightRadius			radius of the light source.
		 * @param	lightPenetration	penetration of the light inside occluders (in percent of lightRadius).
		 * @param	transparent			whether to use alpha transparency in the darkness.
		 */
		public function DynaLightFX(occludersBMD:BitmapData, scale:Number = .37, 
									lightX:Number = NaN, lightY:Number = NaN, lightRadius:Number = 256, 
									lightPenetration:Number = 0, transparent:Boolean = false)
		{
			super();
			
			this.occludersBMD = occludersBMD;
			this._scale = scale;
			
			_scaleMatrix = new Matrix();
			_scaleMatrix.scale(scale, scale);
			
			initFilters(null);

			// center light source by default
			if (isNaN(lightX)) lightX = occludersBMD.width / 2;
			if (isNaN(lightY)) lightY = occludersBMD.height / 2;

			lights = new Vector.<DynaLight>;
			for (var i:int = 0; i < 3; ++i) {
				lights.push(new DynaLight(this, _polarMapFX, _shadowMapFX, i));
				lights[i].setProps({ active: i == 0, x: lightX, y: lightY, radius: lightRadius, penetration: lightPenetration, transparent: transparent });
			}
			lights.fixed = true;
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			// first time => setup non-inited values and create the needed filters
			if (!_reducedMapBMD || _reducedMapBMD.height != _polarMapBMD.height) {
				initFilters(clipRect);
			}

			// update filters' properties
			updateProps();
			
			var nLights:int = _shadowMapFX.activeLights;
			
			//bitmapData.fillRect(clipRect, 0);												// clear
			
			if (nLights > 0) {
				// apply filters
				_scaleMatrix.identity();													// prepare matrix...
				//_scaleMatrix.translate(-clipRect.x, -clipRect.y);
				_scaleMatrix.scale(_scale, _scale);											// ...to scale down
				
				_polarMapBMD.fillRect(_polarMapBMD.rect, 0);								// clear
				_polarMapBMD.draw(occludersBMD, _scaleMatrix, null, null, null, smooth);	// draw scaled down version of occludersBMD
				_polarMapFX.applyTo(_polarMapBMD, _polarMapBMD.rect);						// generate polar map
				
				reduceDistanceMap(_polarMapBMD, clipRect, _reducedMapBMD, nLights);			// reduce the polar map to a one column bmd (encoding normalized distance)
				
				_shadowMapBMD.fillRect(_shadowMapBMD.rect, 0);								// clear
				_shadowMapFX.applyTo(_shadowMapBMD, _shadowMapBMD.rect);					// generate lights/shadows (using reduced map)
				
				if (postEffects && postEffects.length > 0) {								// if any postEffects assigned...
					var fx:FX;
					for (var i:int = 0; i < postEffects.length; ++i) {						// ...apply them in order (iff active)
						fx = postEffects.at(i);
						if (fx.active) fx.applyTo(_shadowMapBMD);
					}
				}
				
				var invScale:Number = 1 / _scale;
				_scaleMatrix.identity();													// prepare matrix...
				_scaleMatrix.scale(invScale, invScale);									// ...to scale up
				//_scaleMatrix.translate(clipRect.x, clipRect.y);
				bitmapData.draw(_shadowMapBMD, _scaleMatrix, null, BlendMode.ADD, null, smooth);		// draw scaled up version of lights/shadows to final bmd
			}
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/** Initialize filters. */
		protected function initFilters(clipRect:Rectangle):void 
		{
			if (!clipRect) clipRect = occludersBMD.rect;	// TODO: checkout if this clipRect is _always_ correct

			_reducedMapBMD = new BitmapData(1, clipRect.height * scale, true, 0xff0000ff);
			//trace("new", clipRect);
			
			_polarMapBMD = new BitmapData(clipRect.width * _scale, clipRect.height * _scale, true, 0);
			_shadowMapBMD = new BitmapData(_polarMapBMD.width, _polarMapBMD.height, true, 0);
			
			_polarMapFX = new PBPolarMapFX();
			_shadowMapFX = new PBShadowMapFX(_reducedMapBMD);
		}
		
		/** Update filters' properties. */
		protected function updateProps():void 
		{
			for (var i:int = 0; i < lights.length; ++i) {
				if (lights[i].trackedObj) {
					lights[i].x = lights[i].trackedObj.x;
					lights[i].y = lights[i].trackedObj.y;
				}
			}
		}
		
		/** Scale factor to be used by the effect (read-only after initialization). */
		public function get scale():Number 
		{
			return _scale;
		}
		
		/**
		 * Reduces the passed polar distance map and returns the result in reducedMap 
		 * (which has to be already instantiated with correct dimensions (1, polarMap.height)).
		 * 
		 * Basically stores the normalized distance (from light source) to the occluders in the pixels of 
		 * the first column of reducedMap.
		 * 
		 * @private couldn't find a fast suitable way to implement it as a shader.
		 */
		public static function reduceDistanceMap(polarMap:BitmapData, rect:Rectangle, reducedMap:BitmapData, channelsToScan:Number=1):void 
		{
			var nonZeroRect:Rectangle = polarMap.getColorBoundsRect(0xFFFFFFFF, 0xFF000000, false);
			var maxHeight:int = nonZeroRect.height > 0 ? nonZeroRect.y + nonZeroRect.height : polarMap.height;
			
			reducedMap.fillRect(reducedMap.rect, 0);
			
			polarMap.lock();
			reducedMap.lock();
			
			var channelsFound:int;
			var reducedColor:uint;
			for (var t:int = nonZeroRect.y; t < maxHeight; ++t)
            {
				channelsFound = 0;
				reducedColor = 0xFF000000;
                for (var i:int = nonZeroRect.x; i < polarMap.width; ++i)
                {
					var color:uint = polarMap.getPixel32(i, t);
                    // if color != pure black we've hit an occluder
					if (color != 0xFF000000) 
                    {
						if (!(reducedColor & R_MASK) && color & R_MASK) {
							reducedColor |= color & R_MASK;
							channelsFound++;
							if (channelsFound == channelsToScan) break;
						}
						if (!(reducedColor & G_MASK) && color & G_MASK) {
							reducedColor |= color & G_MASK;
							channelsFound++;
							if (channelsFound == channelsToScan) break;
						}
						if (!(reducedColor & B_MASK) && color & B_MASK) {
							reducedColor |= color & B_MASK;
							channelsFound++;
							if (channelsFound == channelsToScan) break;
						}
                    }
                }
				reducedMap.setPixel32(0, t, reducedColor);
            }

			reducedMap.unlock();
			polarMap.unlock();
		}
	}
}