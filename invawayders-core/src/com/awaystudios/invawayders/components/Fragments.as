package com.awaystudios.invawayders.components
{
	import away3d.entities.*;
	
	import flash.geom.*;
	
	public class Fragments
	{
		public var currentFrame : uint;
		
		public var particleMeshes : Vector.<Mesh>;
		
		public var particlePositions:Vector.<Vector.<Vector3D>>;
		
		public var particleVelocities:Vector.<Vector.<Vector3D>>;
		
		public var particleRotationalVelocities:Vector.<Vector.<Vector3D>>;
		
		public function Fragments(particleMeshes : Vector.<Mesh>, particlePositions:Vector.<Vector.<Vector3D>>, particleVelocities:Vector.<Vector.<Vector3D>>, particleRotationalVelocities:Vector.<Vector.<Vector3D>>)
		{
			this.particleMeshes = particleMeshes;
			this.particlePositions = particlePositions;
			this.particleVelocities = particleVelocities;
			this.particleRotationalVelocities = particleRotationalVelocities;
		}
	}
}
