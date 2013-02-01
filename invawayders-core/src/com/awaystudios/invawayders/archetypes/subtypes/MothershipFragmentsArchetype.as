package com.awaystudios.invawayders.archetypes.subtypes
{
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.sounds.*;
	
	
	/**
	 * Data class for fragments data
	 */
	public class MothershipFragmentsArchetype extends FragmentsArchetype
	{
		public function MothershipFragmentsArchetype()
		{
			id = FragmentsArchetype.MOTHERSHIP;
			
			soundOnAdd = SoundLibrary.EXPLOSION_STRONG;
		}
	}
}
