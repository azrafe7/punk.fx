package punk.fx.lists 
{
	import net.flashpunk.Entity;

	/**
	 * Vector-like container for Entities (auto-sorted by layer by default).
	 * 
	 * @author azrafe7
	 */
	public class EntityList extends TList 
	{
		
		
		/** @inheritDoc */
		public function EntityList(items:*=null, uniqueness:Boolean=true, sortByLayer:Boolean=false) 
		{
			super(items, uniqueness);
			
			if (sortByLayer) compareFunction = compareByLayer;
		}
		
		/**
		 * Used internally to convert an object to a valid Entity.
		 * 
		 * @private
		 */
		override protected function _validate(item:*):*
		{
			var entity:* = item;
			
			if (entity == null || !(entity is Entity)) throw new Error("Invalid or null entity.");
			return entity;
		}

		/** 
		 * Compares two entities by their layer value (default comparing function). 
		 * Entities with lower layers will appear later in the list. 
		 */
		public function compareByLayer(entityA:*, entityB:*):Number 
		{
			var diff:Number = entityB.layer - entityA.layer;
			return diff < 0 ? -1 : (diff > 0 ? 1 : 0);
		}
		
	}

}