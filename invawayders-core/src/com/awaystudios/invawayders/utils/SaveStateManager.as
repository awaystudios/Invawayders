package com.awaystudios.invawayders.utils
{
	import away3d.errors.*;
	
	/**
	 * Saves and loads the high score value of the game.
	 */
	public class SaveStateManager
	{
		/**
		 * Saves the highscore value to a local shared object.
		 * 
		 * @param highScore The highscore value to be saved.
		 */
		public function saveHighScore( highScore:uint ):void
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * Loads the highscore value from an existing shared object.
		 * 
		 * @return The last known highscore saved.
		 */
		public function loadHighScore():uint
		{
			throw new AbstractMethodError();
		}
	}
}
