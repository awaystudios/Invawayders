package com.awaystudios.invawayders.components
{
	import away3d.entities.*;
	
	public class Invawayder
	{
		public var life : Number = 0;
		
		public var fireTimer : Number = 0;
		
		public var animationTimer : Number = 0;
		
		public var movementCounter : uint = 0;
		
		public var meshFrame0 : Mesh;
		
		public var meshFrame1:Mesh;
		
		public var panXFreq:Number;
		
		public var panYFreq:Number;
		
		public var spawnX:Number;
		
		public var spawnY:Number;
		
		public var targetSpeed:Number;
		
		public var targetSpawnZ:Number;
		
		public var currentFrame : uint;
		
		public function Invawayder( meshFrame0 : Mesh, meshFrame1 : Mesh )
		{
			this.meshFrame0 = meshFrame0;
			this.meshFrame1 = meshFrame1;
		}
	}
}
