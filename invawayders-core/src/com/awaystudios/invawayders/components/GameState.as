package com.awaystudios.invawayders.components
{
	import com.awaystudios.invawayders.GameSettings;

	public class GameState
	{
		public var lives : int = 3;
		public var level : int = 0;
		public var score : int = 0;
		public var highScore : int = 0;
		public var spawnTimeFactor : Number = GameSettings.startingSpawnTimeFactor;
		public var levelKills : uint = 0;
		public var totalKills : uint = 0;
		
	}
}
