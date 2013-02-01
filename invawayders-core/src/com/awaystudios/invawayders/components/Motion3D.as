package com.awaystudios.invawayders.components
{
	import flash.geom.*;
	
	public class Motion3D
	{
		public var velocity : Vector3D;
		public var angularVelocity : Number = 0;
		public var damping : Number = 0;
		
		public function Motion3D( velocity : Vector3D = null, angularVelocity : Number = 0, damping : Number = 0 )
		{
			this.velocity = velocity || new Vector3D();
			this.angularVelocity = angularVelocity;
			this.damping = damping;
		}
	}
}
