package com.Timestopper
{
	import org.flixel.*;
	
	public class EventQueue extends FlxCore
	{
		private var _queue:Array;
		private var _delay:Number;
		
		public function EventQueue()
		{
			super();
			_queue = new Array;
			_delay = 0;
		}
		
		public function add(Func:Function, Subject:Object, Seconds:Number = -10):EventQueue
		{
			var event:Event = new Event(Func, Subject, Seconds);
			
			_queue.push(event);
			
			return this;
		}
		
		public function empty():void
		{
			_queue = new Array;
		}
		
		override public function update():void
		{
			super.update();
			
			if(_queue.length == 0 || _delay == -10)
				return;
			
			if(_delay > 0)
				_delay -= FlxG.elapsed;
			else
			{
				next();
			}
		}
		
		public function next():void
		{
			var tmpEvent:Event = _queue.shift();
			_delay = tmpEvent.duration;
			tmpEvent.execute();
		}

	}

}

