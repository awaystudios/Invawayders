package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.sounds.*;
	
	import away3d.animators.*;
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import com.awaystudios.invawayders.GameSettings;
	
	/**
	 * Data class for fragments data
	 */
	public class FragmentsArchetype extends ArchetypeBase
	{
		public static const MOTHERSHIP:uint = 1;
		
		public var particleAnimationSet : ParticleAnimationSet;
		
		public var particleMeshes:Vector.<Mesh>;
		
		public static const fragmentsGeometry:Geometry = new CubeGeometry( GameSettings.invawayderSizeXY, GameSettings.invawayderSizeXY, GameSettings.invawayderSizeZ );
		
		public static const fragmentsMaterial:ColorMaterial = new ColorMaterial( 0x777780);
		
		public function FragmentsArchetype(subTypes:Vector.<ArchetypeBase> = null)
		{
			super(subTypes);
			
			id = ArchetypeLibrary.FRAGMENTS;
			
			geometry = fragmentsGeometry;
			
			material = fragmentsMaterial;
			
			soundOnAdd = SoundLibrary.INVAWAYDER_DEATH;
			
			Component = Fragments;
		}
		
		override protected function clone(archetype:ArchetypeBase, subId:uint):ArchetypeBase
		{
			return super.clone(archetype ||= new FragmentsArchetype(), subId);
		}
	}
}
