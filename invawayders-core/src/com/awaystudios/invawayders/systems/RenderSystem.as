package com.awaystudios.invawayders.systems
{
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.nodes.*;
	
	import away3d.containers.*;
	
	import ash.core.*;
	
	public class RenderSystem extends System
	{
		[Inject]
		public var view : View3D;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.RenderNode")]
		public var nodes : NodeList;

		[PostConstruct]
		public function setUpListeners() : void
		{
			for( var node : RenderNode = nodes.head; node; node = node.next )
			{
				addToDisplay( node );
			}
			nodes.nodeAdded.add( addToDisplay );
			nodes.nodeRemoved.add( removeFromDisplay );
		}
		
		private function addToDisplay( node : RenderNode ) : void
		{
			view.scene.addChild( node.display.container );
		}
		
		private function removeFromDisplay( node : RenderNode ) : void
		{
			view.scene.removeChild( node.display.container );
		}

		override public function update( time : Number ) : void
		{
			var renderNode : RenderNode;
			var transform : Transform3D;
			var container : ObjectContainer3D;

			for ( renderNode = nodes.head; renderNode; renderNode = renderNode.next )
			{
				container = renderNode.display.container;
				transform = renderNode.transform;

				container.x = transform.x;
				container.y = transform.y;
				container.z = transform.z;
				container.rotationX = transform.rotationX;
				container.rotationY = transform.rotationY;
				container.rotationZ = transform.rotationZ;
				container.scaleX = transform.scaleX;
				container.scaleY = transform.scaleY;
				container.scaleZ = transform.scaleZ;
			}
		}
	}
}
