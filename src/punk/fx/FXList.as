package punk.fx
{
	import punk.fx.effects.FX;

	/**
	 * Vector-like container for FXs.
	 * 
	 * @author azrafe7
	 */
	public class FXList 
	{
		/** A Vector holding the effects. */
		protected var _effects:Vector.<FX> = new Vector.<FX>;
		
		/** If true prevents duplicated effects to be added. */
		protected var _ensureUniqueness:Boolean = true;

		/**
		 * Creates a new FXList.
		 * 
		 * @param	effects			a single FX or a Vector/Array of FXs to be added to the list.
		 * @param	uniqueness		set this to true if you want to ensure that no duplicated effects are added to the list (defaults to true).
		 */
		public function FXList(effects:* = null, uniqueness:Boolean = true)
		{
			_ensureUniqueness = uniqueness;
			
			if (effects) {
				add(effects);
			}
		}
		
		/**
		 * Checks if one or more FXs are in the FXList.
		 * 
		 * @param	effects		a single FX or a Vector/Array of FXs to be checked for.
		 * 
		 * @return true if ALL of the effects specified are found in the list.
		 */
		public function contains(effects:*):Boolean
		{
			var found:int;
			var i:int = _effects.length;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is FXList) fxArray = effects.getAll();
			else fxArray = [effects];

			var j:int = fxArray.length-1;
			while (i-- && j > -1) {
				if (_effects[i] == fxArray[j]) {
					found++;
					j--;
				}
			}
			
			return (found == fxArray.length);
		}
		
		/**
		 * Used internally to add FXs to the FXList.
		 * 
		 * @private
		 */
		protected function _add(effect:*):void 
		{
			if (effect == null) throw new Error("Effect cannot be null.");
			if (!(_ensureUniqueness && contains(effect))) _effects[_effects.length] = (effect is Class ? new effect : effect);
		}
		
		
		/**
		 * Adds one or more FXs to the FXList.
		 * 
		 * @param	effects		a single FX or a Vector/Array of FXs to be added to the list.
		 * @return the FXList itself for chaining.
		 */
		public function add(effects:*):FXList {
			var fx:*;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is FXList) fxArray = effects.getAll();
			else fxArray = [effects];
			
			for each (fx in fxArray) _add(fx);
			
			return this;
		}
		
		/**
		 * Used internally to insert FXs into the FXList.
		 * 
		 * @private
		 */
		protected function _insert(effect:*, at:int=0):void 
		{
			if (effect == null) throw new Error("Effect cannot be null.");
			if (!(_ensureUniqueness && contains(effect))) _effects.splice(at, 0, (effect is Class ? new effect : effect));
		}
		
		/**
		 * Inserts one or more FXs into the FXList.
		 * 
		 * @param	effects		a single FX or a Vector/Array of FXs to be inserted into the list.
		 * @param	at			index at which effects will be inserted (defaults to 0).
		 * @return the FXList itself for chaining.
		 */
		public function insert(effects:*, at:int=0):FXList 
		{
			var fx:*;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is FXList) fxArray = effects.getAll();
			else fxArray = [effects];

			for (var i:int = fxArray.length - 1; i >= 0; i--) _insert(fxArray[i], at);
			
			return this;
		}
		
		/**
		 * Used internally to remove FXs from the FXList.
		 * 
		 * @private
		 */
		protected function _remove(effect:FX):void 
		{
			var i:int = _effects.length;
			
			if (effect == null) throw new Error("Effect cannot be null.");
			while (i--) {
				if (_effects[i] == effect) _effects.splice(i, 1);
			}
		}
		
		/**
		 * Removes a single FX or a Vector/Array of FXs from the FXList.
		 * 
		 * @param	effects		a single FX or a Vector/Array of FXs to be removed from the list.
		 * 
		 * @return the FXList itself for chaining.
		 */
		public function remove(effects:*):FXList {
			var fx:FX;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is FXList) fxArray = effects.getAll();
			else fxArray = [effects];

			for each (fx in fxArray) _remove(fx);
			
			return this;
		}
		
		/**
		 * Removes the FX at the specified index from the FXList.
		 * 
		 * @param	index		the index of the FX to be removed.
		 * 
		 * @return the FXList itself for chaining.
		 */
		public function removeAt(index:*):FXList {
			var idx:Number;
			var idxArray:*;
			
			if (index is Array || index is Vector.<*>) idxArray = index;
			else idxArray = [index];

			for each (idx in idxArray) _remove(this.at(idx));
			
			return this;
		}
		
		/**
		 * Removes all the effects from the FXList.
		 * 
		 * @return the FXList itself for chaining.
		 */
		public function clear():FXList 
		{
			while (_effects.length) _effects.pop();
			
			return this;
		}
		
		/**
		 * Executes a callback function passing each FX in the FXList as the first parameter.
		 * 
		 * @param	callback		a function with signature <code>function(fx:FX)</code> that gets called for each FX in the list (in order).
		 */
		public function forEach(callback:Function):void 
		{
			for (var i:int = 0; i < _effects.length; ++i) callback.apply(null, [_effects[i]]);
		}
		
		/**
		 * Returns the FX at specified index in the FXList.
		 * 
		 * @param	idx		the index of the FX to fetch.
		 * @return the FX at idx.
		 */
		public function at(idx:int):FX 
		{
			return _effects[idx];
		}
		
		/**
		 * Returns the index of the specified FX in the list (or -1 if it's not found).
		 * 
		 * @param	effect		the FX to search for.
		 * @return the index of the FX.
		 */
		public function indexOf(effect:FX):int
		{
			return _effects.indexOf(effect);
		}
		
		/**
		 * Returns the Vector of FXs containing all the FXs in the FXList (it's not a copy so _beware_).
		 * 
		 * @return a Vector of FXs of all the FXs in the list.
		 */
		public function getAll():Vector.<FX> 
		{
			return _effects;
		}
		
		/**
		 * Number of FXs in the FXList.
		 */
		public function get length():int 
		{
			return _effects.length;
		}
		
		/**
		 * True if no duplicated FXs can be added to the FXList.
		 * @see #FXList()
		 */
		public function get ensureUniqueness():Boolean 
		{
			return _ensureUniqueness;
		}
		
		/**
		 * String representation of the FXList (useful for debugging).
		 * 
		 * @return a string representation of the list of effects.
		 */
		public function toString():String 
		{
			var l:int = _effects.length;
			var res:String = "FXList[ ";
			
			for (var i:int = 0; i < l; ++i) {
				res += _effects[i] + " ";
			}
			res += "]";
			return res;
		}
	}

}