package punk.fx.effects.dynalight 
{
	import punk.fx.effects.dynalight.*;
	import flash.display.ShaderData;
	import flash.utils.Dictionary;

	/**
	 * Proxy for PBShadowMapFX shader data.
	 * 
	 * @see PBShadowMapFX
	 * 
	 * @author azrafe7
	 */
	public class Light
	{
		protected var _data:ShaderData;
		protected var _map:Dictionary;
		protected var _index:int;
		
		public function Light(shadowMapFX:PBShadowMapFX, index:int):void 
		{
			this._data = shadowMapFX.shader.data;
			this._map = new Dictionary(true);
			this._index = index;
			
			// setup the mapping dict
			var idxStr:String = index.toString();
			_map["lightPos"] = "lightPos" + idxStr;
			_map["lightRadius"] = "lightRadius" + idxStr;
			_map["penetration"] = "penetration" + idxStr;
			_map["transparent"] = "transparent" + idxStr;
			_map["fallOff"] = "fallOff" + idxStr;
		}
		
		/** Index of this light. */
		public function get index():int 
		{
			return _index;
		}
		
		/** Active state of center point. */
		public function get active():Boolean 
		{
			return _data.isActive.value[index] != 0;
		}
		
		/** @private */
		public function set active(value:Boolean):void
		{
			_data.isActive.value[index] = value ? 1 : 0;
		}

		/** X position of the light (in pixels). */
		public function get x():Number
		{
			return _data[_map["lightPos"]].value[0];
		}
		
		/** @private */
		public function set x(value:Number):void
		{
			_data[_map["lightPos"]].value[0] = value;
		}
		
		/** Y position of the light (in pixels). */
		public function get y():Number
		{
			return _data[_map["lightPos"]].value[1];
		}
		
		/** @private */
		public function set y(value:Number):void
		{
			_data[_map["lightPos"]].value[1] = value;
		}

		/** Radius of the light (in pixels). */
		public function get radius():Number
		{
			return _data[_map["lightRadius"]].value[0];
		}
		
		/** @private */
		public function set radius(value:Number):void
		{
			_data[_map["lightRadius"]].value[0] = value;
		}

		/** Penetration of the light (in percent of lightRadius). */
		public function get penetration():Number
		{
			return _data[_map["penetration"]].value[0];
		}
		
		/** @private */
		public function set penetration(value:Number):void
		{
			_data[_map["penetration"]].value[0] = value;
		}

		/** Whether to use alpha transparency in the darkness. */
		public function get transparent():Boolean
		{
			return _data[_map["transparent"]].value[0] != 0;
		}
		
		/** @private */
		public function set transparent(value:Boolean):void
		{
			_data[_map["transparent"]].value[0] = value ? 1 : 0;
		}
		
		/** Light fall-off (x:constant, y:linear, z:quadratic). */
		public function setFallOff(x:Number, y:Number, z:Number):void 
		{
			fallOffX = x;
			fallOffY = y;
			fallOffZ = z;
		}

		/** Constant light fall-off. */
		public function get fallOffX():Number 
		{
			return _data[_map["fallOff"]].value[0];
		}

		/** @private */
		public function set fallOffX(value:Number):void
		{
			_data[_map["fallOff"]].value[0] = value;
		}
		
		/** Linear light fall-off. */
		public function get fallOffY():Number 
		{
			return _data[_map["fallOff"]].value[1];
		}

		/** @private */
		public function set fallOffY(value:Number):void
		{
			_data[_map["fallOff"]].value[1] = value;
		}
		
		/** Quadratic light fall-off. */
		public function get fallOffZ():Number 
		{
			return _data[_map["fallOff"]].value[2];
		}

		/** @private */
		public function set fallOffZ(value:Number):void
		{
			_data[_map["fallOff"]].value[2] = value;
		}
		
		
		/**
		 * Sets the properties specified by the props Object.
		 * 
		 * @example This will set the <code>x</code> and <code>y</code> properties of <code>Light</code>, 
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