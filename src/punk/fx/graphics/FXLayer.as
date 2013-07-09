package punk.fx.graphics 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import punk.fx.lists.EntityList;
	
	/**
	 * An extended FXImage class that works as an overlay, making it possible to apply FXs to a list of entities.
	 * 
	 * @author azrafe7
	 */
	public class FXLayer extends FXImage 
	{
		/** @private Number of entities associated with this instance. */
		protected var _nEntities:int;
		
		
		/** Color used to clear the source buffer. */
		public var bgColor:uint;
		
		/** Whether the source buffer should be cleared everytime the instance is rendered. */
		public var autoClearSource:Boolean;
		
		/** Entity list to which effects will be applied */
		public var entities:EntityList = new EntityList(null, true, false, true);
		
		
		/**
		 * Creates a new FXLayer with the specified parameters, and assigns an id to it.
		 * 
		 * @param	width			width of the layer (defaults to screen width).
		 * @param	height			height of the layer (defaults to screen height).
		 * @param   bgColor			color used to clear the source buffer.
		 * @param	clipRect		a Rectangle representing the area of the source that you want to use (defaults to the whole source rect).
		 * @param   autoClearSource whether the source buffer should be cleared everytime the instance is rendered.
		 */
		public function FXLayer(width:Number = 0, height:Number = 0, bgColor:uint=0, clipRect:Rectangle = null, autoClearSource:Boolean = true)
		{
			this.bgColor = bgColor;
			this.autoClearSource = autoClearSource;
			_source = new BitmapData(width ? width : FP.width, height ? height : FP.height, true, bgColor);
			
			super(_source, clipRect);
		}
		
		/**
		 * Renders the FXLayer.
		 * 
		 * @param	target		where to draw the FXLayer.
		 * @param	point		at which position (in target coords) to draw.
		 * @param	camera		offset position.
		 */
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			var entity:Entity;
			var _entities:Vector.<*> = (entities ? entities.getAll() : null);

			// clear source buffer if needed
			if (autoClearSource) _source.fillRect(_sourceRect, bgColor);
			
			// if there are entities to render...
			if (_entities && (_nEntities = _entities.length)) {
				var i:int;
				var tmpTarget:BitmapData;

				// render each entity to the source buffer
				for (i = 0; i < _nEntities; ++i) {
					entity = _entities[i];
					tmpTarget = entity.renderTarget;
					entity.renderTarget = _source;
					entity.render();
					entity.renderTarget = tmpTarget;
				}
			}

			super.render(target, FP.zero, FP.zero);
		}
	}

}