package punk.fx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import punk.fx.effects.Effect;
	
	/**
	 * An extended Image class to which Effects can be applied.
	 * 
	 * @author azrafe7
	 */
	public class ImageFX extends Image 
	{
		
		/** Whether the source is the entire screen. @see #getSource() */ 
		protected var _sourceIsScreen:Boolean;
		
		/** The original source for the image (without effects applied to it). */
		protected var _originalSource:BitmapData;
		
		/** Auto-incremented counter for id. */
		protected static var _idAutoCounter:int = 0;
		
		/** Id of the ImageFX. */ 
		protected var _id:int = 0;
		
		/** Number of Effects associated with this instance. */
		protected var _nEffects:int;
		
		
		/** You can add custom data to this dictionary. */
		public var data:Dictionary = new Dictionary(false);
		
		/** Name of the ImageFX instance (useful for debugging if the id is not enough). */
		public var name:String = "";
		
		/** Callback function called just before rendering (signature: <code>function(imgFX:ImageFX</code>)). */
		public var onPreRender:Function = null;

		/**
		 * Creates a new ImageFX using source and clipRect, and assigns an id to it.
		 * 
		 * @param	source			the source to be used for the ImageFX (can be a BitmapData, a Class or null if you want to use the whole screen).
		 * @param	clipRect		a Rectangle representing the area of the source that you want to use (defaults to the whole source rect).
		 */
		public function ImageFX(source:Object = null, clipRect:Rectangle = null) 
		{
			super(new BitmapData(10, 10));		// dummy call to super constructor
			setSource(source, clipRect);
			active = true;						// set the ImageFX to active (set this to false if you don't want the ImageFX to update)
			_id = _idAutoCounter++;
		}
		
		
		/**
		 * Updates the ImageFX.
		 */
		override public function update():void 
		{
			super.update();
		}
		
		/**
		 * Renders the ImageFX.
		 * 
		 * @param	target		where to draw the ImageFX
		 * @param	point		at which position (in target coords) to draw
		 * @param	camera		offset position
		 */
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			var fx:Effect;
			var _effects:Vector.<Effect> = (effects ? effects.getAll() : null);
			
			// run onPreRender callback if exists (passing this instance as first parameter)
			if (onPreRender != null && onPreRender is Function) onPreRender(this);
			
			// if this instance is associated with some effects...
			if (_effects && (_nEffects = effects.length)) {
				var i:int;
				_originalSource = getSource();
				var clonedSource:BitmapData = _originalSource.clone();
				
				// apply each associated effect if active
				for (i = 0; i < _nEffects; i++) {
					fx = _effects[i];
					if (fx.active) fx.applyTo(clonedSource, clipRect);
				}
				
				_source = clonedSource;
				updateBuffer(true);
				
				// render the ImageFX
				super.render(target, point, camera);
			}
			else {		// no effects... so just render the ImageFX
				_source = _originalSource = getSource();
				if (_sourceIsScreen) updateBuffer();
				super.render(target, point, camera);
			}
		}
		
		/**
		 * Returns the whole BitmapData used as source (recapturing the screen if it's the case).
		 *
		 * @return the whole BitmapData used as source (recapturing the screen if it's the case).
		 */
		public function getSource():BitmapData 
		{
			_source = _sourceIsScreen ? FP.buffer : _originalSource;
			return _source;
		}
		
		/**
		 * Sets the original source for the image (can be Class or BitmapData; defaults to the entire screen) and its clip rectangle. 
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
				trace("createbuf", clipRect);
			}
			
			updateBuffer();
			
			_originalSource = _source;
		}

		public function getOriginalSource():BitmapData 
		{
			return _originalSource;
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
		 * @param	props			an Object containing key/value pairs to be set on the Effect instance.
		 * @param	strictMode		if true (default) an Excpetion will be thrown when trying to assign to properties/vars that don't exist in the Effect instance.
		 * @return the ImageFX itself for chaining.
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
		 * Creates a new rectangle ImageFX.
		 * 
		 * @param	width		width of the rectangle.
		 * @param	height		height of the rectangle.
		 * @param	color		color of the rectangle.
		 * 
		 * @return	a new ImageFX object.
		 */
		public static function createRect(width:uint, height:uint, color:uint = 0xFFFFFF, alpha:Number = 1):ImageFX
		{
			var source:BitmapData = new BitmapData(width, height, true, 0xFFFFFFFF);
			
			var image:ImageFX = new ImageFX(source);
			
			image.color = color;
			image.alpha = alpha;
			
			return image;
		}
		
		/**
		 * Creates a new circle ImageFX.
		 * 
		 * @param	radius		radius of the circle.
		 * @param	color		color of the circle.
		 * @param	alpha		alpha of the circle.
		 * 
		 * @return	a new ImageFX object.
		 */
		public static function createCircle(radius:uint, color:uint = 0xFFFFFF, alpha:Number = 1):ImageFX
		{
			FP.sprite.graphics.clear();
			FP.sprite.graphics.beginFill(0xFFFFFF);
			FP.sprite.graphics.drawCircle(radius, radius, radius);
			var data:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			data.draw(FP.sprite);
			
			var image:ImageFX = new ImageFX(data);
			
			image.color = color;
			image.alpha = alpha;
			
			return image;
		}

		/**
		 * The EffectList associated with this instance.
		 */
		public function get effects():EffectList 
		{
			return FXMan.getEffectsOf(this);
		}
		
		/**
		 * @private
		 */
		public function set effects(value:EffectList):void 
		{
			throw new Error("You must set the effects through FXMan (e.g.: FXMan.add(imageFx, effects)).");
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
		
		/** Synchronize graphics with targetObj's graphics.
		 *
		 * @param targetObj		subclass of Image or one of the classes supported by setSource().
		 */
		public function syncGFXWith(targetObj:*):void 
		{
			if (targetObj is Image) {
				var targetImage:Image = targetObj as Image;
				var maxSize:Number = Math.ceil(Math.sqrt(targetImage.scaledWidth * targetImage.scaledWidth + targetImage.scaledHeight * targetImage.scaledHeight));
				
				var bmd:BitmapData;
				
				if (_bufferRect.width != maxSize || _bufferRect.height != maxSize) {
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
								
				// align spriteFX with source image position
				this.x = this.originX - origin.x + left;
				this.y = this.originY - origin.y + top;
								
				setSource(bmd, bmd.rect);
			} else {
				setSource(ImageFX.getBitmapData(targetObj));
			}
		}
		
		/**
		 * String representation of the ImageFX (useful for debugging).
		 * 
		 * @return a string representation of the ImageFX.
		 */
		public function toString():String 
		{
			var className:String = getQualifiedClassName(this);
			return className.substring(className.lastIndexOf(":")+1) + "@" + (name.length ? name : _id);
		}
	}

}