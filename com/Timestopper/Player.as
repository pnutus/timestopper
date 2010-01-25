package com.Timestopper
{

	import org.flixel.*;

	public class Player extends PnuSprite
	{
		[Embed(source="../../data/sounds/jump.mp3")] private var SndJump:Class;
		
		private var _move_speed:int = 500;
		private var _jump_power:int = 800;
		private var _jump_sound:FlxSound;
		
		public var leftButton:String = "LEFT";
		public var rightButton:String = "RIGHT";
		public var jumpButton:String = "UP";
		
		public function Player(X:Number,Y:Number, img:Class):void
		{
			super(X,Y);
			
			loadGraphic(img,true,true,16,16);
			_jump_sound = new FlxSound;
			_jump_sound.loadEmbedded(SndJump);
			_jump_sound.volume = 0.3;
			
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			health = 10;
			acceleration.y = 420; // Gravity
			drag.x = 400; // Friction
			width = 8;
			height = 14;
			offset.x = 4;
			offset.y = 2;
			
			addAnimation("normal", [0,1,2,3], 10);
			addAnimation("jump", [2]);
			addAnimation("stopped", [0]);
			
			facing = RIGHT;
		}
		
		override public function update():void
		{
			
			if(FlxG.keys.pressed(leftButton))
			{
				facing = LEFT;
				velocity.x -= _move_speed * FlxG.elapsed;
			} 
			else if(FlxG.keys.pressed(rightButton)) 
			{
				facing = RIGHT;
				velocity.x += _move_speed * FlxG.elapsed;
			}
			
			if(FlxG.keys.justPressed(jumpButton) && velocity.y == 0)
			{
				velocity.y = -_jump_power;
				_jump_sound.stop();
				_jump_sound.play();
			}
			
			
			if(velocity.y != 0)
			{
				play("jump");
			}
			else
			{
				if(velocity.x == 0)
				{
					play("stopped");
				}
				else
				{
				play("normal");
				}
			}
			
			super.update();
		}
}

}

