package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.display.ShaderParameter;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * Wrapper for loading and applying Pixel Bender Effects at run-time. 
	 * 
	 * But a better approach is to embed the pbj file and create ad-hoc getters/setters.
	 * 
	 * @see PBHalfToneEffect
	 * 
	 * @author azrafe7
	 */
	public class PixelBenderEffect extends Effect
	{
		/** @private URLLoader used to load the pbj file. */
		protected var _urlLoader:URLLoader;

		
		/** Shader instance created from the pbj data. */
		public var shader:Shader;
		
		/** ShaderFilter instance created from shader (you can pass this to a FilterEffect). @see FilterEffect */
		public var filter:ShaderFilter;
		
		/** 
		 * Shortcut for filter.shader.data (useful for modifying the filter parameters). 
		 * 
		 * <p>Remember that the parameters must be specified with array notation and set through the <code>value</code> property.
		 * <listing version="3.0">
		 * pbEffect.params.amount.value = [10];   // or pbEffect.params.amount[0] = 10;
		 * trace(pbEffect.params.center[1]);
		 * pbEffect.params.center.value = [100.5, 200];
		 * </listing></p>
		 */
		public var params:ShaderData;
		
		/** Function called when a pbj file has been fully loaded. */
		public var onLoadingComplete:Function = null;
		
		
		/** 
		 * PixelBenderEffect constructor.
		 * 
		 * @param pbjData			url of a pbj file to load (relative to the position of the swf) or an embedded Shader class.
		 * @param loadedCallback	optional callback for when the pbj data has fully loaded (only if pbjData is a url).
		 */
		public function PixelBenderEffect(pbjData:*=null, loadedCallback:Function = null) 
		{
			onLoadingComplete = loadedCallback;
			if (pbjData) loadPBJ(pbjData);
		}
		
		/**
		 * Loads a Pixel Bender effect from pbjData (asynchronously if it's from a url).
		 * 
		 * @param pbjData			url of a pbj file to load (relative to the position of the swf) or an embedded Shader class.
		 * @param loadedCallback	optional callback for when the pbj data has fully loaded (only if pbjData is a url).
		 */
		public function loadPBJ(pbjData:*, loadedCallback:Function = null):void 
		{
			
			onLoadingComplete = loadedCallback || onLoadingComplete;

			if (pbjData is String) {	// load from file
				var urlRequest:URLRequest = new URLRequest(pbjData);
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _loadingError, false, 0, true);
				_urlLoader.addEventListener(Event.COMPLETE, _filterLoaded, false, 0, true);
				_urlLoader.load(urlRequest);
			} else if (pbjData is Class || pbjData is ByteArray) {	// load from embedded Class or ByteArray
				setShaderFromData(pbjData is Class ? new pbjData as ByteArray : pbjData);
			}
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;
			
			bitmapData.applyFilter(bitmapData, clipRect, clipRect.topLeft, filter);

			super.applyTo(bitmapData, clipRect);
		}
		
		/**
		 * Returns info about the Pixel Bender filter loaded such as params type and descriptions.
		 */
		public function get info():String 
		{
			if (!shader) return "";
			
			var infoStr:String = "";
			var parmType:String;
			
			for (var prop:String in shader.data)
			{
				parmType = "";
				
				// parameter type
				if (shader.data[prop] is ShaderParameter) parmType = "(" + (shader.data[prop] as ShaderParameter).type + ") ";
			
				// property name and type
				infoStr += parmType + prop + ": " + shader.data[prop] + "\n";
			   
			    // sub-property info
				for (var d:String in shader.data[prop])
				{
					infoStr += "\t" + d + ": " + shader.data[prop][d] + "\n";
				}
			}
			
			return infoStr;
		}
		
		/**
		 * Returns info about the specified Pixel Bender shader such as params type and descriptions.
		 */
		public static function getInfo(shader:Shader):String 
		{
			if (!shader) return "";
			
			var infoStr:String = "";
			var parmType:String;
			
			for (var prop:String in shader.data)
			{
				parmType = "";
				
				// parameter type
				if (shader.data[prop] is ShaderParameter) parmType = "(" + (shader.data[prop] as ShaderParameter).type + ") ";
			
				// property name and type
				infoStr += parmType + prop + ": " + shader.data[prop] + "\n";
			   
			    // sub-property info
				for (var d:String in shader.data[prop])
				{
					infoStr += "\t" + d + ": " + shader.data[prop][d] + "\n";
				}
			}
			
			return infoStr;
		}
		
		/** Fires when all data has been loaded from a pbj file and calls the onLoadingComplete callback function. */
		protected function _filterLoaded(evt:Event):void 
		{
			_urlLoader.removeEventListener(Event.COMPLETE, _filterLoaded);
			setShaderFromData(evt.target.data);
			if (onLoadingComplete != null && onLoadingComplete is Function) onLoadingComplete();
		}
		
		/** Creates a new Shader and a new ShaderFilter from data. */
		public function setShaderFromData(data:ByteArray):void
		{
			shader = new Shader(data);
			if (shader.data.input && shader.data.input.length > 1) throw new Error("ShaderFilter can only have one input image. Cannot convert the loaded Shader to a ShaderFilter.");
			filter = new ShaderFilter(shader);
			params = shader.data;
		}
		
		
		/** @private Called when errors occur while loading the pbjFile from loadPBJ(). */
		protected function _loadingError(evt:Event):void 
		{
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _loadingError);
			shader = null;
			filter = null;
			params = null;
			throw new Error((evt as IOErrorEvent));
		}
		
	}

}