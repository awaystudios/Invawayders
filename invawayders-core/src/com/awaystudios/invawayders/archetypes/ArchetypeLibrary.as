package com.awaystudios.invawayders.archetypes
{
	import com.awaystudios.invawayders.archetypes.subtypes.*;
	
	/**
	 * @author robbateman
	 */
	public class ArchetypeLibrary
	{
		private static var _instance:ArchetypeLibrary;
		
		protected var _archetypes : Vector.<ArchetypeBase>;
		
		//available archetypes
		public static const PLAYER:uint = 0;
		public static const INVAWAYDER:uint = 1;
		public static const PROJECTILE:uint = 2;
		public static const BLAST:uint = 3;
		public static const FRAGMENTS:uint = 4;
		public static const EXPLOSION:uint = 5;
		
		public static function get archetypes():Vector.<ArchetypeBase>
		{
			if (!_instance)
				_instance = new ArchetypeLibrary();
			
			return _instance._archetypes;
		}
		
		public function ArchetypeLibrary()
		{
			_archetypes = new Vector.<ArchetypeBase>();
			_archetypes.push(new PlayerArchetype());
			_archetypes.push(new InvawayderArchetype(Vector.<ArchetypeBase>([new BugInvawayderArchetype(), new MothershipInvawayderArchetype(), new OctopusInvawayderArchetype(), new RoundedOctopusInvawayderArchetype()])));
			_archetypes.push(new ProjectileArchetype(Vector.<ArchetypeBase>([new InvawayderProjectileArchetype(), new PlayerProjectileArchetype()])));
			_archetypes.push(new BlastArchetype(Vector.<ArchetypeBase>([new PlayerBlastArchetype(), new InvawayderBlastArchetype()])));
			_archetypes.push(new FragmentsArchetype(Vector.<ArchetypeBase>([null, new MothershipFragmentsArchetype(), null, null])));
			_archetypes.push(new ExplosionArchetype());
		}
		
		public static function getArchetype(id:uint) : ArchetypeBase
		{
			if (!_instance)
				_instance = new ArchetypeLibrary();
			
			return _instance._archetypes[id];
		}
	}
}
