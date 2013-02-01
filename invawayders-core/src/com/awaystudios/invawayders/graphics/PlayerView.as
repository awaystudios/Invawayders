package com.awaystudios.invawayders.graphics
{
	import away3d.containers.*;
	import away3d.entities.*;
	
	public class PlayerView extends ObjectContainer3D
	{
		public function PlayerView( leftBlaster : Mesh, rightBlaster : Mesh )
		{
			addChild( leftBlaster );
			addChild( rightBlaster );
		}
		
	}
}
