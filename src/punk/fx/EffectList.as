package punk.fx
{
	import punk.fx.effects.Effect;

	/**
	 * Vector-like container for Effects.
	 * 
	 * @author azrafe7
	 */
	public class EffectList 
	{
		/** A Vector holding the effects. */
		protected var _effects:Vector.<Effect> = new Vector.<Effect>;
		
		/** If true prevents duplicated effects to be added. */
		protected var _ensureUniqueness:Boolean = true;

		/**
		 * Creates a new EffectList.
		 * 
		 * @param	effects			a single Effect or a Vector/Array of Effects to be added to the list.
		 * @param	uniqueness		set this to true if you want to ensure that no duplicated effects are added to the list (defaults to true).
		 */
		public function EffectList(effects:* = null, uniqueness:Boolean = true)
		{
			_ensureUniqueness = uniqueness;
			
			if (effects) {
				add(effects);
			}
		}
		
		/**
		 * Checks if one or more Effects are in the EffectList.
		 * 
		 * @param	effects		a single Effect or a Vector/Array of Effects to be checked for.
		 * 
		 * @return true if ALL of the effects specified are found in the list.
		 */
		public function contains(effects:*):Boolean
		{
			var found:int;
			var i:int = _effects.length;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is EffectList) fxArray = effects.getAll();
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
		 * Used internally to add Effects to the EffectList.
		 * 
		 * @private
		 */
		protected function _add(effect:*):void 
		{
			if (effect == null) throw new Error("Effect cannot be null.");
			if (!(_ensureUniqueness && contains(effect))) _effects[_effects.length] = (effect is Class ? new effect : effect);
		}
		
		
		/**
		 * Adds one or more Effects to the EffectList.
		 * 
		 * @param	effects		a single Effect or a Vector/Array of Effects to be added to the list.
		 * @return the EffectList itself for chaining.
		 */
		public function add(effects:*):EffectList {
			var fx:*;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is EffectList) fxArray = effects.getAll();
			else fxArray = [effects];
			
			for each (fx in fxArray) _add(fx);
			
			return this;
		}
		
		/**
		 * Used internally to insert Effects into the EffectList.
		 * 
		 * @private
		 */
		protected function _insert(effect:*, at:int=0):void 
		{
			if (effect == null) throw new Error("Effect cannot be null.");
			if (!(_ensureUniqueness && contains(effect))) _effects.splice(at, 0, (effect is Class ? new effect : effect));
		}
		
		/**
		 * Inserts one or more Effects into the EffectList.
		 * 
		 * @param	effects		a single Effect or a Vector/Array of Effects to be inserted into the list.
		 * @param	at			index at with effects will be inserted (defaults to 0).
		 * @return the EffectList itself for chaining.
		 */
		public function insert(effects:*, at:int=0):EffectList 
		{
			var fx:*;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is EffectList) fxArray = effects.getAll();
			else fxArray = [effects];

			for (var i:int = fxArray.length - 1; i >= 0; i--) _insert(fxArray[i], at);
			
			return this;
		}
		
		/**
		 * Used internally to remove Effects from the EffectList.
		 * 
		 * @private
		 */
		protected function _remove(effect:Effect):void 
		{
			var i:int = _effects.length;
			
			if (effect == null) throw new Error("Effect cannot be null.");
			while (i--) {
				if (_effects[i] == effect) _effects.splice(i, 1);
			}
		}
		
		/**
		 * Removes a single Effect or a Vector/Array of Effects from the EffectList.
		 * 
		 * @param	effects		a single Effect or a Vector/Array of Effects to be removed from the list.
		 * 
		 * @return the EffectList itself for chaining.
		 */
		public function remove(effects:*):EffectList {
			var fx:Effect;
			var fxArray:*;
			
			if (effects is Array || effects is Vector.<*>) fxArray = effects;
			else if (effects is EffectList) fxArray = effects.getAll();
			else fxArray = [effects];

			for each (fx in fxArray) _remove(fx);
			
			return this;
		}
		
		/**
		 * Removes the Effect at the specified index from the EffectList.
		 * 
		 * @param	index		the index of the Effect to be removed.
		 * 
		 * @return the EffectList itself for chaining.
		 */
		public function removeAt(index:*):EffectList {
			var idx:Number;
			var idxArray:*;
			
			if (index is Array || index is Vector.<*>) idxArray = index;
			else idxArray = [index];

			for each (idx in idxArray) _remove(this.at(idx));
			
			return this;
		}
		
		/**
		 * Removes all the effects from the EffectList.
		 * 
		 * @return the EffectList itself for chaining.
		 */
		public function clear():EffectList 
		{
			while (_effects.length) _effects.pop();
			
			return this;
		}
		
		/**
		 * Executes a callback function passing each Effect in the EffectList as the first parameter.
		 * 
		 * @param	callback		a function with signature <code>function(fx:Effect)</code> that gets called for each Effect in the list (in order).
		 */
		public function forEach(callback:Function):void 
		{
			for (var i:int = 0; i < _effects.length; i++) callback.apply(null, [_effects[i]]);
		}
		
		/**
		 * Returns the Effect at specified index in the EffectList.
		 * 
		 * @param	idx		the index of the Effect to fetch.
		 * @return the Effect at idx.
		 */
		public function at(idx:int):Effect 
		{
			return _effects[idx];
		}
		
		/**
		 * Returns the index of the specified Effect in the list (or -1 if it's not found).
		 * 
		 * @param	effect		the Effect to search for.
		 * @return the index of the Effect.
		 */
		public function indexOf(effect:Effect):int
		{
			return _effects.indexOf(effect);
		}
		
		/**
		 * Returns the Vector of Effects containing all the Effects in the EffectList (it's not a copy so _beware_).
		 * 
		 * @return a Vector of Effects of all the Effects in the list.
		 */
		public function getAll():Vector.<Effect> 
		{
			return _effects;
		}
		
		/**
		 * Number of Effects in the EffectList.
		 */
		public function get length():int 
		{
			return _effects.length;
		}
		
		/**
		 * True if no duplicated Effects can be added to the EffectList.
		 * @see #EffectList()
		 */
		public function get ensureUniqueness():Boolean 
		{
			return _ensureUniqueness;
		}
		
		/**
		 * String representation of the EffectList (useful for debugging).
		 * 
		 * @return a string representation of the list of effects.
		 */
		public function toString():String 
		{
			var l:int = _effects.length;
			var res:String = "EffectList[ ";
			
			for (var i:int = 0; i < l; i++) {
				res += _effects[i] + " ";
			}
			res += "]";
			return res;
		}
	}

}