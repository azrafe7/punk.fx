package punk.fx.lists
{
	import flash.filters.BitmapFilter;
	import punk.fx.effects.FilterFX;
	import punk.fx.effects.FX;

	/**
	 * Vector-like container for FXs.
	 * 
	 * @author azrafe7
	 */
	public class FXList extends TList
	{

		/**
		 * Creates a new FXList.
		 * 
		 * @param	items			a single effect or a Vector/Array of effects to be added to the list.
		 * @param	uniqueness		set this to true if you want to ensure that no duplicated effects are added to the list (defaults to true).
		 */
		public function FXList(items:* = null, uniqueness:Boolean = true)
		{
			super(items, uniqueness);
		}

			
		/**
		 * Used internally to convert an object to a valid FX.
		 * 
		 * @private
		 */
		override protected function _validate(item:*):*
		{
			var fx:* = item;
			
			if (item is Class) fx = new item;
			if (fx is BitmapFilter || item is BitmapFilter) fx = new FilterFX(fx);
			
			if (fx == null || !(fx is FX)) throw new Error("Invalid or null effect.");
			return fx;
		}

	}

}