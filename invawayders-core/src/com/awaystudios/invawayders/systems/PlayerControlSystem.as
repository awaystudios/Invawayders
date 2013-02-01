package com.awaystudios.invawayders.systems
{
	
	import com.awaystudios.invawayders.*;
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.input.*;
	import com.awaystudios.invawayders.nodes.*;
	
	import away3d.containers.*;
	import away3d.entities.Mesh;
	
	import ash.core.*;
	
	import flash.geom.*;
	import flash.ui.*;
	
	
	public class PlayerControlSystem extends System
	{
		private var _currentPosition : Vector3D = new Vector3D();
		
		[Inject]
		public var creator : EntityManager;
		
		[Inject]
		public var view : View3D;
		
		[Inject]
		public var stageProperties : StageProperties;
		
		[Inject]
		public var keyPoll : KeyPoll;
		
		[Inject]
		public var mousePoll : MousePoll;
		
		[Inject]
		public var accelerometerPoll : AccelerometerPoll;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.PlayerNode")]
		public var players : NodeList;
		
		override public function update( time : Number ) : void
		{
			time *= 1000;
			
			//determine whether input is coming from teh mouse or accelerometer
			if (accelerometerPoll.isAccelerometer) {
				_currentPosition.x = -accelerometerPoll.accelerometerX * GameSettings.cameraPanRange;
				_currentPosition.y = (accelerometerPoll.centerY - accelerometerPoll.accelerometerY) * GameSettings.cameraPanRange;
			} else if( mousePoll.isOnStage) {
				if( mousePoll.mouseX > 0 && mousePoll.mouseX < 100000 )
					_currentPosition.x = mousePoll.mouseX;
				
				if( mousePoll.mouseY > 0 && mousePoll.mouseY < 100000 )
					_currentPosition.y = mousePoll.mouseY;
			}
			
			var playerNode : PlayerNode;
			var player : Player;
			var transform : Transform3D;
			var motion : Motion3D;

			for ( playerNode = players.head; playerNode; playerNode = playerNode.next )
			{
				player = playerNode.player;
				transform = playerNode.transform;
				motion = playerNode.motion;
				
				// update player position in the x / y plane
				if (accelerometerPoll.isAccelerometer) {
					motion.velocity.x =  (GameSettings.accelerometerMotionFactorX * _currentPosition.x - transform.x) * GameSettings.accelerometerCameraMotionEase;
					motion.velocity.y =  (GameSettings.accelerometerMotionFactorY * _currentPosition.y - transform.y) * GameSettings.accelerometerCameraMotionEase;
				} else {
					motion.velocity.x = (GameSettings.mouseMotionFactor * ( _currentPosition.x / stageProperties.halfWidth - 1 ) - transform.x) * GameSettings.mouseCameraMotionEase;
					motion.velocity.y = (-GameSettings.mouseMotionFactor * ( _currentPosition.y / stageProperties.halfHeight - 1 ) - transform.y) * GameSettings.mouseCameraMotionEase;
				}
				
				if( GameSettings.panTiltFactor != 0 ) {
					transform.rotationY = -GameSettings.panTiltFactor * transform.x;
					transform.rotationX =  GameSettings.panTiltFactor * transform.y;
				}
				
				//increment shot delay
				player.fireTimer -= time;
				
				//check if shot is due
				if ( (keyPoll.isDown( Keyboard.SPACE ) || mousePoll.leftMouseDown) && player.fireTimer < 0 )
				{
					player.fireCounter++;
					
					//kick back on the blasters
					var blaster:Mesh = player.fireCounter % 2 ? player.rightBlaster : player.leftBlaster;
					blaster.z -= 500;
					
					//create projectile
					creator.createEntity( transform.x + blaster.x, transform.y + blaster.y, transform.z - 750, new Vector3D(0, 0, 200), ArchetypeLibrary.PROJECTILE, ProjectileArchetype.PLAYER );
					
					//reset shot delay
					player.fireTimer = GameSettings.blasterFireRateMS;
				}
				
				//allow blasters to gradually spring back after recoil
				player.leftBlaster.z += 0.25 * (GameSettings.blasterOffsetD - player.leftBlaster.z);
				player.rightBlaster.z += 0.25 * (GameSettings.blasterOffsetD - player.rightBlaster.z);
			}
		}
	}
}
