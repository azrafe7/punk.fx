package punk.fx.effects
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * Base effect class.
	 * 
	 * @author azrafe7
	 */
	public class FX
	{

		/** @private Auto-incremented counter for id. */
		protected static var _idAutoCounter:int = 0;
		
		/** @private Id of the FX. */ 
		protected var _id:int = 0;
		
		/** @private Active state. */
		protected var _active:Boolean = true;
		
		/** @private Matrix for transform operations. */
		protected var _mat:Matrix = new Matrix;
		

		/** Name of the FX instance (useful for debugging if the id is not enough). */
		public var name:String = "";
		
		/** Callback function called just after the effect has been applied 
		 * (signature: <code>function(bitmapData:BitmapData, clipRect:Rectangle = null</code>)). */
		public var onPostProcess:Function = null;

		
		/**
		 * Creates a new FX and assigns an id to it. 
		 * You can use <code>setProps()</code> to assign values to specific properties.
		 * 
		 * @see #setProps()
		 */
		public function FX() 
		{
			_id = _idAutoCounter++;
		}
		
		/**
		 * True if the FX is active.
		 */
		public function get active():Boolean 
		{
			return _active;
		}
		
		/**
		 * @private
		 */
		public function set active(value:Boolean):void 
		{
			_active = value;
		}
		
		/**
		 * Sets the properties specified by the props Object.
		 * 
		 * @example This will set the <code>color</code> and <code>quality</code> properties of <code>effect</code>, 
		 * while skipping the <code>foobar</code> property without throwing an <code>Exception</code> 
		 * since <code>strictMode</code> is set to <code>false</code>.
		 * 
		 * <listing version="3.0">
		 * 
		 * effect.setProps({color:0xff0000, quality:2, foobar:"dsjghkjdgh"}, false);
		 * </listing>
		 * 
		 * @param	props			an Object containing key/value pairs to be set on the FX instance.
		 * @param	strictMode		if true (default) an Excpetion will be thrown when trying to assign to properties/vars that don't exist in the FX instance.
		 * @return the FX itself for chaining.
		 */
		public function setProps(props:*, strictMode:Boolean=true):* 
		{
			for (var prop:* in props) {
				if (this.hasOwnProperty(prop)) this[prop] = props[prop];
				else if (strictMode) throw new Error("Cannot find property " + prop + " on " + this + ".");
			}
			
			return this;
		}
		
		
		/**
		 * Applies the effect to the clipRect region of bitmapData (typically overridden in subclasses).
		 * 
		 * @see punk.fx.FXImage#render()
		 * 
		 * @param	bitmapData		target of the FX.
		 * @param	clipRect		Rectangle within bitmapData to which apply the effect.
		 */
		public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void 
		{
			// run onPostProcess callback if exists (passing bitmapData and clipRect as parameters)
			if (onPostProcess != null && onPostProcess is Function) onPostProcess(bitmapData, clipRect);			
		}
		
		/**
		 * String representation of the FX (useful for debugging).
		 * 
		 * @return a string representation of the FX.
		 */
		public function toString():String 
		{
			var className:String = getQualifiedClassName(this);
			return className.substring(className.lastIndexOf(":")+1) + "@" + (name.length ? name : _id);
		}
	}

}