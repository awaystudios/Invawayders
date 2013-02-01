package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.components.*;
	
	import away3d.entities.*;
	import away3d.materials.*;
	
	import flash.geom.*;
	
	/**
	 * Base class for invawayder archetypes.
	 */
	public class InvawayderArchetype extends ArchetypeBase
	{
		public static const BUG:uint = 0;
		
		public static const MOTHERSHIP:uint = 1;
		
		public static const OCTOPUS:uint = 2;
		
		public static const ROUNDED_OCTOPUS:uint = 3;
		
		public static const invawayders:Vector.<uint> = Vector.<uint>([0,1,2,3]);
		
		public static const invawayderMaterial:ColorMaterial = new ColorMaterial( 0x777780, 1 );
		
		/**
		 * The vector data defining the shape of the invawayder data frames.
		 */
		public var cellDefinitions:Vector.<Vector.<uint>>;
		
		/**
		 * The vector data defining the positions in space of each building block 'cell', used for fragmentss.
		 */
		public var particlePositions:Vector.<Vector.<Vector3D>>;
		
		/**
		 * The dimensions of the cell data.
		 */
		public var dimensions:Point;
		
		/**
		 * The amount of life that the invawayder has when created, that the player has to deplete before it is destroyed.
		 */
		public var life:uint;
		
		/**
		 * The regularity with which the invawayder type spawns.
		 */
		public var spawnRate:uint;
		
		/**
		 * The regularity with which the invawayder fires projectiles.
		 */
		public var fireRate:uint;
		
		/**
		 * The amplitude of the invawayder's movement in the x direction.
		 */
		public var panAmplitude:uint;
		
		/**
		 * The speed of the invawayder's movment in the z direction.
		 */
		public var speed:uint;
		
		/**
		 * The overall scale of the invawayder in the scene.
		 */
		public var scale:Number;
		
		/**
		 * The score awarded to the player on destroying an invawayder.
		 */
		public var score:uint;
		
		/**
		 * The last spawn time in milliseconds of the invawayder type, updated after a new invawayder is spawned.
		 */
		public var spawnTimer:int;
		
		public var meshFrame0:Mesh;
		
		public var meshFrame1:Mesh;
		
		public var projectileArchetype : uint;
		
		public function InvawayderArchetype(subTypes:Vector.<ArchetypeBase> = null)
		{
			super(subTypes);
			
			id = ArchetypeLibrary.INVAWAYDER;
			
			material = invawayderMaterial;
			
			projectileArchetype = ProjectileArchetype.INVAWAYDER;
			
			Component = Invawayder;
		}
	}
}
