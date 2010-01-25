package com.Timestopper
{

	import org.flixel.*;
	import flash.external.ExternalInterface;

	public class Music
	{
		public static var timestopped:FlxSound = new FlxSound;
		public static var fez:FlxSound = new FlxSound;
		
		public static function initialize():void
		{
			// Stream music
			
			var localhost:Boolean;
			var streamURL:String;
			
			if(ExternalInterface.call('window.location.href.toString').indexOf("http") == -1)
				localhost = true;
			else
				localhost = false;

			if(localhost)
				streamURL = "file:///Users/pnutus/Dropbox/Public/Timestopper/Latest/data/sounds/";
			else
				streamURL = "http://dl.dropbox.com/u/15317/Timestopper/Latest/data/sounds/";
				
			timestopped.loadStream(streamURL + "Timestopped.mp3", true);
			fez.loadStream(streamURL + "FezMusicLoop.mp3", true);
			timestopped.volume = fez.volume = 0.5;
			timestopped.play();
		}

	}

}

