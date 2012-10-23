package punk.fx
{
	import flash.utils.Dictionary;
	import punk.fx.effects.Effect;
	
	/**
	 * Manager of ImageFXs and the Effects associated to them.
	 * 
	 * @author azrafe7
	 */
	public class FXMan 
	{

		/** @private */
		protected static var _effects:Dictionary = new Dictionary(false); 		// (weak) Dictionary(ImageFX, EffectList)
		
		/**
		 * Used internally to bind/add Effects to an ImageFX.
		 * 
		 * @private
		 */
		protected static function _add(target:ImageFX, effects:*):void 
		{
			if (target == null) throw new Error("ImageFX target cannot be null.");
			if (!_effects[target]) _effects[target] = new EffectList(effects);
			else EffectList(_effects[target]).add(effects);
		}
		
		/**
		 * Adds Effects to one or multiple targets.
		 * 
		 * @param	targets		can be a Vector, an Array or a single ImageFX.
		 * @param	effects		effects to be applied to targets (a Vector/Array of Effects or a single Effect).
		 */
		public static function add(targets:*, effects:*=null):void
		{
			var target:ImageFX;
			var targetArray:*;

			if (targets is Array || targets is Vector.<*>) targetArray = targets;
			else targetArray = [targets];
			
			for each (target in targetArray) _add(target, effects);
		}
		
		/**
		 * Removes effects from the manager.
		 * 
		 * @param	effects		effects to be removed (a Vector/Array of Effects or a single Effect).
		 */
		public static function removeEffects(effects:*):void
		{
			for (var target:* in _effects) _effects[target].remove(effects);
		}
		
		/**
		 * Removes targets from the manager.
		 * 
		 * @param	targets		targets to be removed (a Vector/Array of ImageFXs or a single ImageFX). Pass null to remove all.
		 */
		public static function removeTargets(targets:*=null):void 
		{
			if (targets == null) return clear();
			
			var target:ImageFX;
			var targetArray:*;

			if (targets is Array || targets is Vector.<*>) targetArray = targets;
			else targetArray = [targets];
			
			for each (target in targetArray) delete _effects[target];
		}
		
		/**
		 * Removes all targets from the manager.
		 */
		public static function clear():void 
		{
			for (var target:* in _effects) delete _effects[target];
		}
		
		/**
		 * Returns the list of effects associated with target.
		 * 
		 * @param	target	the target ImageFX.
		 * 
		 * @return the EffectList associated with target.
		 */
		public static function getEffectsOf(target:ImageFX):EffectList
		{
			return _effects[target];
		}
		
		/**
		 * Returns all the effects in the manager stored in a Vector.
		 * 
		 * @return all the effects in the manager.
		 */
		public static function getAllEffects():Vector.<Effect> 
		{
			var targets:Vector.<ImageFX> = new Vector.<ImageFX>;
			var fxList:EffectList = new EffectList;
			
			for (var target:* in _effects) fxList.add(_effects[target]);
			
			return fxList.getAll();
		}

		/**
		 * Returns all the targets in the manager stored in a Vector.
		 * 
		 * @return all the targets in the manager.
		 */
		public static function getAllTargets():Vector.<ImageFX> 
		{
			var targets:Vector.<ImageFX> = new Vector.<ImageFX>;
			
			for (var target:* in _effects) targets.push(target as ImageFX);
			
			return targets;
		}
		
		/**
		 * Returns a Vector of all the ImageFXs that are using the effects specified.
		 * 
		 * @param	effects		effects to check against (a Vector/Array of Effects or a single Effect).
		 * 
		 * @return all the ImageFXs that are using the effects specified.
		 */
		public static function getTargetsWith(effects:*):Vector.<ImageFX> 
		{
			var targets:Vector.<ImageFX> = new Vector.<ImageFX>;
			
			for (var target:* in _effects) if (_effects[target].contains(effects)) targets.push(target as ImageFX);
			
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