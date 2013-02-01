package com.awaystudios.invawayders.systems
{
	import away3d.animators.*;
	import away3d.animators.states.*;
	import away3d.entities.Mesh;
	
	import com.awaystudios.invawayders.*;
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.nodes.*;
	import com.awaystudios.invawayders.utils.*;
	
	import flash.geom.*;
	
	import ash.core.*;
	import ash.signals.*;
	

	
	public class CollisionSystem extends System
	{
		[Inject]
		public var creator : EntityManager;
		
		[Inject]
		public var gameStateUpdated : Signal1;
		
		[Inject]
		public var saveStateManager : SaveStateManager;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.GameNode")]
		public var gameNodes : NodeList;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.PlayerNode")]
		public var playerNodes : NodeList;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.InvawayderNode")]
		public var invawayderNodes : NodeList;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.ProjectileNode")]
		public var projectileNodes : NodeList;
		
		override public function update( time : Number ) : void
		{
			time *= 1000;
			
			var game : GameNode;
			var projectile : ProjectileNode;
			var invawayder : InvawayderNode;
			var player : PlayerNode;
			var dx : Number;
			var dy : Number;
			var dz : Number;
			var x : Number;
			var y : Number;
			var z : Number;
			var velocity : Vector3D;
			var transform : Transform3D;
			
			//update collisions when a game is present
			for ( game = gameNodes.head; game; game = game.next )
			{
				//detect collisions between projectiles and invawayders / players
				for ( projectile = projectileNodes.head; projectile; projectile = projectile.next )
				{
					x = projectile.transform.x;
					y = projectile.transform.y;
					z = projectile.transform.z;
					velocity = projectile.motion.velocity;
					
					//dispose of projectiles if they get ot far
					if (z > GameSettings.minSpawnZ) {
						creator.destroyEntity(projectile.entity);
						continue;
					}
					
					switch(projectile.dataModel.subType.id)
					{
						case ProjectileArchetype.PLAYER:
							for ( invawayder = invawayderNodes.head; invawayder; invawayder = invawayder.next )
							{
								transform = invawayder.transform;
								dz = transform.z - z;
								
								if( Math.abs( dz ) < Math.abs( velocity.z ) ) {
									dx = transform.x - x;
									dy = transform.y - y;
									if( Math.sqrt( dx * dx + dy * dy ) < GameSettings.impactHitSize * transform.scaleX ) {
										
										//destroy Projectile
										creator.destroyEntity( projectile.entity );
										
										//deplete invawayder life
										invawayder.invawayder.life -= GameSettings.blasterStrength;
										
										//show blast
										creator.createEntity(x, y, z, invawayder.motion.velocity, ArchetypeLibrary.BLAST, BlastArchetype.INVAWAYDER);
										
										//destroy invawayder if life is depleted
										if( invawayder.invawayder.life <= 0)
											destroyInvawayder(game, invawayder, x, y, z, velocity);
									}
								}
							}
							break;
						case ProjectileArchetype.INVAWAYDER:
							for ( player = playerNodes.head; player; player = player.next )
							{
								transform = player.transform;
								dz = transform.z - z;
			
								if( Math.abs( dz ) < Math.abs( velocity.z ) ) {
									dx = transform.x - x;
									dy = transform.y - y;
									if( Math.sqrt( dx * dx + dy * dy ) < GameSettings.impactHitSize ) {
										
										//destroy Projectile
										creator.destroyEntity( projectile.entity );
										
										//register a hit
										hitPlayer(game, player, x, y, z);
									}
								}
							}
							break;
						default:
					}
				}
				
				//detect collisions between players and invawayders
				for ( player = playerNodes.head; player; player = player.next )
				{
					x = player.transform.x;
					y = player.transform.y;
					z = player.transform.z;
					velocity = player.motion.velocity;
					
					for ( invawayder = invawayderNodes.head; invawayder; invawayder = invawayder.next )
					{
						transform = invawayder.transform;
						dz = transform.z - z;
						
						if( Math.abs( dz ) < Math.abs( invawayder.motion.velocity.z ) ) {
							dx = transform.x - x;
							dy = transform.y - y;
							if( Math.sqrt( dx * dx + dy * dy ) < GameSettings.impactHitSize ) {
								
								//register a hit
								hitPlayer(game, player, transform.x, transform.y, transform.z);
								
								//destroy invawayder
								destroyInvawayder(game, invawayder, x, y, z, velocity);
								
								//show invawayder blast
								creator.createEntity(transform.x, transform.y, transform.z, invawayder.motion.velocity, ArchetypeLibrary.BLAST, BlastArchetype.INVAWAYDER);
							}
						}
					}
					
					if ( player.player.shakeCounter) {
						var shakeRange:Number = GameSettings.playerHitShake * player.player.shakeCounter / GameSettings.playerCountShake;
						player.player.shakeCounter--;
						player.player.camera.x = x + MathUtils.rand( -shakeRange, shakeRange );
						player.player.camera.y = y + MathUtils.rand( -shakeRange, shakeRange );
						player.player.camera.z = -2000;
					} else {
						player.player.camera.x = x;
						player.player.camera.y = y;
						player.player.camera.z = -2000;
					}
				}
				
			}
		}
		
		private function destroyInvawayder(game : GameNode, invawayder : InvawayderNode, x : Number, y : Number, z : Number, velocity : Vector3D) : void
		{
			var transform:Transform3D = invawayder.transform;
			var currentFrame : uint = invawayder.invawayder.currentFrame;
			var archetype : InvawayderArchetype = invawayder.dataModel.subType as InvawayderArchetype;
			var particlePositions : Vector.<Vector3D> = archetype.particlePositions[currentFrame];
			var scale : Number = archetype.scale;
			var i:uint;
			
			creator.destroyEntity( invawayder.entity );
			
			//create explosion
			var explosionEntity : Entity = creator.createEntity(transform.x, transform.y, transform.z, invawayder.motion.velocity, ArchetypeLibrary.EXPLOSION, ExplosionArchetype.INVAWAYDER);
			var explosion : Explosion = explosionEntity.get(Explosion) as Explosion;
			
			//start the animation
			explosion.animator.start();
			
			//create fragments
			var fragmentsEntity : Entity = creator.createEntity(transform.x, transform.y, transform.z, invawayder.motion.velocity, ArchetypeLibrary.FRAGMENTS, invawayder.dataModel.subType.id);
			var explositonTransform:Transform3D = fragmentsEntity.get(Transform3D) as Transform3D;
			var fragments : Fragments = fragmentsEntity.get(Fragments) as Fragments;
			fragments.currentFrame = currentFrame;
			
			//reset fragments scale
			explositonTransform.scaleX = explositonTransform.scaleY = explositonTransform.scaleZ = scale;
			
			//rest fragments visibility
			for (i=0; i<fragments.particleMeshes.length; i++)
				fragments.particleMeshes[i].visible = (i == currentFrame);
			
			//reset fragments animation
			var particleMesh:Mesh = fragments.particleMeshes[currentFrame];
			var particleVelocities:Vector.<Vector3D> = fragments.particleVelocities[currentFrame];
			var particleRotationalVelocities:Vector.<Vector3D> = fragments.particleRotationalVelocities[currentFrame];
			var intensity:Number = GameSettings.deathFragmentsIntensity * MathUtils.rand( 1, 4 );
			var position:Vector3D;
			var particleVelocity:Vector3D;
			var particleRotationalVelocity:Vector3D;
			
			for (i=0; i<particlePositions.length; i++) {
				position = particlePositions[i];
				
				// Determine fragments velocity of particle.
				var dx:Number = position.x*scale + transform.x - x;
				var dy:Number = position.y*scale + transform.y - y;
				var distanceSq:Number = dx * dx + dy * dy;
				var rotSpeed:Number = intensity * 7500 / distanceSq;
				var degree1:Number = Math.random() * Math.PI * 2;
				var degree2:Number = Math.random() * Math.PI;
				
				//set the rotation velocity of the particle
				particleRotationalVelocity = particleRotationalVelocities[i] ||= new Vector3D();
				particleRotationalVelocity.x = Math.sin(degree1) * Math.cos(degree2);
				particleRotationalVelocity.y = Math.cos(degree1) * Math.cos(degree2);
				particleRotationalVelocity.z = Math.sin(degree2);
				particleRotationalVelocity.w = MathUtils.rand( -rotSpeed, rotSpeed );
				//set the linear velocity of the particle
				particleVelocity = particleVelocities[i] ||= new Vector3D();
				particleVelocity.x = 100*intensity * MathUtils.rand( GameSettings.particleVelocityMin, GameSettings.particleVelocityMax ) * dx / distanceSq;
				particleVelocity.y = 100*intensity * MathUtils.rand( GameSettings.particleVelocityMin, GameSettings.particleVelocityMax ) * dy / distanceSq;
				particleVelocity.z = 100*intensity * MathUtils.rand( GameSettings.particleVelocityMinZ, GameSettings.particleVelocityMaxZ ) * velocity.z / distanceSq;
			}
			
			//apply new velocities and rotational velocities to animator
			(particleMesh.animator.getAnimationStateByName("ParticleVelocityLocalDynamic") as ParticleVelocityState).setVelocities(particleVelocities);
			(particleMesh.animator.getAnimationStateByName("ParticleRotationalVelocityLocalDynamic") as ParticleRotationalVelocityState).setRotationalVelocities(particleRotationalVelocities);
			
			//start the animation
			(particleMesh.animator as ParticleAnimator).start();
			
			//increase score
			game.state.score += (invawayder.dataModel.subType as InvawayderArchetype).score;
			
			// Update highscore
			if( game.state.score > game.state.highScore && game.state.lives ) {
				game.state.highScore = game.state.score;
				saveStateManager.saveHighScore(game.state.highScore);
			}
			
			//dispatch game state udpated signal
			gameStateUpdated.dispatch( game.state );
			
			//update game level
			if( game.state.levelKills > GameSettings.killsToAdvanceDifficulty ) {
				game.state.levelKills = 0;
				game.state.level++;
				
				game.state.spawnTimeFactor -= GameSettings.spawnTimeFactorPerLevel;
				
				if( game.state.spawnTimeFactor < GameSettings.minimumSpawnTimeFactor )
					game.state.spawnTimeFactor = GameSettings.minimumSpawnTimeFactor;
			}
		}
		
		private function hitPlayer( game : GameNode, player : PlayerNode, x : Number, y : Number, z : Number ) : void
		{
			//deplete player lives
			game.state.lives--;
			
			//dispatch game state udpated signal
			gameStateUpdated.dispatch( game.state );
			
			//show player blast
			creator.createEntity(x, y, z, player.motion.velocity, ArchetypeLibrary.BLAST, BlastArchetype.PLAYER);
			
			//trigger camera shake
			player.player.shakeCounter = GameSettings.playerCountShake;
		}
	}
}
