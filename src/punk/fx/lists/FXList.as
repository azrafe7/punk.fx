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