package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import punk.fx.FXImage;

	/**
	 * FiltersEffect lets you apply one or multiple Flash BitmapFilters (DropShadow, BlurFilter, etc.) at once.
	 * 
	 * @author azrafe7
	 */
	public class FilterEffect extends Effect
	{
		
		/** array of filters used for the effect */
		public var filters:Array = [];
		
		
		/**
		 * Creates a new FiltersEffect with the specified values.
		 * 
		 * @see #setProps()
		 * 
		 * @param	filters		an Array/Vector of filters or a single filter to apply.
		 */
		public function FilterEffect(filters:*=null) 
		{
			super();
			
			if (!filters) return;
			
			if (filters is Array) this.filters = filters;
			else if (filters is Vector.<*>) {
				for (var i:int = 0; i < filters.length; i++) {
					this.filters.push(filters[i]);
				}
			} else if (filters is BitmapFilter) this.filters = [filters];
			else throw new Error("Invalid filters parameter. You must pass an Array/Vector of filters or a single filter.");
			
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			for (var i:int = 0; i < filters.length; i++)
				bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, filters[i]);

			super.applyTo(bitmapData, clipRect);
		}
		
	}

}