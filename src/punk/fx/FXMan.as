package punk.fx
{
	import flash.utils.Dictionary;
	import punk.fx.effects.FX;
	import punk.fx.graphics.IFXGraphic;
	import punk.fx.lists.FXList;
	
	/**
	 * Manager of IFXGraphics and the FXs associated to them.
	 * 
	 * @author azrafe7
	 */
	public class FXMan 
	{
		
		/** Library version. */
		public static var VERSION:String = "0.3.007";
		
		/** Build date (DD/MM/YYYY). */
		public static var BUILD_DATE:String = CONFIG::timeStamp;

		// print out punk.fx version and build date if in DEBUG
		CONFIG::debug {
			trace("punk.fx v" + VERSION + " (" + BUILD_DATE + ")");
		}
		
		/** 
		 * @private (weak) Dictionary(IFXGraphic, FXList).
		 * It's actually a (weak) Dictionary(*, FXList) but is ensured that the added targets implement IFXGraphic.
		 */
		protected static var _effects:Dictionary = new Dictionary(false);
		
		/**
		 * Used internally to bind/add FXs to an IFXGraphic.
		 * 
		 * @private
		 */
		protected static function _add(target:*, effects:*):void 
		{
			if (target == null || !(target is IFXGraphic)) throw new Error("Target must be a non-null IFXGraphic.");
			if (!_effects[target]) _effects[target] = target.effects;
			FXList(_effects[target]).add(effects);
		}
		
		/**
		 * Adds FXs to one or multiple targets.
		 * 
		 * @param	targets		can be a Vector, an Array or a single IFXGraphic.
		 * @param	effects		effects to be applied to targets (a Vector/Array of FXs or a single FX).
		 */
		public static function add(targets:*, effects:*=null):void
		{
			var target:*;
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
		 * @param	targets		targets to be removed (a Vector/Array of IFXGraphics or a single IFXGraphic). Pass null to remove all.
		 */
		public static function removeTargets(targets:*=null):void 
		{
			if (targets == null) return clear();
			
			var target:*;
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
		 * @param	target	the target IFXGraphic.
		 * 
		 * @return the FXList associated with target.
		 */
		public static function getEffectsOf(target:*):FXList
		{
			return _effects[target];
		}
		
		/**
		 * Returns all the effects in the manager, stored in a Vector.
		 * 
		 * @return all the effects in the manager.
		 */
		public static function getAllEffects():Vector.<FX> 
		{
			var targets:Vector.<*> = new Vector.<*>;
			var fxList:FXList = new FXList;
			
			for (var target:* in _effects) fxList.add(_effects[target]);
			
			return fxList.getAll() as Vector.<FX>;
		}

		/**
		 * Returns all the targets in the manager, stored in a Vector.
		 * 
		 * @return all the targets in the manager.
		 */
		public static function getAllTargets():Vector.<*> 
		{
			var targets:Vector.<*> = new Vector.<*>;
			
			for (var target:* in _effects) targets[targets.length] = target;
			
			return targets;
		}
		
		/**
		 * Returns a Vector of all the IFXGraphics that are using the specified effects.
		 * 
		 * @param	effects		effects to check against (a Vector/Array of FXs or a single FX).
		 * 
		 * @return all the IFXGraphics that are using the specified effects.
		 */
		public static function getTargetsWith(effects:*):Vector.<*> 
		{
			var targets:Vector.<*> = new Vector.<*>;
			
			for (var target:* in _effects) if (_effects[target].contains(effects)) targets[targets.length] = target;
			
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