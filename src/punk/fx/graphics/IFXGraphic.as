package punk.fx.graphics 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import punk.fx.lists.FXList;
	
	/**
	 * Simple interface implemented by graphics that support FXs.
	 * 
	 * @author azrafe7
	 */
	public interface IFXGraphic 
	{
		function updateBuffer(clearBefore:Boolean = false):void;
		function render(target:BitmapData, point:Point, camera:Point):void;
		function applyEffects(effects:FXList = null):void;
		function applyMask(drawMask:BitmapData):void;
		function get effects():FXList;
		function get buffer():BitmapData;
		function get onPreRender():Function;
		function get autoUpdate():Boolean;
	}
	
}