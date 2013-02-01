package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.components.*;
	
	import away3d.core.base.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	/**
	 * Data class for Invawayder projectile data
	 */
	public class ProjectileArchetype extends ArchetypeBase
	{
		public static const INVAWAYDER:uint = 0;
		
		public static const PLAYER:uint = 1;
		
		public static const MOTHERSHIP:uint = 2;
		
		public static const projectileGeometry:Geometry = new CubeGeometry( 25, 25, 200, 1, 1, 4 );
		
		public static const projectileMaterial:ColorMaterial = new ColorMaterial( 0xFF0000 );
		
		public function ProjectileArchetype(subType:Vector.<ArchetypeBase> = null)
		{
			super(subType);
			
			id = ArchetypeLibrary.PROJECTILE;
			
			geometry = projectileGeometry;
			
			material = projectileMaterial;
			
			Component = Projectile;
		}
		
		override protected function clone(archetype:ArchetypeBase, subId:uint):ArchetypeBase
		{
			return super.clone(archetype ||= new ProjectileArchetype(), subId);
		}
	}
}
