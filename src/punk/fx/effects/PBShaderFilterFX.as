package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.display.ShaderInput;
	import flash.display.ShaderParameter;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import net.flashpunk.FP;
	
	/**
	 * Wrapper for loading and applying Pixel Bender shaders at run-time. 
	 * 
	 * <p>A better approach would be to embed the pbj file in a class with ad-hoc getters/setters (as PBWaterFallFX does).</p>
	 * 
	 * <p>Or use tools like PBJ2ShaderFilter to generate a proper ShaderFilter class 
	 * (parameters' getters/setters included) from a pbj file, and then use the result in
	 * combination with the FilterFX class.</p>
	 * 
	 * @see #params
	 * @see PBWaterFallFX
	 * @see FilterFX
		* @see http://xperiments.es/blog/en/pbj2shaderfilter-air-tool-to-generate-a-shaderfilter-class-from-pixel-bender-files/ PBJ2ShaderFilter AIR tool
	 * 
	 * @author azrafe7
	 */
	public class PBShaderFilterFX extends FX
	{
		/** @private URLLoader used to load the pbj file. */
		protected var _urlLoader:URLLoader;

		
		/** Shader instance created from the pbj data. */
		public var shader:Shader;
		
		/** ShaderFilter instance created from shader (you can pass this to a FilterFX). @see FilterFX */
		public var filter:ShaderFilter;
		
		/** 
		 * Shortcut for filter.shader.data (useful for modifying the filter parameters). 
		 * 
		 * <p>Remember that the parameters must be specified with array notation and set through the <code>value</code> property.
		 * <listing version="3.0">
		 * pxbFX.params.amount.value = [10];   // or pxbFX.params.amount[0] = 10;
		 * trace(pxbFX.params.center[1]);
		 * pxbFX.params.center.value = [100.5, 200];
		 * </listing></p>
		 */
		public var params:ShaderData;
		
		/** Function called when a pbj file has been fully loaded. */
		public var onLoadingComplete:Function = null;
		
		
		/** 
		 * PBShaderFilterFX constructor.
		 * 
		 * @param pbjData			url of a pbj file to load (relative to the position of the swf) or an embedded Shader class.
		 * @param loadedCallback	optional callback for when the pbj data has fully loaded (only if pbjData is a url).
		 */
		public function PBShaderFilterFX(pbjData:*=null, loadedCallback:Function = null) 
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
			
			PBShaderFilterFX.applyShaderFilter(bitmapData, clipRect, bitmapData, clipRect.topLeft, filter);
			
			super.applyTo(bitmapData, clipRect);
		}
		
		/**
		 * Takes a source image, a destination image and a ShaderFilter object and generates the filtered image.
		 *
		 * <p>There seems to be a bug with Pixel Bender Shaders (unsolved as of Flash Player 11.1), 
		 * which causes the applyFilter function to not take into account sourceRect.x and sourceRect.y props.
		 * So... if the sourceRect top-left corner is different from 0,0 this function will apply the filter to 
		 * a temp BitmapData first and then copy the result back to destBitmapData. 
		 * Hope to find a faster way to work around the issue.</p>
		 *	
		 * @param	sourceBitmapData	the input bitmap image to use. The source image can be a different 
		 *   							BitmapData object or it can be the same as destBitmapData.
		 * @param	sourceRect			A rectangle that defines the area of the source image to use as input.
		 * @param	destBitmapData		the output bitmap image to use. The destination image can be a different 
		 *   							BitmapData object or it can be the same as sourceBitmapData.
		 * @param	destPoint			the point within the destination image that corresponds to the upper-left 
		 * 								corner of the source rectangle.
		 * @param	filter				the filter object that you use to perform the filtering operation.
		 */
		public static function applyShaderFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destBitmapData:BitmapData, destPoint:Point, filter:ShaderFilter):void 
		{			
			if (sourceRect.x != 0.0 && sourceRect.y != 0.0) {
				var tempBMD:BitmapData = new BitmapData(sourceRect.width, sourceRect.height, true, 0);
				tempBMD.copyPixels(sourceBitmapData, sourceRect, FP.zero);
				tempBMD.applyFilter(tempBMD, tempBMD.rect, FP.zero, filter);
				destBitmapData.copyPixels(tempBMD, tempBMD.rect, destPoint);
				tempBMD.dispose();
				tempBMD = null;
			} else {
				destBitmapData.applyFilter(sourceBitmapData, sourceRect, destPoint, filter);
			}
		}
		
		/**
		 * Returns info about the Pixel Bender filter loaded such as params type and descriptions.
		 */
		public function get info():String 
		{			
			return getInfo(shader);
		}
		
		/**
		 * Returns info about the specified Pixel Bender shader such as params type and descriptions.
		 */
		public static function getInfo(shader:Shader):String 
		{
			if (!shader) return "";
			
			var infoStr:String = "";
			var prop:String;
			var _params:* = { };
			var _inputs:* = { };
			
			for (prop in shader.data)
			{
				if (shader.data[prop] is ShaderParameter) _params[prop] = shader.data[prop];	// parameter
				else if (shader.data[prop] is ShaderInput) _inputs[prop] = shader.data[prop];   // input
				else infoStr += prop + ": " + shader.data[prop] + "\n";		// other props
			}
			infoStr += " -- PARAMS -- \n";
			for (prop in _params) {
				var _param:ShaderParameter = _params[prop] as ShaderParameter;
				infoStr += "(" + _param.type + ") " + prop + "\n";
				for (var d:String in _param) infoStr += "   " + d + ": " + _param[d] + "\n";
			}
			infoStr += " -- INPUTS --\n";
			for (prop in _inputs) {
				infoStr += prop + "\n";
			}
			_params = null;
			_inputs = null;
			return infoStr;
		}
		
		/** Fires when all data has been loaded from a pbj file and calls the onLoadingComplete callback function (if has been set). */
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