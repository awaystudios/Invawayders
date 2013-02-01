package com.awaystudios.invawayders.nodes
{
	import com.awaystudios.invawayders.components.DataModel;
	import com.awaystudios.invawayders.components.Invawayder;
	import com.awaystudios.invawayders.components.Motion3D;
	import com.awaystudios.invawayders.components.Transform3D;
	import ash.core.Node;
	
	public class InvawayderNode extends Node
	{
		public var dataModel : DataModel;
		public var invawayder : Invawayder;
		public var transform : Transform3D;
		public var motion : Motion3D;
	}
}
