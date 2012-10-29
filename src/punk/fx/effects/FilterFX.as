package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;

	/**
	 * FilterFX lets you apply one or multiple Flash BitmapFilters (DropShadow, BlurFilter, etc.) at once. 
	 * It also support ShaderFilters created with Pixel Bender.
	 * 
	 * @author azrafe7
	 */
	public class FilterFX extends FX
	{
		
		/** array of filters used for the effect */
		public var filters:Array = [];
		
		
		/**
		 * Creates a new FilterFX with the specified values.
		 * 
		 * @see #setProps()
		 * 
		 * @param	filters		an Array/Vector of filters or a single filter to apply.
		 */
		public function FilterFX(filters:*=null) 
		{
			super();
			
			if (!filters) return;
			
			if (filters is Array) this.filters = filters;
			else if (filters is Vector.<*>) {
				for (var i:int = 0; i < filters.length; ++i) {
					this.filters[i] = filters[i];
				}
			} else if (filters is BitmapFilter) this.filters = [filters];
			else throw new Error("Invalid filters parameter. You must pass an Array/Vector of filters or a single filter.");
			
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			var filter:BitmapFilter;
			
			for (var i:int = 0; i < filters.length; ++i) {
			
				filter = filters[i];
				
				if (filter is ShaderFilter) {
					PBShaderFilterFX.applyShaderFilter(bitmapData, clipRect, bitmapData, clipRect.topLeft, filter as ShaderFilter);
				} else {
					bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, filter);
				}
			}
			
			super.applyTo(bitmapData, clipRect);
		}
		
	}

}