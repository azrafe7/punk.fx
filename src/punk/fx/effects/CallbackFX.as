package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;

	/**
	 * Callback effect.
	 * 
	 * Fakes an FX just so you can call a function whenever it is to be applied to an FX-Graphic (useful for debugging).
	 * 
	 * @author azrafe7
	 */
	public class CallbackFX extends FX
	{
		/** callback function called whenever this (fake) effect is being applied.
		 * (signature: <code>function(bitmapData:BitmapData, clipRect:Rectangle = null</code>)). */
		public var callback:Function = null;
		
		
		/**
		 * Creates a new CallbackFX.
		 * 
		 * @param	callbackFn		callback function called whenever this (fake) effect is being applied.
		 */
		public function CallbackFX(callbackFn:Function=null) 
		{
			super();
			
			this.callback = callbackFn;
		}

		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			if (callback != null && callback is Function) {
				callback(bitmapData, clipRect);
			}
			
			super.applyTo(bitmapData, clipRect);
		}
	}
}