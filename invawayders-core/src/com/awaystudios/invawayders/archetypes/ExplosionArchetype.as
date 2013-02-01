package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.components.*;
	
	import away3d.animators.*;
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import com.awaystudios.invawayders.GameSettings;
	
	/**
	 * Data class for explosion data
	 */
	public class ExplosionArchetype extends ArchetypeBase
	{
		public static const INVAWAYDER:uint = 0;
		
		public var particleAnimationSet : ParticleAnimationSet;
		
		public var particleMeshes:Vector.<Mesh>;
		
		public static const explosionGeometry:Geometry = new PlaneGeometry( GameSettings.explosionSizeXY, GameSettings.explosionSizeXY, 1, 1, false );
		
		public static const explosionMaterial:ColorMaterial = new ColorMaterial( 0xFFFF00 );
		
		public function ExplosionArchetype(subTypes:Vector.<ArchetypeBase> = null)
		{
			super(subTypes);
			
			id = ArchetypeLibrary.EXPLOSION;
			
			geometry = explosionGeometry;
			
			material = explosionMaterial;
			
			Component = Explosion;
		}
		
		override protected function clone(archetype:ArchetypeBase, subId:uint):ArchetypeBase
		{
			return super.clone(archetype ||= new ExplosionArchetype(), subId);
		}
	}
}
