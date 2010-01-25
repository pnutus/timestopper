package com.Timestopper
{

	import org.flixel.*;
	import flash.filters.*;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.geom.Point;

	public class PnuSprite extends FlxSprite
	{
		// Old method, possible more efficient
		// private static var _satFilter:ColorMatrixFilter = new ColorMatrixFilter([0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		
		// New method, more flexible
		[Embed(source="../../data/Saturation.pbj", mimeType="application/octet-stream")] 
		private static var SaturationShader:Class;
		private static var _sat_filter:ShaderFilter = new ShaderFilter(new Shader(new SaturationShader()));
		_sat_filter.shader.data.saturation.value = [0.0];
		
		private var _alt_pixels:BitmapData;
		protected var _time_stopped:Boolean;
		
		private var _speech:Speech;
		private var _speech_time:Number;	
		
		public function PnuSprite(X:int=0,Y:int=0)
		{
			super(X,Y);
			timeStopped = false;
		}
		
		override public function loadGraphic(Graphic:Class,Animated:Boolean=false,Reverse:Boolean=false,Width:uint=0,Height:uint=0,Unique:Boolean=false):FlxSprite
		{
			var returnSprite:FlxSprite = super.loadGraphic(Graphic,Animated,Reverse,Width,Height,Unique);
			
			_alt_pixels = _pixels.clone();
			_alt_pixels.applyFilter(_alt_pixels, _alt_pixels.rect, new Point(), _sat_filter);
			
			return returnSprite;
		}
		
		override public function update():void
		{
			super.update()
			
			if(x < 0)
				x = 0;
			else if(x > PlayState.map.width)
				x = PlayState.map.width;
			if(y < 0)
				y = 0;
			else if(y > PlayState.map.height)
				y = PlayState.map.height;
			
			if(_speech_time > 0)
			{
				_speech_time -= FlxG.elapsed;
			}
			else
			{
				shutUp();
			}
		}
		
		public function get timeStopped():Boolean { return _time_stopped; }
		
		public function set timeStopped(TimeStopped:Boolean):void
		{
			// If nothing new
			if(_time_stopped == TimeStopped)
				return;
			
			_time_stopped = TimeStopped;
			
			// For not confusing collision detection
			if(_time_stopped)
			{
				last.x = x;
				last.y = y;
			}
			
			var tempPixels:BitmapData;
			
			// Swap pixels
			tempPixels = _pixels.clone();
			_pixels = _alt_pixels.clone();
			_alt_pixels = tempPixels.clone();
			
			calcFrame();
			
			fixed = !fixed;
			active = !active; 
			
			if(_speech)
			{
				_speech.fixed = !_speech.fixed;
				_speech.active = !_speech.active;
				_speech.calcFrame();
			}
			
		}
		
		public function toggleTime():void
		{
			timeStopped = !_time_stopped;
		}
		
		public function distanceTo(Core:FlxCore):Number
		{
			var dx:Number = x - Core.x;
			var dy:Number = y - Core.y;
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public function moveTo(Core:FlxCore):void
		{
			x = Core.x;
			y = Core.y;
			velocity.x = velocity.y = 0;
		}
		
		public function say(Str:String, Seconds:Number=0):void
		{
			shutUp();
			_speech = new Speech(Str, this);
			_speech_time = Seconds;
		}
		
		public function shutUp():void
		{
			if(_speech)
				_speech.kill();
		}
	}

}

