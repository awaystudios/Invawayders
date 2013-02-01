package com.awaystudios.invawayders.systems
{
	import com.awaystudios.invawayders.*;
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.nodes.*;
	import com.awaystudios.invawayders.utils.*;
	
	import ash.core.*;
	import ash.signals.*;
	
	import flash.geom.*;


	
	public class AnimationSystem extends System
	{
		[Inject]
		public var creator : EntityManager;
		
		[Inject]
		public var saveStateManager : SaveStateManager;
		
		[Inject]
		public var gameStateUpdated : Signal1;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.InvawayderNode")]
		public var invawayders : NodeList;
		[Inject(nodeType="com.awaystudios.invawayders.nodes.ProjectileNode")]
		public var projectiles : NodeList;
		[Inject(nodeType="com.awaystudios.invawayders.nodes.BlastNode")]
		public var blasts : NodeList;
		
		[PostConstruct]
		public function setUpListeners() : void
		{
			invawayders.nodeAdded.add( addToInvawayders );
			projectiles.nodeAdded.add( addToProjectiles );
			blasts.nodeAdded.add( addToBlasts );
		}
		
		private function addToInvawayders( node : InvawayderNode ) : void
		{
			var invawayder : Invawayder = node.invawayder;
			var subType : InvawayderArchetype = node.dataModel.subType as InvawayderArchetype;
			
			//randomise invawayder properties
			invawayder.panXFreq = 0.1 * Math.random();
			invawayder.panYFreq = 0.1 * Math.random();
			invawayder.spawnX = node.transform.x;
			invawayder.spawnY = node.transform.y;
			invawayder.targetSpeed = -subType.speed * MathUtils.rand( 0.75, 1.25 );
			invawayder.targetSpawnZ = MathUtils.rand( GameSettings.minSpawnZ, GameSettings.maxSpawnZ );
			invawayder.life = subType.life;
			invawayder.fireTimer = getFireTimer(subType);
			invawayder.animationTimer = getAnimationTimer();
			invawayder.movementCounter = 0;
			invawayder.currentFrame = 0;
			
			node.transform.scaleX = node.transform.scaleY = node.transform.scaleZ = subType.scale;
		}
		
		private function addToProjectiles( node : ProjectileNode ) : void
		{
			//offset projectiles from the mothership by a random amount
			if (node.dataModel.subType.id == ProjectileArchetype.MOTHERSHIP) {
				node.transform.x += MathUtils.rand( -700, 700 );
				node.transform.y += MathUtils.rand( -150, 150 );
			}
		}
		
		private function addToBlasts( node : BlastNode ) : void
		{
			//reset scale to zero
			node.transform.scaleX = node.transform.scaleY = node.transform.scaleZ = 0;
		}
		
		override public function update( time : Number ) : void
		{
			time *= 1000;
			
			var invawayderNode : InvawayderNode;
			var blastNode : BlastNode;
			var transform : Transform3D;
			
			//update invawayder animations
			for ( invawayderNode = invawayders.head; invawayderNode; invawayderNode = invawayderNode.next )
			{
				var dataModel : DataModel = invawayderNode.dataModel;
				var invawayder : Invawayder = invawayderNode.invawayder;
				transform = invawayderNode.transform;
				var archetype : InvawayderArchetype = dataModel.subType as InvawayderArchetype;
				
				//perform wobble movement in the x / y plane
				invawayder.movementCounter++;
				transform.x = invawayder.spawnX + archetype.panAmplitude * Math.sin( invawayder.panXFreq * invawayder.movementCounter );
				transform.y = invawayder.spawnY + archetype.panAmplitude * Math.sin( invawayder.panYFreq * invawayder.movementCounter );
				
				// Slow down warping in
				if( transform.z < invawayder.targetSpawnZ && invawayderNode.motion.velocity.z < invawayder.targetSpeed )
					invawayderNode.motion.velocity.z *= 0.75;
				
				invawayder.animationTimer -= time;
				
				//perform animation
				if (invawayder.animationTimer < 0) {
					invawayder.currentFrame = invawayder.currentFrame? 0 : 1;
					invawayder.meshFrame0.visible = invawayder.currentFrame? false : true;
					invawayder.meshFrame1.visible = invawayder.currentFrame? true : false;
					
					//reset time to animate
					invawayder.animationTimer = getAnimationTimer();
				}
				
				invawayder.fireTimer -= time;
				
				//fire projectile
				if (invawayder.fireTimer < 0) {
					creator.createEntity(transform.x, transform.y, transform.z, new Vector3D(0, 0, -100), ArchetypeLibrary.PROJECTILE, archetype.projectileArchetype);
					
					//reset time to fire
					invawayder.fireTimer = getFireTimer(archetype);
				}
			}
			
			//update blast animations
			for ( blastNode = blasts.head; blastNode; blastNode = blastNode.next )
			{
				transform = blastNode.transform;
				
				//scale up the blast
				var scale : Number = transform.scaleX = transform.scaleY = transform.scaleZ += 0.15;
				
				if (scale > 5)
					creator.destroyEntity(blastNode.entity);
			}
		}
		
		private function getFireTimer( archetype : InvawayderArchetype ) : Number
		{
			return Math.floor( archetype.fireRate * MathUtils.rand( 1, 1.5 ) );
		}
		
		private function getAnimationTimer() : Number
		{
			return MathUtils.rand( GameSettings.invawayderAnimationTimeMS, GameSettings.invawayderAnimationTimeMS * 1.5 );
		}
			
	}
}
