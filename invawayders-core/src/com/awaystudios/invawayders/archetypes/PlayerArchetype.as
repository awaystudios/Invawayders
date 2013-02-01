package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.components.*;
	
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	/**
	 * Data class for Player projectile data
	 */
	public class PlayerArchetype extends ArchetypeBase
	{
		public var leftBlaster:Mesh;
		
		public var rightBlaster:Mesh;
		
		public function PlayerArchetype()
		{
			id = ArchetypeLibrary.PLAYER;
			
			geometry = new CubeGeometry( 25, 25, 500 );
			
			material = new ColorMaterial( 0xFFFFFF );
			
			Component = Player;
		}
	}
}
