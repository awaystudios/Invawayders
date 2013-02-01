package com.awaystudios.invawayders.graphics
{
	import away3d.containers.*;
	import away3d.entities.*;

	public class InvawayderView extends ObjectContainer3D
	{
		public function InvawayderView( meshFrame0 : Mesh, meshFrame1 : Mesh )
		{
			addChild( meshFrame0 );
			addChild( meshFrame1 );
		}
	}
}