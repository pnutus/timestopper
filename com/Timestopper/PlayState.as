package com.Timestopper
{

	import org.flixel.*;

	public class PlayState extends FlxState
	{	
		[Embed(source = '../../data/sounds/stop.mp3')] private var SndStopTime:Class;
		
	    [Embed(source = '../../data/images/tiles.png')] private var ImgTiles:Class;
		[Embed(source="../../data/images/Player.png")] private var ImgPlayer:Class;
		[Embed(source='../../data/images/Enemy.png')] private var ImgPlayer2:Class;
		
	    [Embed(source = '../../data/maps/level1.txt', mimeType = "application/octet-stream")] private var Map1:Class;
		[Embed(source = '../../data/maps/level2.txt', mimeType = "application/octet-stream")] private var Map2:Class;
		[Embed(source = '../../data/maps/level3.txt', mimeType = "application/octet-stream")] private var Map3:Class;
		[Embed(source = '../../data/maps/level4.txt', mimeType = "application/octet-stream")] private var Map4:Class;
		
		private var _levels:Array;
		private var _cur_level:uint;
		private var _level_stuff:Array;
	    public static var map:PnuTilemap;

		private var _player:Player;
		private var _player2:Player;
	    private var _players:Array;
		private var _sprites:Array;
		
		private var _save_timer:Number;
	
        public static var _time_stopped:Boolean;

		private var _stop_sound:FlxSound;
		
		private var _event_queue:EventQueue;

	    public static var lyrStage:FlxLayer;
	    public static var lyrSprites:FlxLayer;
		public static var lyrBubbles:FlxLayer;
		
		public function PlayState()
		{
			super();
			
			_time_stopped = false;
			
			// Layer Stuff
			lyrStage = new FlxLayer;
			lyrSprites = new FlxLayer;
			lyrBubbles = new FlxLayer;
			add(lyrStage);
			add(lyrSprites);
			add(lyrBubbles);
			_sprites = lyrSprites.children();
			_level_stuff = new Array;
			
			// Event stuff
			_event_queue = new EventQueue;
			lyrBubbles.add(_event_queue);
		
			// Sound stuff
			Music.timestopped.pause();
			Music.fez.play();
			_stop_sound = FlxG.play(SndStopTime, 0.3);
			_stop_sound.stop();
			
			// Level stuff
			_cur_level = 1;
			_levels = new Array;
			_levels.push(new Level(1, new Map1, ImgTiles));
			_levels.push(new Level(2, new Map2, ImgTiles));
			_levels.push(new Level(3, new Map3, ImgTiles));
			_levels.push(new Level(4, new Map4, ImgTiles));
			
			// Player stuff
			_player = new Player(130, 432, ImgPlayer);
			_player.facing = 0;
			_player2 = new Player(52, 448, ImgPlayer2);
			_player2.leftButton = "A";
			_player2.rightButton = "D";
			_player2.jumpButton = "W";
			_player2.acceleration.y = 300;
			lyrSprites.add(_player2);
			lyrSprites.add(_player);
			_players = new Array;
			_players.push(_player);
			_players.push(_player2);
			FlxG.follow(_player, 2.5);
			_event_queue.add(function():void { _player.say("Jag är en fisk och jag har kommit för att äta upp dig!", 3) }, this, 3);
			_event_queue.add(function():void { _player2.say("OH NOES!", 2) }, this, 2)
			_event_queue.add(function():void { _player.say("Mohaha!", 2) }, this, 2);
			_event_queue.add(function():void { _player2.say("Nej, snälla, du... d-du får alla mina pengar! Och alla min pokémon-kort! o-och mina vita ridstövlar... o-o-och—", 4) }, this, 4);
			_event_queue.add(function():void { _player.say("Vad pratar du om?", 2) }, this, 2);
			_event_queue.add(function():void { _player2.say("En fisk...", 2) }, this, 2);
			_event_queue.add(function():void { _player.say("Mohah! Du kan inte motstå min förlamande charm, precis som resten av universum.", 3) }, this, 3);
			_event_queue.add(function():void { _player2.say("N-nej... Du är så-å va-acker!", 2) }, this, 2);
			_event_queue.add(function():void { _player.say("Men vet du vilken del av mig som är vackrast?", 3) }, this, 3);
			_event_queue.add(function():void { _player2.say("N-n-nej...", 2) }, this, 2);
			_event_queue.add(function():void { _player.say("INSIDAN AV MIN MUN!", 2) }, this, 2);
			_event_queue.add(function():void {
				 	FlxG.flash(0xffffffff,0.3);
					_player.moveTo(_player2);
					_player.say("OM NOM NOM NOM", 3);
					_player2.visible = false;
				}, this, 10);
			_event_queue.add(function():void{
				_player2.moveTo(_player);
				_player.say("BLEEURRRK!!!", 2);
				_player2.visible = true;
				_player2.velocity.y = -400;
				if(_player.facing == 0)
					_player2.velocity.x = -200;
				else
					_player2.velocity.x = 200;
			}, this);
			
			// Load stuff
			if(FlxG.saves[0].data.exists == true)
			{
				_cur_level = FlxG.saves[0].data.level;
				_player.x = FlxG.saves[0].data.playerX;
				_player.y = FlxG.saves[0].data.playerY;
				_player2.x = FlxG.saves[0].data.player2X;
				_player2.y = FlxG.saves[0].data.player2Y;
			}
			
			_save_timer = 5;
			
			loadLevel(_cur_level, false);
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed("R"))
				FlxG.switchState(PlayState);
			if(FlxG.keys.justPressed("M"))
				FlxG.switchState(MenuState);
			
			if(FlxG.keys.justPressed("SPACE"))
			{
				toggleTime();
			}
			
			// Save
			if(_save_timer > 0)
				_save_timer -= FlxG.elapsed;
			else
			{
				_save_timer = 5;
				saveGame();
			}
			
			super.update();
			
			// Change levels
			if(_player.x > map.width - _player.width)
			{
				loadLevel(_cur_level + 1);
			}
			else if(_player.x < 1)
			{
				loadLevel(_cur_level - 1);
			}
			
			// Collisions
			
			map.collideArray(_sprites);
			
			// Only when frozen
			if(_time_stopped)
			{
				var sprite:PnuSprite;
				
				for each(sprite in _sprites)
				{
					if(sprite.timeStopped)
						_player.collide(sprite);
				}
				return;
			}
		}
		
		private function toggleTime():void
		{
			_time_stopped = !_time_stopped;
			
			FlxG.flash(0xffffffff,0.2);
			_stop_sound.stop();
			_stop_sound.play();
			
			_event_queue.active = !_event_queue.active;
			
			map.toggleTime();
			
			var thing:PnuSprite;
			
			if(_time_stopped)
			{
				// Change music
				Music.timestopped.fadeIn(0.05);
				Music.fez.pause();
				
				for each(thing in _sprites)
				{
					thing.timeStopped = true;
					
					// Don't freeze sprite if it touches player
					if(thing.overlaps(_player))
					{
						thing.timeStopped = false;
					}
				}
			}
			else
			{
				// Change music
				Music.fez.fadeIn(0.05);
				Music.timestopped.pause();
				
				for each(thing in _sprites)
				{
					thing.timeStopped = false;
				}
			}
		}
		
		private function saveGame():void
		{
			FlxG.saves[0].data.exists = true;
			FlxG.saves[0].data.level = _cur_level;
			FlxG.saves[0].data.playerX = _player.x;
			FlxG.saves[0].data.playerY = _player.y;
			FlxG.saves[0].data.player2X = _player2.x;
			FlxG.saves[0].data.player2Y = _player2.y;
			FlxG.saves[0].forceSave();
		}
		
		private function loadLevel(lvlNumber:uint, movePlayer:Boolean = true):void
		{
			if(!_levels[lvlNumber])
				return;
			
			// Kill old stuff
			if (_level_stuff.length > 0)
				for each(var obj:FlxCore in _level_stuff)
					obj.kill();
			
			_level_stuff = new Array;
			
			// Load new map
			map = new PnuTilemap;
			map.loadMap(_levels[lvlNumber].map,_levels[lvlNumber].tilemap,16);
			_level_stuff.push(lyrStage.add(map) as PnuTilemap);
			
			// Move player
			if(movePlayer)
			{
				if (_cur_level < lvlNumber)
				{
					_player.x = 1;
				}
				else
				{
					_player.x = map.width - _player.width - 1;
				}
				_player2.timeStopped = false;
				_player2.moveTo(_player);
			}
			
			if(_time_stopped)
				for each(var thing:* in _level_stuff)
					thing.timeStopped = true;
			
			// Camera stuff
			map.follow();
			FlxG.instaFollow();
			
			_cur_level = lvlNumber;
		}
	}
}