package com.awaystudios.invawayders.utils
{
	import flash.filesystem.*;

	public class MobileSaveStateManager extends SaveStateManager
	{
		private const FILE_PATH:String = "invawaydersUserData.txt";

		public function MobileSaveStateManager()
		{
			super();
		}
		
		override public function saveHighScore( score:uint ):void {
			var file:File = File.applicationStorageDirectory.resolvePath( FILE_PATH );
			var str:FileStream = new FileStream();
			str.open( file, FileMode.WRITE );
			str.position = 0;
			str.writeUnsignedInt( score );
		}
		
		override public function loadHighScore():uint
		{
			var file:File = File.applicationStorageDirectory.resolvePath( FILE_PATH );
			if( file.exists ) {
				var str:FileStream = new FileStream();
				str.open( file, FileMode.READ );
				str.position = 0;
				return str.readUnsignedInt();
			}
			return 0;
		}
	}
}
