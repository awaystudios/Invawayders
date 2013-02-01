package com.awaystudios.invawayders.components
{
	public class Transform3D
	{
		public var x : Number;
		public var y : Number;
		public var z : Number;
		public var rotationX : Number = 0;
		public var rotationY : Number = 0;
		public var rotationZ : Number = 0;
		public var scaleX : Number = 1;
		public var scaleY : Number = 1;
		public var scaleZ : Number = 1;
		
		public function Transform3D( x : Number = 0, y : Number = 0, z : Number = 0, rotationX : Number = 0, rotationY : Number = 0, rotationZ : Number = 0, scaleX : Number = 1, scaleY : Number = 1, scaleZ : Number = 1 )
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.rotationX = rotationX;
			this.rotationY = rotationY;
			this.rotationZ = rotationZ;
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			this.scaleZ = scaleZ;
		}
	}
}
