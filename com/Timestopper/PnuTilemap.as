package com.Timestopper
{

	import org.flixel.*
	import flash.filters.*;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.geom.Point;

	public class PnuTilemap extends FlxTilemap
	{
		// Old method, possible more efficient
		// private static var _satFilter:ColorMatrixFilter = new ColorMatrixFilter([0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0, 0, 0, 1, 0]);

		// New method, more flexible
		[Embed(source="../../data/Saturation.pbj", mimeType="application/octet-stream")] 
		private static var SaturationShader:Class;
		private static var _sat_filter:ShaderFilter = new ShaderFilter(new Shader(new SaturationShader()));
		_sat_filter.shader.data.saturation.value = [0.0];

		private var _alt_pixels:BitmapData;
		private var _time_stopped:Boolean;
		
		public function PnuTilemap()
		{
			super();
		}
		
		override public function loadMap(MapData:String, TileGraphic:Class, TileWidth:uint=0, TileHeight:uint=0):FlxTilemap
		{
			var returnMap:FlxTilemap = super.loadMap(MapData, TileGraphic, TileWidth, TileHeight);
			
			// Generate desaturated sprite
			_alt_pixels = _pixels.clone();
			_alt_pixels.applyFilter(_alt_pixels, _alt_pixels.rect, new Point(), _sat_filter);
			
			return returnMap;
		}
		
		public function get timeStopped():Boolean { return _time_stopped; }

		public function set timeStopped(TimeStopped:Boolean):void
		{
			// If nothing new
			if(_time_stopped == TimeStopped)
				return;

			_time_stopped = TimeStopped;

			var tempPixels:BitmapData;

			// Swap pixels
			tempPixels = _pixels.clone();
			_pixels = _alt_pixels.clone();
			_alt_pixels = tempPixels.clone();
		}

		public function toggleTime():void
		{
			timeStopped = !_time_stopped;
		}

	}

}

