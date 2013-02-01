package com.awaystudios.invawayders
{
	
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.graphics.*;
	import com.awaystudios.invawayders.primitives.*;
	import com.awaystudios.invawayders.utils.*;
	
	import flash.geom.*;
	
	import ash.core.*;
	
	import away3d.animators.*;
	import away3d.animators.data.*;
	import away3d.animators.nodes.*;
	import away3d.animators.states.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.entities.Mesh;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.tools.helpers.*;
	
	
	public class EntityManager
	{
		[Inject]
		public var game : Engine;
		
		[Inject]
		public var view : View3D;
		
		[Inject(name="lightPicker")]
		public var lightPicker : StaticLightPicker;
		
		[Inject(name="cameraLightPicker")]
		public var cameraLightPicker : StaticLightPicker;
		
		public function EntityManager()
		{
		}
		
		public function createGame() : Entity
		{
			var gameEntity : Entity = new Entity()
				.add( new GameState() );
			game.addEntity( gameEntity );
			return gameEntity;
		}
		
		public function createEntity( x : Number, y : Number, z : Number, velocity : Vector3D, archetypeId:uint, subTypeId:uint = 0 ) : Entity
		{
			var archetype : ArchetypeBase = ArchetypeLibrary.getArchetype(archetypeId);
			var subType : ArchetypeBase = archetype.getSubType(subTypeId);
			var entity : Entity;
			var transform : Transform3D;
			var motion : Motion3D;
			
			//return if entity exists in pool.
			if (subType.entityPool.length) {
				entity = subType.entityPool.pop();
				transform = entity.get(Transform3D) as Transform3D;
				transform.x = x;
				transform.y = y;
				transform.z = z;
				motion = entity.get(Motion3D) as Motion3D;
				motion.velocity = velocity;
				game.addEntity( entity );
				return entity;
			}
			
			//create new entity
			entity = new Entity()
				.add( new Transform3D(x, y, z) )
				.add( new Motion3D(velocity) )
				.add( new DataModel(archetype, subType) );
			
			game.addEntity( entity );
			
			var material : MaterialBase = subType.material;
			var entityView:ObjectContainer3D;
			
			switch(subType.Component)
			{
				case Invawayder:
				
					var meshFrame0:Mesh;
					var meshFrame1:Mesh;
					var invawayderArchetype:InvawayderArchetype = subType as InvawayderArchetype;
					
					//if invawayder view exists, create a clone from the mesh frames
					if (invawayderArchetype.entityView) {
						meshFrame0 = invawayderArchetype.meshFrame0.clone() as Mesh;
						meshFrame1 = invawayderArchetype.meshFrame1.clone() as Mesh;
						entityView = new InvawayderView(meshFrame0, meshFrame1);
					} else {
						//grab invawayder dimensions data
						var dimensions:Point = invawayderArchetype.dimensions;
						
						//grab invawayder cell definition data
						var definitionFrame0:Vector.<uint> = invawayderArchetype.cellDefinitions[ 0 ];
						var definitionFrame1:Vector.<uint> = invawayderArchetype.cellDefinitions[ 1 ];
						
						//define cell positions for invawayder data
						invawayderArchetype.particlePositions = Vector.<Vector.<Vector3D>>([createInvawayderparticlePositions( definitionFrame0, dimensions ), createInvawayderparticlePositions( definitionFrame1, dimensions )]);
						
						material.lightPicker = lightPicker;
						
						//define mesh objects frames for invawayder entity
						meshFrame0 = invawayderArchetype.meshFrame0 = new Mesh( new InvawayderGeometry( GameSettings.invawayderSizeXY, GameSettings.invawayderSizeZ, definitionFrame0, dimensions ), material );
						meshFrame1 = invawayderArchetype.meshFrame1 = new Mesh( new InvawayderGeometry( GameSettings.invawayderSizeXY, GameSettings.invawayderSizeZ, definitionFrame1, dimensions ), material );
						entityView = invawayderArchetype.entityView = new InvawayderView(meshFrame0, meshFrame1);
					}
					
					entity.add( new Invawayder( meshFrame0, meshFrame1 ) );
					break;
					
				case Player:
					
					var leftBlaster : Mesh;
					var rightBlaster : Mesh;
					var playerArchetype:PlayerArchetype = subType as PlayerArchetype;
					
					material.lightPicker = cameraLightPicker;
					
					if (subType.entityView) {
						leftBlaster = playerArchetype.leftBlaster.clone() as Mesh;
						rightBlaster  = playerArchetype.rightBlaster.clone() as Mesh;
						entityView = new PlayerView(leftBlaster, rightBlaster);
					} else {
						leftBlaster = new Mesh( subType.geometry, material );
						rightBlaster  = leftBlaster.clone() as Mesh;
						leftBlaster.position = new Vector3D( -GameSettings.blasterOffsetH, GameSettings.blasterOffsetV, GameSettings.blasterOffsetD );
						rightBlaster.position = new Vector3D( GameSettings.blasterOffsetH, GameSettings.blasterOffsetV, GameSettings.blasterOffsetD );
						entityView = subType.entityView = new PlayerView(leftBlaster, rightBlaster);
					}
					
					entity.add( new Player( view.camera, leftBlaster, rightBlaster ) );
					break;
				
				case Explosion:
					
					var explosionArchetype:ExplosionArchetype = subType as ExplosionArchetype;
					var animator:ParticleAnimator;
					
					if (explosionArchetype.entityView) {
						entityView = explosionArchetype.entityView.clone() as ObjectContainer3D;
						
						(entityView as Mesh).animator = animator = new ParticleAnimator(explosionArchetype.particleAnimationSet);
					} else {
						
						var explosionAnimationSet:ParticleAnimationSet = (archetype as ExplosionArchetype).particleAnimationSet;
						
						if (!explosionAnimationSet) {
							explosionAnimationSet = explosionArchetype.particleAnimationSet = new ParticleAnimationSet(true);
							explosionAnimationSet.addAnimation(new ParticleBillboardNode());
							explosionAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
							explosionAnimationSet.initParticleFunc = initParticleFuncExplosion;
						}
						
						//generate the particle geometry vector
						var explosionGeometrySet:Vector.<Geometry> = new Vector.<Geometry>();
						for (i=0; i < 50; i++) 
							explosionGeometrySet.push(explosionArchetype.geometry);
						
						entityView = explosionArchetype.entityView = new Mesh(ParticleGeometryHelper.generateGeometry(explosionGeometrySet), material);
						
						//generate the particle animator
						(entityView as Mesh).animator = animator = new ParticleAnimator(explosionAnimationSet);
					}
					
					entity.add( new Explosion(animator) );
					break;
					
				case Fragments:
					
					var fragmentsArchetype:FragmentsArchetype = subType as FragmentsArchetype;
					var particlePositions:Vector.<Vector.<Vector3D>> = (ArchetypeLibrary.getArchetype(ArchetypeLibrary.INVAWAYDER).getSubType(subType.id) as InvawayderArchetype).particlePositions;
					var particleVelocities:Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>();
					var particleRotationalVelocities:Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>();
					var particleMeshes:Vector.<Mesh>;
					var particleMesh:Mesh;
					var particleAnimator:ParticleAnimator;
					
					if (fragmentsArchetype.entityView) {
						entityView = new ObjectContainer3D();
						particleMeshes =  new Vector.<Mesh>();
						
						var i:uint = 0;
						for (i=0; i < fragmentsArchetype.particleMeshes.length; i++) {
							//generate vectors for velocities and rotationalvelocities
							particleVelocities.push(new Vector.<Vector3D>(particlePositions[i].length));
							particleRotationalVelocities.push(new Vector.<Vector3D>(particlePositions[i].length));
							
							//duplicate particle mesh
							particleMesh = fragmentsArchetype.particleMeshes[i].clone() as Mesh;
							particleMeshes.push(particleMesh);
							entityView.addChild(particleMesh);
							
							//duplicate particle animator
							particleAnimator = new ParticleAnimator((archetype as FragmentsArchetype).particleAnimationSet);
							(particleAnimator.getAnimationStateByName("ParticlePositionLocalDynamic") as ParticlePositionState).setPositions(particlePositions[i]);
							particleMesh.animator = particleAnimator;
						}
					} else {
						material.lightPicker = cameraLightPicker;
						
						entityView = fragmentsArchetype.entityView = new ObjectContainer3D();
						
						//create the particle animation set !ONLY CREATE ONE!
						var fragmentsAnimationSet:ParticleAnimationSet = (archetype as FragmentsArchetype).particleAnimationSet;
						
						if (!fragmentsAnimationSet) {
							fragmentsAnimationSet = (archetype as FragmentsArchetype).particleAnimationSet = new ParticleAnimationSet(true);
							fragmentsAnimationSet.addAnimation(new ParticlePositionNode(ParticlePropertiesMode.LOCAL_DYNAMIC));
							fragmentsAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_DYNAMIC));
							fragmentsAnimationSet.addAnimation(new ParticleRotationalVelocityNode(ParticlePropertiesMode.LOCAL_DYNAMIC));
							fragmentsAnimationSet.initParticleFunc = initParticleFuncFragments;
						}
						
						particleMeshes = fragmentsArchetype.particleMeshes = new Vector.<Mesh>();
						
						var fragmentsGeometrySet:Vector.<Geometry>;
						var frame:Vector.<Vector3D>;
						var position:Vector3D;
						for each (frame in particlePositions) {
							//generate the particle geometry vector
							fragmentsGeometrySet = new Vector.<Geometry>();
							for each (position in frame) 
								fragmentsGeometrySet.push(fragmentsArchetype.geometry);
							
							//generate vectors for velocities and rotationalvelocities
							particleVelocities.push(new Vector.<Vector3D>(frame.length));
							particleRotationalVelocities.push(new Vector.<Vector3D>(frame.length));
							
							//generate the particle mesh
							particleMesh = new Mesh( ParticleGeometryHelper.generateGeometry(fragmentsGeometrySet), material );
							particleMeshes.push(particleMesh);
							entityView.addChild(particleMesh);
							
							//generate the particle animator
							particleAnimator = new ParticleAnimator(fragmentsAnimationSet);
							(particleAnimator.getAnimationStateByName("ParticlePositionLocalDynamic") as ParticlePositionState).setPositions(frame);
							particleMesh.animator = particleAnimator;
						}
					}
					
					//passes the cellposition data from invawayder to fragments archetype
					entity.add( new Fragments(particleMeshes, particlePositions, particleVelocities, particleRotationalVelocities) );
					break;
					
				default:
					
					if (subType.entityView) {
						entityView = subType.entityView.clone() as ObjectContainer3D;
					} else {
						entityView = subType.entityView = new Mesh(subType.geometry, material);
						
						if (subType.Component != Blast)
							material.lightPicker = lightPicker;
					}
					
					var Component:Class = subType.Component;
					entity.add( new Component() );
					break;
			}
			
			entity.add( new Display( entityView ) );
			
			return entity;
		}
		
		public function destroyEntity( entity : Entity ) : void
		{
			game.removeEntity( entity );
			
			//push entity into entity pool for archetype
			if (entity.get(DataModel))
				(entity.get(DataModel) as DataModel).subType.entityPool.push(entity);
		}
				
		/**
		 * Internal function used to create cell position data for each invawayder data instance's cell definition data.
		 * 
		 * @param definition The vector of unsigned integers representing the cell definition of the invawayder to be processed.
		 * @param gridDimensions A point vector representing the 2D width and height of the invawayder's cell definition.
		 * 
		 * @return A vector of point data representing the cell positions of the invawayder data.
		 */
		private function createInvawayderparticlePositions( definition:Vector.<uint>, gridDimensions:Point ):Vector.<Vector3D>
		{
			var particlePositions:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			var i:uint, j:uint;
			var cellSize:Number = GameSettings.invawayderSizeXY;
			var lenX:uint = gridDimensions.x;
			var lenY:uint = gridDimensions.y;
			var offX:Number = -( lenX - 1 ) * cellSize / 2;
			var offY:Number = (lenY - 1 ) * cellSize / 2;
			
			for( j = 0; j < lenY; j++ )
				for( i = 0; i < lenX; i++ )
					if( definition[ j * lenX + i ] )
						particlePositions.push( new Vector3D( offX + i * cellSize, offY - j * cellSize, 0 ) );
			
			return particlePositions;
		}
		
		private function initParticleFuncExplosion(param:ParticleProperties):void
		{
			param.startTime = 0;
			param.duration = MathUtils.rand(GameSettings.explosionTimerMin, GameSettings.explosionTimerMax);
			var degree1:Number = Math.random() * Math.PI * 2;
			var degree2:Number = Math.random() * Math.PI;
			var r:Number = Math.random() * 500 + 4000;
			param[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.cos(degree1) * Math.cos(degree2), r * Math.sin(degree2));
		}
		
		private function initParticleFuncFragments(param:ParticleProperties):void
		{
			param.startTime = 0;
			param.duration = MathUtils.rand(GameSettings.deathTimerMin, GameSettings.deathTimerMax);
		}
	}
}
