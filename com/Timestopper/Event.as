package com.Timestopper
{

	import org.flixel.*;

	public class Event
	{
		private var _subject:Object;
		private var _callback:Function;
		public var duration:Number;
		
		public function Event(Func:Function, Subject:Object, Seconds:Number)
		{
			super();
			_callback = Func;
			_subject = Subject;
			duration = Seconds;
		}
		
		public function execute():void
		{
			_callback.apply(_subject);
			_callback();
		}
	}

}

