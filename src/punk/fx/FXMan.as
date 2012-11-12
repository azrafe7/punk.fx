package punk.fx
{
	import flash.utils.Dictionary;
	import punk.fx.effects.FX;
	
	/**
	 * Manager of FXImages and the FXs associated to them.
	 * 
	 * @author azrafe7
	 */
	public class FXMan 
	{
		
		/** Library version. */
		public static var VERSION:String = "0.2.001";
		
		/** Build date (DD/MM/YYYY). */
		public static var BUILD_DATE:String = CONFIG::timeStamp;

		/** @private */
		protected static var _effects:Dictionary = new Dictionary(false); 		// (weak) Dictionary(FXImage, FXList)
		
		/**
		 * Used internally to bind/add FXs to an FXImage.
		 * 
		 * @private
		 */
		protected static function _add(target:FXImage, effects:*):void 
		{
			if (target == null) throw new Error("FXImage target cannot be null.");
			if (!_effects[target]) _effects[target] = target.effects;
			FXList(_effects[target]).add(effects);
		}
		
		/**
		 * Adds FXs to one or multiple targets.
		 * 
		 * @param	targets		can be a Vector, an Array or a single FXImage.
		 * @param	effects		effects to be applied to targets (a Vector/Array of FXs or a single FX).
		 */
		public static function add(targets:*, effects:*=null):void
		{
			var target:FXImage;
			var targetArray:*;

			if (targets is Array || targets is Vector.<*>) targetArray = targets;
			else targetArray = [targets];
			
			for each (target in targetArray) _add(target, effects);
		}
		
		/**
		 * Removes effects from the manager.
		 * 
		 * @param	effects		effects to be removed (a Vector/Array of FXs or a single FX).
		 */
		public static function removeEffects(effects:*):void
		{
			for (var target:* in _effects) _effects[target].remove(effects);
		}
		
		/**
		 * Removes targets from the manager (also removing the associated effects).
		 * 
		 * @param	targets		targets to be removed (a Vector/Array of FXImages or a single FXImage). Pass null to remove all.
		 */
		public static function removeTargets(targets:*=null):void 
		{
			if (targets == null) return clear();
			
			var target:FXImage;
			var targetArray:*;

			if (targets is Array || targets is Vector.<*>) targetArray = targets;
			else targetArray = [targets];
			
			for each (target in targetArray) {
				FXList(_effects[target]).clear();
				delete _effects[target];
			}
		}
		
		/**
		 * Removes all targets and effects from the manager.
		 */
		public static function clear():void 
		{
			for (var target:* in _effects) {
				FXList(_effects[target]).clear();
				delete _effects[target];
			}
		}
		
		/**
		 * Returns the list of effects associated with target.
		 * 
		 * @param	target	the target FXImage.
		 * 
		 * @return the FXList associated with target.
		 */
		public static function getEffectsOf(target:FXImage):FXList
		{
			return _effects[target];
		}
		
		/**
		 * Returns all the effects in the manager stored in a Vector.
		 * 
		 * @return all the effects in the manager.
		 */
		public static function getAllEffects():Vector.<FX> 
		{
			var targets:Vector.<FXImage> = new Vector.<FXImage>;
			var fxList:FXList = new FXList;
			
			for (var target:* in _effects) fxList.add(_effects[target]);
			
			return fxList.getAll();
		}

		/**
		 * Returns all the targets in the manager stored in a Vector.
		 * 
		 * @return all the targets in the manager.
		 */
		public static function getAllTargets():Vector.<FXImage> 
		{
			var targets:Vector.<FXImage> = new Vector.<FXImage>;
			
			for (var target:* in _effects) targets[targets.length] = target as FXImage;
			
			return targets;
		}
		
		/**
		 * Returns a Vector of all the FXImages that are using the specified effects.
		 * 
		 * @param	effects		effects to check against (a Vector/Array of FXs or a single FX).
		 * 
		 * @return all the FXImages that are using the specified effects.
		 */
		public static function getTargetsWith(effects:*):Vector.<FXImage> 
		{
			var targets:Vector.<FXImage> = new Vector.<FXImage>;
			
			for (var target:* in _effects) if (_effects[target].contains(effects)) targets[targets.length] = target as FXImage;
			
			return targets;
		}
		
		/**
		 * String representation of the FXMan (useful for debugging).
		 * 
		 * @return a string representation of the FXMan.
		 */
		public static function toString():String 
		{
			var res:String = "FXMan\n";
			for (var target:* in _effects) {
				res += " + " + target + " - " + _effects[target] + "\n";
			}
			return res;
		}
	}

}