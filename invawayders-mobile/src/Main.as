package
{
	import com.awaystudios.invawayders.*;
	import com.awaystudios.invawayders.utils.*;
	
	import flash.display.*;
	
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class Main extends Sprite
	{
		public function Main()
		{
			addChild(new GameContainer(new MobileSaveStateManager()));
		}
	}
}