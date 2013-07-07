package punk.fx.effects.dynalight 
{
	import punk.fx.effects.dynalight.Light;
	import punk.fx.effects.DynaLightFX;
	import punk.fx.effects.PBRadialFocusFX;

	/**
	 * Wraps properties of lights used by DynaLightFX.
	 * (proxies CenterPoint and Light objects internally)
	 * 
	 * @see DynaLightFX
	 * 
	 * @author azrafe7
	 */
	public class DynaLight
	{
		protected var _dynaLightFX:DynaLightFX;
		protected var _centerPoint:CenterPoint;
		protected var _light:Light;
		protected var _index:int;
		protected var _scale:Number;
		
		/** Light x position. */
		protected var _x:Number;
		
		/** Light y position. */
		protected var _y:Number;
		
		/** Light radius. */
		protected var _radius:Number;
		
		/** Light position will follow this object position (must have x and y properties). */
		public var trackedObj:* = null;

		
		public function DynaLight(dynaLightFX:DynaLightFX, polarMapFX:PBPolarMapFX, shadowMapFX:PBShadowMapFX, index:int):void 
		{
			this._index = index;

			this._dynaLightFX = _dynaLightFX;
			this._centerPoint = polarMapFX.centerPoints[index];
			this._light = shadowMapFX.lights[index];
			this._scale = dynaLightFX.scale;
		}
		
		/** Index of this light. */
		public function get index():int 
		{
			return _index;
		}
		
		/** Active state of center point. */
		public function get active():Boolean 
		{
			return _light.active;
		}
		
		/** @private */
		public function set active(value:Boolean):void
		{
			_centerPoint.active = value;
			_light.active = value;
		}

		/** X position of the light (in pixels). */
		public function get x():Number
		{
			return _x;
		}
		
		/** @private */
		public function set x(value:Number):void
		{
			_x = value;
			_centerPoint.x = _x * _scale;
			_light.x = _centerPoint.x;
		}
		
		/** Y position of the light (in pixels). */
		public function get y():Number
		{
			return _y;
		}
		
		/** @private */
		public function set y(value:Number):void
		{
			_y = value;
			_centerPoint.y = _y * _scale;
			_light.y = _centerPoint.y;
		}

		/** Radius of the light (in pixels). */
		public function get radius():Number
		{
			return _radius;
		}
		
		/** @private */
		public function set radius(value:Number):void
		{
			_radius = value;
			_centerPoint.radius = _radius * _scale;
			_light.radius = _centerPoint.radius;
		}

		/** Penetration of the light (in percent of lightRadius). */
		public function get penetration():Number
		{
			return _light.penetration;
		}
		
		/** @private */
		public function set penetration(value:Number):void
		{
			_light.penetration = value;
		}

		/** Whether to use alpha transparency in the darkness. */
		public function get transparent():Boolean
		{
			return _light.transparent;
		}
		
		/** @private */
		public function set transparent(value:Boolean):void
		{
			_light.transparent = value;
		}
		
		/** Light fall-off (x:constant, y:linear, z:quadratic). */
		public function setFallOff(x:Number, y:Number, z:Number):void 
		{
			_light.setFallOff(x, y, z);
		}

		/** Constant light fall-off. */
		public function get fallOffX():Number 
		{
			return _light.fallOffX;
		}

		/** @private */
		public function set fallOffX(value:Number):void
		{
			_light.fallOffX = value;
		}
		
		/** Linear light fall-off. */
		public function get fallOffY():Number 
		{
			return _light.fallOffY;
		}

		/** @private */
		public function set fallOffY(value:Number):void
		{
			_light.fallOffY = value;
		}
		
		/** Quadratic light fall-off. */
		public function get fallOffZ():Number 
		{
			return _light.fallOffZ;
		}

		/** @private */
		public function set fallOffZ(value:Number):void
		{
			_light.fallOffZ = value;
		}
		
		
		/**
		 * Sets the properties specified by the props Object.
		 * 
		 * @example This will set the <code>x</code> and <code>y</code> properties of <code>DynaLight</code>, 
		 * while skipping the <code>foobar</code> property without throwing an <code>Exception</code> 
		 * since <code>strictMode</code> is set to <code>false</code>.
		 * 
		 * <listing version="3.0">
		 * 
		 * effect.setProps({x:256, y:128, foobar:"dsjghkjdgh"}, false);
		 * </listing>
		 * 
		 * @param	props			an Object containing key/value pairs to be set on the FX instance.
		 * @param	strictMode		if true (default) an Excpetion will be thrown when trying to assign to properties/vars that don't exist in the instance.
		 * @return the instance itself for chaining.
		 */
		public function setProps(props:*, strictMode:Boolean=true):* 
		{
			for (var prop:* in props) {
				if (this.hasOwnProperty(prop)) this[prop] = props[prop];
				else if (strictMode) throw new Error("Cannot find property " + prop + " on " + this + ".");
			}
			
			return this;
		}
	}
	
}