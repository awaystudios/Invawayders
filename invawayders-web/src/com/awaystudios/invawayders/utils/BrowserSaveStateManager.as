package com.awaystudios.invawayders.utils
{
	import flash.net.*;
	
	/**
	 * Saves and loads the high score value of the game.
	 */
	public class BrowserSaveStateManager extends SaveStateManager
	{
		private const INVAWAYDERS_SO_NAME:String = "invawaydersUserData";
		
		/**
		 * @inheritDoc
		 */
		override public function saveHighScore( highScore:uint ):void
		{
			var sharedObject:SharedObject = SharedObject.getLocal( INVAWAYDERS_SO_NAME );
			sharedObject.data.highScore = highScore;
			sharedObject.flush();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function loadHighScore():uint
		{
			var sharedObject:SharedObject = SharedObject.getLocal( INVAWAYDERS_SO_NAME );
			return sharedObject.data.highScore;
		}
	}
}