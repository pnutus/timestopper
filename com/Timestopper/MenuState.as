package com.Timestopper
{

	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private var newButton:FlxButton;
		private var loadButton:FlxButton;
		private var eraseButton:FlxButton;
		
		override public function MenuState()
		{
			
			// Title
			var txt:FlxText = new FlxText(0,(FlxG.width / 2) - 80, FlxG.width, "Timestopper alpha");
			txt.setFormat(null,16,0xffffffff,"center");
			add(txt);
			
			// "New Game" button
			newButton = new FlxButton((FlxG.width / 2) - 50, 140, newGame);
			txt = new FlxText(0,4,100,"New Game");
			var txtHL:FlxText = new FlxText(0,4,100,"New Game");
			txt.setFormat(null,8,0xffffffff,"center");
			txtHL.setFormat(null,8,0xff7f7f7f,"center");
			newButton.loadText(txt, txtHL);
			add(newButton);
			
			// Save stuff
			FlxG.saves = new Array;
			FlxG.saves[0] = new FlxSave;
			FlxG.saves[0].bind("save");
			
			if(FlxG.saves[0].data.exists == true)
			{
				// "Load Game" button
				loadButton = new FlxButton((FlxG.width / 2) - 50, 170, loadGame);
				txt = new FlxText(0,4,100,"Load Game");
				txtHL = new FlxText(0,4,100,"Load Game");
				txt.setFormat(null,8,0xffffffff,"center");
				txtHL.setFormat(null,8,0xff7f7f7f,"center");
				loadButton.loadText(txt, txtHL);
				add(loadButton);
				
				// "Erase Saved Game" button
				eraseButton = new FlxButton((FlxG.width / 2) - 50, 200, eraseSavedGame);
				txt = new FlxText(0,4,95,"Erase Saved Game");
				txtHL = new FlxText(0,4,95,"Erase Saved Game");
				txt.setFormat(null,8,0xffffffff,"center");
				txtHL.setFormat(null,8,0xff7f7f7f,"center");
				eraseButton.loadText(txt, txtHL);
				add(eraseButton);
			}
			
			FlxG.showCursor();
			
			Music.initialize();
		}
		
		private function newGame():void
		{
			FlxG.saves[0].erase();
			FlxG.saves[0].bind("save");
			FlxG.flash(0xffffffff,0.75);
			FlxG.fade(0xff000000,1,onFade);
		}
		
		private function loadGame():void
		{
			FlxG.flash(0xffffffff,0.75);
			FlxG.fade(0xff000000,1,onFade);
		}
		
		private function eraseSavedGame():void
		{
			FlxG.saves[0].erase();
			loadButton.kill();
			eraseButton.kill();
		}
		
		private function onFade():void
		{
			FlxG.switchState(PlayState);
		}
	}

}

