package com.awaystudios.invawayders.systems
{
	import com.awaystudios.invawayders.*;
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.nodes.*;
	
	import ash.core.*;
	
	public class MovementSystem extends System
	{
		[Inject]
		public var creator : EntityManager;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.MovementNode")]
		public var movementNodes : NodeList;
		
		override public function update( time : Number ) : void
		{
			var movementNode : MovementNode;
			var position : Transform3D;
			var motion : Motion3D;

			for ( movementNode = movementNodes.head; movementNode; movementNode = movementNode.next )
			{
				position = movementNode.position;
				motion = movementNode.motion;
				
				position.x += motion.velocity.x;
				position.y += motion.velocity.y;
				position.z += motion.velocity.z;
				
				//remove entities that stray outside the play area
				if (position.z < GameSettings.minZ || position.z > GameSettings.maxZ)
					creator.destroyEntity(movementNode.entity);
			}
		}
	}
}
