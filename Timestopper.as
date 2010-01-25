package {
	import org.flixel.*;
	import com.Timestopper.MenuState;
	
	[SWF(width="640", height="480", backgroundColor="#000")]
	[Frame(factoryClass="Preloader")]
	
	public class Timestopper extends FlxGame
	{
		public function Timestopper()
		{
			super(320,240,MenuState,2);
			showLogo = false;
		}
	}
}