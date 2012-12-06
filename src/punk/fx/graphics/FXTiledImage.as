package punk.fx.graphics 
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import net.flashpunk.FP;
	import punk.fx.effects.FX;
	import punk.fx.lists.FXList;
	import flash.utils.getQualifiedClassName;
	import net.flashpunk.graphics.TiledImage;
 
	
	/**
	 * An extended TiledImage class to which FXs can be applied.
	 * 
	 * @author azrafe7
	 */
	public class FXTiledImage extends TiledImage implements IFXGraphic 
	{
		
		/** @private Auto-incremented counter for id. */
		protected static var _idAutoCounter:int = 0;
		
		/** @private Id of the FXTiledImage. */ 
		protected var _id:int = 0;
		
		/** @private Number of FXs associated with this instance. */
		protected var _nEffects:int;
		
		/** @private List of effects associated with this instance. */
		protected var _effects:FXList = new FXList();				// create a new FXList to hold the effects;
		
		/** @private Callback function called just before rendering (signature: <code>function(img:FXTiledImage)</code>). */
		protected var _onPreRender:Function = null;

		/** @private Whether to auto update the buffer every frame. */
		protected var _autoUpdate:Boolean = false;

		/** You can add custom data to this dictionary. */
		public var data:Dictionary = new Dictionary(false);
		
		/** Name of the instance (useful for debugging if the id is not enough). */
		public var name:String = "";
		
		
		/**
		 * Creates a new FXTiledImage with the specified parameters, and assigns an id to it.
		 * 
		 * @param	texture		Source texture.
		 * @param	width		The width of the image (the texture will be drawn to fill this area).
		 * @param	height		The height of the image (the texture will be drawn to fill this area).
		 * @param	clipRect	An optional area of the source texture to use (eg. a tile from a tileset).
		 */
		public function FXTiledImage(texture:*, width:uint = 0, height:uint = 0, clipRect:Rectangle = null)
		{
			super(texture, width, height, clipRect);
			
			active = true;					// sets the FXTiledImage to active (set this to false if you don't want the FXTiledImage to update)
			autoUpdate = true;				// updates the buffer every frame
			_id = _idAutoCounter++;
		}
		
		/**
		 * Renders the FXTiledImage.
		 * 
		 * @param	target		where to draw the FXTiledImage.
		 * @param	point		at which position (in target coords) to draw.
		 * @param	camera		offset position.
		 */
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			if (_autoUpdate && _effects.length > 0) updateBuffer(true);	// update buffer if autoUpdate is set to true
				
			// run onPreRender callback if exists (passing this instance as first parameter)
			if (onPreRender != null && onPreRender is Function) onPreRender(this);

			super.render(target, point, camera);
		}

		/**
		 * Updates the buffer and applies tranforms and effects.
		 * @param	clearBefore		if true the buffer is cleared before drawing to it.
		 */
		override public function updateBuffer(clearBefore:Boolean = false):void 
		{

			// temporarily disable drawMask (to only apply it after the effects)
			var _tempMask:BitmapData = _drawMask;
			_drawMask = null;
			super.updateBuffer(clearBefore);
			_drawMask = _tempMask;
			
			applyEffects();
			
			if (_drawMask) applyMask(_drawMask);
		}
		
		/** Apply effects to buffer. Pass null to use the effects of this instance (default). */
		public function applyEffects(effects:FXList = null):void 
		{
			var fx:FX;
			var _effects:Vector.<*> = (effects ? effects.getAll() : this.effects.getAll());

			// if there are effects to apply...
			if (_effects && (_nEffects = _effects.length)) {
				var i:int;
				
				// apply each associated effect if active
				for (i = 0; i < _nEffects; ++i) {
					fx = _effects[i];
					if (fx.active) fx.applyTo(_buffer, _bufferRect);
				}
			}
		}
		
		/** Apply drawMask to buffer. */
		public function applyMask(drawMask:BitmapData):void 
		{
			_buffer.copyPixels(_buffer, _bufferRect, FP.zero, drawMask, FP.zero);
		}
		
		/**
		 * The BitmapData buffer (untransformed BitmapData that gets drawn to screen).
		 * 
		 * @see net.flashpunk.graphics.Image#_buffer
		 */
		public function get buffer():BitmapData 
		{
			return _buffer;
		}
		
		/**
		 * @private
		 */
		public function set buffer(value:BitmapData):void
		{
			_buffer = value;
			_bufferRect = _buffer.rect;
		}
		
		/**
		 * The FXList associated with this instance.
		 */
		public function get effects():FXList
		{
			return _effects;
		}
		
		/**
		 * @private
		 */
		public function set effects(value:FXList):void
		{
			_effects = value;
		}

		/**
		 * Callback function called just before rendering (signature: <code>function(img:FXTiledImage)</code>).
		 */
		public function get onPreRender():Function
		{
			return _onPreRender;
		}
		
		/**
		 * @private
		 */
		public function set onPreRender(value:Function):void
		{
			_onPreRender = value;
		}
		
		/**
		 * Whether to auto update the buffer every frame.
		 */
		public function get autoUpdate():Boolean
		{
			return _autoUpdate;
		}
		
		/**
		 * @private
		 */
		public function set autoUpdate(value:Boolean):void
		{
			_autoUpdate = value;
		}
		
		/**
		 * String representation of the instance (useful for debugging).
		 * 
		 * @return a string representation of the instance.
		 */
		public function toString():String 
		{
			var className:String = getQualifiedClassName(this);
			return className.substring(className.lastIndexOf(":")+1) + "@" + (name.length ? name : _id);
		}
	}
}