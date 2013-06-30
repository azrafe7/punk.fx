package punk.fx.effects.dynalight 
{
	import flash.display.ShaderData;
	import flash.utils.Dictionary;
	import punk.fx.effects.dynalight.PBPolarMapFX;

	/**
	 * Proxy for PBPolarMapFX shader data.
	 * 
	 * @see PBPolarMapFX
	 * 
	 * @author azrafe7
	 */
	public class CenterPoint
	{
		protected var _data:ShaderData;
		protected var _map:Dictionary;
		protected var _index:int;
		
		public function CenterPoint(polarMapFX:PBPolarMapFX, index:int):void 
		{
			this._data = polarMapFX.shader.data;
			this._map = new Dictionary(true);
			this._index = index;
			
			// setup the mapping dict
			var idxStr:String = index.toString();
			_map["centerPos"] = "centerPos" + idxStr;
			_map["radius"] = "radius" + idxStr;
		}
		
		/** Index of this center point. */
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

		/** X position of the center point (in pixels). */
		public function get x():Number
		{
			return _data[_map["centerPos"]].value[0];
		}
		
		/** @private */
		public function set x(value:Number):void
		{
			_data[_map["centerPos"]].value[0] = value;
		}
		
		/** Y position of the center point (in pixels). */
		public function get y():Number
		{
			return _data[_map["centerPos"]].value[1];
		}
		
		/** @private */
		public function set y(value:Number):void
		{
			_data[_map["centerPos"]].value[1] = value;
		}

		/** Cut-off radius of the circle positioned at center point (in pixels). */
		public function get radius():Number
		{
			return _data[_map["radius"]].value[0];
		}
		
		/** @private */
		public function set radius(value:Number):void
		{
			_data[_map["radius"]].value[0] = value;
		}
		
		
		/**
		 * Sets the properties specified by the props Object.
		 * 
		 * @example This will set the <code>x</code> and <code>y</code> properties of <code>CenterPoint</code>, 
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