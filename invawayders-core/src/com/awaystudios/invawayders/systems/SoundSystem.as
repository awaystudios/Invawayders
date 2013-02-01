package com.awaystudios.invawayders.systems
{
	import com.awaystudios.invawayders.nodes.*;
	import com.awaystudios.invawayders.sounds.*;
	
	import ash.core.*;
	
	public class SoundSystem extends System
	{
		[Inject]
		public var soundLibrary : SoundLibrary;
		
		[Inject(nodeType="com.awaystudios.invawayders.nodes.SoundNode")]
		public var nodes : NodeList;
		
		[PostConstruct]
		public function setUpListeners() : void
		{
			nodes.nodeAdded.add( addToNodes );
		}
		
		private function addToNodes( node : SoundNode ) : void
		{
			if (node.dataModel.subType.soundOnAdd)
				soundLibrary.playSound(node.dataModel.subType.soundOnAdd);
		}
	}
}