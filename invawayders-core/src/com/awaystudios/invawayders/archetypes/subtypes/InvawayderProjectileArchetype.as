package com.awaystudios.invawayders.archetypes.subtypes
{
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.sounds.*;
	
	/**
	 * Data class for Invawayder projectile data
	 */
	public class InvawayderProjectileArchetype extends ProjectileArchetype
	{
		public function InvawayderProjectileArchetype()
		{
			id = ProjectileArchetype.INVAWAYDER;
			
			soundOnAdd = SoundLibrary.INVAWAYDER_FIRE;
		}
	}
}
