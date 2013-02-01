package com.awaystudios.invawayders.archetypes.subtypes
{
	import com.awaystudios.invawayders.archetypes.*;
	
	import flash.geom.*;
	
	/**
	 * Data class for Rounded Octopus Invawayder
	 */
	public class RoundedOctopusInvawayderArchetype extends InvawayderArchetype
	{
		public function RoundedOctopusInvawayderArchetype()
		{
			id = InvawayderArchetype.ROUNDED_OCTOPUS;
			
			cellDefinitions = Vector.<Vector.<uint>>([
				Vector.<uint>([
					0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
					0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0,
					0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0,
					1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1
				]),
				Vector.<uint>([
					0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
					0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1,
					1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0,
					0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0,
					0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0
				])
			]);
			
			dimensions = new Point( 12, 8 );
			
			life = 4;
			
			spawnRate = 6000;
			
			fireRate = 2000;
			
			panAmplitude = 0;
			
			speed = 100;
			
			scale = 1;
			
			score = 10;
		}
	}
}
