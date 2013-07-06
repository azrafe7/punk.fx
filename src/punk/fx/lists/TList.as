package punk.fx.lists
{
	import flash.utils.getQualifiedClassName;

	/**
	 * Vector-like container for generic items.
	 * 
	 * @author azrafe7
	 */
	public class TList 
	{
		/** A Vector holding the items. */
		protected var _items:Vector.<*> = new Vector.<*>;
		
		/** If true prevents duplicated items to be added. */
		protected var _ensureUniqueness:Boolean = true;
		
		/** 
		 * Compare function used to sort the list (applied after each add() and insert() call).
		 * 
		 * <p>A function that takes two arguments of type T of the Vector and returns a Number:
		 * 
		 * <code>function compare(itemA:T, itemB:T):Number {}</code>
		 * </p>
		 * 
		 * The logic of the function is that, given two elements a and b, the function returns one of the following three values:
		 * 
		 * <ul>
		 * 		<li>a negative number, if a should appear before b in the sorted sequence</li>
		 * 		<li>0, if a equals b</li>
		 * 		<li>a positive number, if a should appear after b in the sorted sequence</li>
		 * </ul>
		 */
		public var compareFunction:Function;
		
		 
		/**
		 * Creates a new TList.
		 * 
		 * @param	items			a single item or a Vector/Array of items to be added to the list.
		 * @param	uniqueness		set this to true if you want to ensure that no duplicated items are added to the list (defaults to true).
		 */
		public function TList(items:* = null, uniqueness:Boolean = true)
		{
			_ensureUniqueness = uniqueness;
			
			if (items) {
				add(items);
			}
		}
		
		/**
		 * Checks if one or more items are in the TList.
		 * 
		 * @param	items		a single item or a Vector/Array of items to be checked for.
		 * 
		 * @return true if ALL of the items specified are found in the list.
		 */
		public function contains(items:*):Boolean
		{
			var found:int;
			var i:int = _items.length;
			var itemArray:*;
			
			if (items is Array || items is Vector.<*>) itemArray = items;
			else if (items is TList) itemArray = items.getAll();
			else itemArray = [items];

			var j:int = itemArray.length-1;
			while (i-- && j > -1) {
				if (_items[i] == itemArray[j]) {
					found++;
					j--;
				}
			}
			
			return (found == itemArray.length);
		}
		
		/**
		 * Used internally to add an item to the TList.
		 * 
		 * @private
		 */
		protected function _add(item:*):void 
		{
			item = _validate(item);
			if (!(_ensureUniqueness && contains(item))) _items[_items.length] = item;
		}
		
		/**
		 * Adds one or more items to the TList.
		 * 
		 * @param	items		a single item or a Vector/Array of items to be added to the list.
		 * @return the TList itself for chaining.
		 */
		public function add(items:*):TList {
			var item:*;
			var itemArray:*;
			
			if (items is Array || items is Vector.<*>) itemArray = items;
			else if (items is TList) itemArray = items.getAll();
			else itemArray = [items];
			
			for each (item in itemArray) _add(item);
			
			sort();
			
			return this;
		}
		
		/**
		 * Override this to convert an object to a valid FX.
		 * 
		 * @private
		 */
		protected function _validate(item:*):*
		{
			throw new Error("You must override this method in a subclass of TList.");
		}

		/**
		 * Used internally to insert an item into the TList.
		 * 
		 * @private
		 */
		protected function _insert(item:*, at:int=0):void 
		{
			item = _validate(item);
			if (!(_ensureUniqueness && contains(item))) _items.splice(at, 0, item);
		}
		
		/**
		 * Inserts one or more items to the TList at the specified index.
		 * 
		 * @param	items		a single item or a Vector/Array of items to be inserted into the list.
		 * @param	at			index at which items will be inserted (defaults to 0).
		 * @return the TList itself for chaining.
		 */
		public function insert(items:*, at:int=0):TList 
		{
			var item:*;
			var itemArray:*;
			
			if (items is Array || items is Vector.<*>) itemArray = items;
			else if (items is TList) itemArray = items.getAll();
			else itemArray = [items];

			for (var i:int = itemArray.length - 1; i >= 0; i--) _insert(itemArray[i], at);
			
			sort();
			
			return this;
		}
		
		/**
		 * Used internally to remove items from the TList.
		 * 
		 * @private
		 */
		protected function _remove(item:*):void 
		{
			var i:int = _items.length;
			
			if (item == null) throw new Error("Item cannot be null.");
			while (i--) {
				if (_items[i] == item) _items.splice(i, 1);
			}
		}
		
		/**
		 * Removes a single item or a Vector/Array of items from the TList.
		 * 
		 * @param	items		a single item or a Vector/Array of items to be removed from the list.
		 * 
		 * @return the TList itself for chaining.
		 */
		public function remove(items:*):TList {
			var item:*;
			var itemArray:*;
			
			if (items is Array || items is Vector.<*>) itemArray = items;
			else if (items is TList) itemArray = items.getAll();
			else itemArray = [items];

			for each (item in itemArray) _remove(item);
			
			return this;
		}
		
		/**
		 * Removes the item at the specified index from the TList.
		 * 
		 * @param	index		the index of the FX to be removed.
		 * 
		 * @return the TList itself for chaining.
		 */
		public function removeAt(index:*):TList {
			var idx:Number;
			var idxArray:*;
			
			if (index is Array || index is Vector.<*>) idxArray = index;
			else idxArray = [index];

			for each (idx in idxArray) _remove(this.at(idx));
			
			return this;
		}
		
		/**
		 * Removes all the items from the TList.
		 * 
		 * @return the TList itself for chaining.
		 */
		public function clear():TList 
		{
			_items.length = 0;
			
			return this;
		}
		
		/** Sorts the list using the specified compareFunc or this instance's compareFunction (default). */
		public function sort(compareFunc:Function = null):void 
		{
			compareFunc = compareFunc || compareFunction;
			if (compareFunc != null && compareFunc is Function) _items.sort(compareFunc);
		}
	
		/**
		 * Executes a callback function passing each item in the TList as the first parameter.
		 * 
		 * @param	callback		a function with signature <code>function(item:*)</code> that gets called for each item in the list (in order).
		 */
		public function forEach(callback:Function):void 
		{
			for (var i:int = 0; i < _items.length; ++i) callback.apply(null, [_items[i]]);
		}
		
		/**
		 * Returns the item at the specified index in the TList.
		 * 
		 * @param	idx		the index of the item to fetch.
		 * @return the item at idx.
		 */
		public function at(idx:int):* 
		{
			return _items[idx];
		}
		
		/**
		 * Returns the index of the specified item in the list (or -1 if it's not found).
		 * 
		 * @param	item		the item to search for.
		 * @return the index of the item.
		 */
		public function indexOf(item:*):int
		{
			return _items.indexOf(item);
		}
		
		/**
		 * Returns the Vector of items containing all the items in the TList (it's not a copy so _beware_).
		 * 
		 * @return a Vector of items of all the items in the list.
		 */
		public function getAll():Vector.<*> 
		{
			return _items;
		}
		
		/**
		 * Number of items in the TList.
		 */
		public function get length():int 
		{
			return _items.length;
		}
		
		/**
		 * True if no duplicated items can be added to the TList.
		 * @see #TList()
		 */
		public function get ensureUniqueness():Boolean 
		{
			return _ensureUniqueness;
		}
		
		/**
		 * String representation of the TList (useful for debugging).
		 * 
		 * @return a string representation of the list of items.
		 */
		public function toString():String 
		{
			var l:int = _items.length;
			var className:String = getQualifiedClassName(this);
			className = className.substring(className.lastIndexOf(":") + 1);
			
			var res:String = className + "[ ";
			
			for (var i:int = 0; i < l; ++i) {
				res += _items[i] + " ";
			}
			res += "]";
			return res;
		}
	}

}