package com.Timestopper
{

	import org.flixel.*;

	public class PnuText extends FlxText
	{

		public function PnuText(X:Number, Y:Number, Width:Number, Text:String=null)
		{
			super(X,Y,Width,Text);
			_tf.autoSize = "left";
			if(_tf.width > Width)
			{
				_tf.width = Width;
				_tf.wordWrap = true;
			}
			_regen = true;
			calcFrame();
			createGraphic(_tf.width,_tf.height);
			text = Text;
		}

	}

}

