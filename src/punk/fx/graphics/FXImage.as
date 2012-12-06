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
	import net.flashpunk.graphics.Image;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
 
	
	/**
	 * An extended Image class to which FXs can be applied.
	 * 
	 * @author azrafe7
	 */
	public class FXImage extends Image implements IFXGraphic 
	{
		
		/** @private Whether the source is the entire screen. @see #getSource() */
		protected var _sourceIsScreen:Boolean;
		
		/** @private Auto-incremented counter for id. */
		protected static var _idAutoCounter:int = 0;
		
		/** @private Id of the FXImage. */ 
		protected var _id:int = 0;
		
		/** @private Number of FXs associated with this instance. */
		protected var _nEffects:int;
		
		/** @private List of effects associated with this instance. */
		protected var _effects:FXList = new FXList();				// create a new FXList to hold the effects;
		
		/** @private Callback function called just before rendering (signature: <code>function(img:FXImage)</code>). */
		protected var _onPreRender:Function = null;

		/** @private Whether to auto update the buffer every frame. */
		protected var _autoUpdate:Boolean = false;

		/** You can add custom data to this dictionary. */
		public var data:Dictionary = new Dictionary(false);
		
		/** Name of the instance (useful for debugging if the id is not enough). */
		public var name:String = "";
		
		/** 
		 * Sync the graphics with this object (can be any of the classes supported by cloneGraphicsFrom). 
		 * Auto-updates every frame. 
		 * @see #cloneGraphicsFrom()
		 */
		public var syncWith:* = null;
		

		/**
		 * Creates a new FXImage with the specified parameters, and assigns an id to it.
		 * 
		 * @param	source			the source to be used for the FXImage (can be a BitmapData, a Class or null if you want to use the whole screen).
		 * @param	clipRect		a Rectangle representing the area of the source that you want to use (defaults to the whole source rect).
		 */
		public function FXImage(source:Object = null, clipRect:Rectangle = null) 
		{
			super(new BitmapData(10, 10));		// dummy call to super constructor
			setSource(source, clipRect);
			
			active = true;					// sets the FXImage to active (set this to false if you don't want the FXImage to update)
			autoUpdate = true;				// updates the buffer every frame
			_id = _idAutoCounter++;
		}
		
		/**
		 * Renders the FXImage.
		 * 
		 * @param	target		where to draw the FXImage.
		 * @param	point		at which position (in target coords) to draw.
		 * @param	camera		offset position.
		 */
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			if (syncWith) cloneGraphicsFrom(syncWith);						// clone graphics from syncWith object if it is set
			else if (_sourceIsScreen || (_autoUpdate /*&& _effects.length > 0*/)) updateBuffer(true);	// update buffer if the source is the whole screen or autoUpdate is set to true
				
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
			_source = getSource();

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
		 * Callback function called just before rendering (signature: <code>function(img:FXImage)</code>).
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

		/**
		 * Returns the whole BitmapData used as source (recapturing the screen if it's the case).
		 *
		 * @return the whole BitmapData used as source.
		 */
		public function getSource():BitmapData 
		{
			return _source = _sourceIsScreen ? FP.buffer : _source;
		}
		
		/**
		 * Sets the source for the image (can be Class or BitmapData; defaults to the entire screen) and its clip rectangle. 
		 * NB: Doesn't reset image properties (like origin, alpha, etc.).
		 * 
		 * @param	source			Class or BitmapData to use as source (null means FP.buffer... so the whole screen).
		 * @param	clipRect		Rectangle representing the area of the source to be used (defaults to the whole source rect).
		 */
		public function setSource(source:Object = null, clipRect:Rectangle = null):void 
		{
			// assign the source and check if it is the whole screen
			_source = (source != null ? getBitmapData(source) : FP.buffer);
			_sourceIsScreen = (_source == FP.buffer);
			_sourceRect = _source.rect;
			
			// set the clip rectangle
			if (clipRect)
			{
				if (!clipRect.width) clipRect.width = _sourceRect.width;
				if (!clipRect.height) clipRect.height = _sourceRect.height;
				_sourceRect = clipRect;
			} else (clipRect = _sourceRect);
			
			// recreate the buffer if needed
			if (!_buffer || (_buffer.width != clipRect.width && _buffer.height != clipRect.height)) {
				createBuffer();
				//trace("FXImage: createbuf", clipRect);
			}
			
			updateBuffer();			
		}
		
		/** Clone graphics from targetObj's graphics.
		 *
		 * @param targetObj		subclass of Image or one of the classes supported by setSource().
		 */
		public function cloneGraphicsFrom(targetObj:*):void 
		{
			if (targetObj is Image) {
				var targetImage:Image = targetObj as Image;
				var maxSize:Number = Math.ceil(Math.sqrt(targetImage.scaledWidth * targetImage.scaledWidth + targetImage.scaledHeight * targetImage.scaledHeight));
				
				var bmd:BitmapData;
				
				if (_bufferRect.width != maxSize || _bufferRect.height != maxSize) {
					trace(_bufferRect.width, maxSize);
					bmd = new BitmapData(maxSize, maxSize, true, 0);
					setSource(bmd);
				} else {
					bmd = getSource();
					bmd.fillRect(bmd.rect, 0);
				}
				
				// set up transformation matrix
				var m:Matrix = new Matrix();
				m.translate(-targetImage.originX, -targetImage.originY);
				m.rotate(targetImage.angle * FP.RAD);
				m.translate(targetImage.originX, targetImage.originY);
				m.scale(targetImage.scaleX * targetImage.scale, targetImage.scaleY * targetImage.scale);

				// four corners of the bounding box after transformation
				var topLeft:Point = m.transformPoint(new Point(0, 0));
				var topRight:Point = m.transformPoint(new Point(targetImage.width, 0));
				var bottomLeft:Point = m.transformPoint(new Point(0, targetImage.height));
				var bottomRight:Point = m.transformPoint(new Point(targetImage.width, targetImage.height));
				
				// origin point after transformation
				var origin:Point = m.transformPoint(new Point(targetImage.originX, targetImage.originY));

				// bounding box distances
				var top:Number = Math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
				var bottom:Number = Math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
				var left:Number = Math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
				var right:Number = Math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);

				// size of the new BitmapData
				var height:Number = bottom - top;
				var width:Number = right - left;
								
				targetImage.render(bmd, new Point(origin.x - left, origin.y - top), FP.zero);
								
				// align with target image position
				this.x = this.originX - origin.x + left;
				this.y = this.originY - origin.y + top;
								
				setSource(bmd, bmd.rect);
			} else {
				setSource(FXImage.getBitmapData(targetObj));
			}
		}
		
		/**
		 * Creates a new rectangle FXImage.
		 * 
		 * @param	width		width of the rectangle.
		 * @param	height		height of the rectangle.
		 * @param	color		color of the rectangle.
		 * 
		 * @return	a new FXImage object.
		 */
		public static function createRect(width:uint, height:uint, color:uint = 0xFFFFFF, alpha:Number = 1):FXImage
		{
			var source:BitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
			
			var image:FXImage = new FXImage(source);
			
			image.color = color;
			image.alpha = alpha;
			
			return image;
		}
		
		/**
		 * Creates a new circle FXImage.
		 * 
		 * @param	radius		radius of the circle.
		 * @param	color		color of the circle.
		 * @param	alpha		alpha of the circle.
		 * 
		 * @return	a new FXImage object.
		 */
		public static function createCircle(radius:uint, color:uint = 0xFFFFFF, alpha:Number = 1):FXImage
		{
			FP.sprite.graphics.clear();
			FP.sprite.graphics.beginFill(0xFFFFFF);
			FP.sprite.graphics.drawCircle(radius, radius, radius);
			var data:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			data.draw(FP.sprite);
			
			var image:FXImage = new FXImage(data);
			
			image.color = color;
			image.alpha = alpha;
			
			return image;
		}
	
		/** Returns a BitmapData object from sourceObj. 
		 * 
		 * @param sourceObj		can be a Class holding a Bitmap, a Bitmap or a BitmapData object. */
		public static function getBitmapData(sourceObj:Object):BitmapData 
		{
			var res:BitmapData = null;
			if (sourceObj is Class) res = FP.getBitmap(sourceObj as Class);
			else if (sourceObj is Bitmap) res = Bitmap(sourceObj).bitmapData;
			else if (sourceObj is BitmapData) res = sourceObj as BitmapData;
			if (!res) throw new Error("Invalid source image.");
			return res;
		}
		
	}
}