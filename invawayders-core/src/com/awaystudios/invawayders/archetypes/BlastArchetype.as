package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.components.*;
	
	import away3d.primitives.*;
	
	/**
	 * Data class for Player projectile data
	 */
	public class BlastArchetype extends ArchetypeBase
	{
		public static const PLAYER:uint = 0;
		
		public static const INVAWAYDER:uint = 1;
		
		public function BlastArchetype(subTypes:Vector.<ArchetypeBase> = null)
		{
			super(subTypes);
			
			id = ArchetypeLibrary.BLAST;
			
			geometry = new SphereGeometry();
			
			Component = Blast;
		}
	}
}
