package punk.fx.effects 
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;

	/**
	 * Pixel Bender effect base class from which actual Pixel Bender filters implementations inherit.
	 * 
	 * @author azrafe7
	 */
	public class PBBaseFX extends FX 
	{
		
		/** Shader instance created from the pbj data. */
		public var shader:Shader;
		
		/** ShaderFilter instance created from shader (you can pass this to a FilterFX). @see FilterFX */
		public var filter:ShaderFilter;
		

		public function PBBaseFX() 
		{
			super();
		}
		
		/** @inheritDoc */
		override public function applyTo(bitmapData:BitmapData, clipRect:Rectangle = null):void
		{
			if (!clipRect) clipRect = bitmapData.rect;

			PBShaderFilterFX.applyShaderFilter(bitmapData, clipRect, bitmapData, clipRect.topLeft, filter);

			super.applyTo(bitmapData, clipRect);
		}
		
	}

}