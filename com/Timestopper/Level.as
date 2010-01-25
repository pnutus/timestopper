package com.Timestopper
{

	import org.flixel.*;
	import flash.geom.Point;
	
	public class Level
	{
		public var levelNumber:uint;
		public var map:String;
		public var tilemap:Class;
		
		public function Level(lNo:uint, lMap:String, tMap:Class)
		{
			levelNumber = lNo;
			map = lMap;
			tilemap = tMap
		}

	}

}

