package com.Timestopper
{

	import org.flixel.*;

	public class Speech extends PnuSprite
	{	
		[Embed(source = '../../data/images/hearts.png')] private var ImgHeart:Class;
		
		private var _content:FlxSprite;
		private var _symbols:Object;
		private var _owner:PnuSprite;
		
		public function Speech(Str:String, Owner:PnuSprite)
		{
			super(0,0);
			
			_symbols = {heart:ImgHeart};
			
			_owner = Owner;
			
			if(_symbols[Str])
			{
				_content = new FlxSprite;
				_content.loadGraphic(_symbols[Str]);
			}
			else
			{
				_content = new PnuText(x+3,y+3,100,Str);
				_content.color = 0x00000000;
			}
			
			createGraphic(_content.width + 6, _content.height + 6);
			
			PlayState.lyrBubbles.add(this);
			PlayState.lyrBubbles.add(_content);
		}
		
		override public function update():void
		{
			super.update();
			
			x = _owner.x - (width - _owner.width)/2;
			y = _owner.y - height - 5;
			
			var mapWidth:Number = PlayState.map.width;
			
			if(x < 0)
				x = 0;
			if((x + width) > mapWidth)
				x = mapWidth - width;
			if(y < 0)
				y = _owner.y + _owner.height + 5;
			
			_content.x = x + 3;
			_content.y = y + 3;
		}
		
		override public function set timeStopped(TimeStopped:Boolean):void
		{
			// If nothing new
			if(_time_stopped == TimeStopped)
				return;
			
			_time_stopped = TimeStopped;
			
			visible = !visible;
			active = !active;
			_content.visible = !_content.visible;
			_content.active = !_content.active;
		}
		
		override public function kill():void
		{
			_content.kill();
			super.kill();
		}

	}

}

