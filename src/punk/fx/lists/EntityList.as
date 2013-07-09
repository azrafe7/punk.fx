package punk.fx.lists 
{
	import net.flashpunk.Entity;

	/**
	 * Vector-like container for Entities.
	 * 
	 * @author azrafe7
	 */
	public class EntityList extends TList 
	{
		/** Whether to set the visible property of Entities to false. */
		public var changeVisibility:Boolean;
		
		/**
		 * Creates a new EntityList.
		 * 
		 * @param	items				a single Entity or a Vector/Array of Entities to be added to the list.
		 * @param	uniqueness			set this to true if you want to ensure that no duplicated Entities are added to the list (defaults to true).
		 * @param	sortByLayer			whether the entities must be sorted by layer when they're added to the list (defaults to true)
		 * @param	changeVisibility	whether to set the visible property of newly added Entities to false (defaults to false)
		 */
		public function EntityList(items:*=null, uniqueness:Boolean=true, sortByLayer:Boolean=true, changeVisibility:Boolean=false) 
		{
			super(items, uniqueness);
			
			this.changeVisibility = changeVisibility;
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
		 * Compares two entities by their layer value (you can assign this to compareFunction). 
		 * Entities with lower layers will appear later in the list. 
		 */
		public function compareByLayer(entityA:*, entityB:*):Number 
		{
			var diff:Number = entityB.layer - entityA.layer;
			return diff < 0 ? -1 : (diff > 0 ? 1 : 0);
		}
		
		/** @inheritDoc */ 
		override protected function _add(item:*):void 
		{
			super._add(item);
			if (changeVisibility) item.visible = false;	// set Entity visibility to false 'cause it will be drawn to an FXLayer
		}

		/** @inheritDoc */ 
		override protected function _insert(item:*, at:int=0):void 
		{
			super._add(item);
			if (changeVisibility) item.visible = false;	// set Entity visibility to false 'cause it will be drawn to an FXLayer
		}
	}

}