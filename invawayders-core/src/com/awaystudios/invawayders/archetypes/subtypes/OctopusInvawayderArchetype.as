package com.awaystudios.invawayders.archetypes.subtypes
{
	import com.awaystudios.invawayders.archetypes.*;
	
	import flash.geom.*;
	
	/**
	 * Data class for Octopus Invawayder
	 */
	public class OctopusInvawayderArchetype extends InvawayderArchetype
	{
		public function OctopusInvawayderArchetype()
		{
			id = InvawayderArchetype.OCTOPUS;
			
			cellDefinitions = Vector.<Vector.<uint>>([
				Vector.<uint>([
					0, 0, 0, 1, 1, 0, 0, 0,
					0, 0, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 1, 1, 1, 1, 0,
					1, 1, 0, 1, 1, 0, 1, 1,
					1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 1, 0, 0, 1, 0, 0,
					0, 1, 0, 1, 1, 0, 1, 0,
					1, 0, 1, 0, 0, 1, 0, 1
				]),
				Vector.<uint>([
					0, 0, 0, 1, 1, 0, 0, 0,
					0, 0, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 1, 1, 1, 1, 0,
					1, 1, 0, 1, 1, 0, 1, 1,
					1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 1, 0, 0, 1, 0, 0,
					0, 1, 0, 0, 0, 0, 1, 0,
					0, 0, 1, 0, 0, 1, 0, 0
				])
			]);
			
			dimensions = new Point( 8, 8 );
			
			life = 1;
			
			spawnRate = 20000;
			
			fireRate = 1000;
			
			panAmplitude = 500;
			
			speed = 25;
			
			scale = 1;
			
			score = 100;
		}
	}
}
