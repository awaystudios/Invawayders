package com.awaystudios.invawayders.primitives
{
	import away3d.core.base.*;
	import away3d.primitives.*;
	
	import flash.geom.*;
	
	/**
	 * Primitive geometry class that creates an invawayder mesh from the cell definition of the invawayder archetype.
	 */
	public class InvawayderGeometry extends PrimitiveBase
	{
		private var _cellDefinition:Vector.<uint>;
		private var _gridDimensions:Point;
		private var _cellSizeXY:Number;
		private var _cellSizeZ:Number;
		
		private var _vertices:Vector.<Number>;
		private var _indices:Vector.<uint>;
		private var _currentIndex:uint;
		
		/**
		 * Creates a new <code>InvawayderGeometry</code> object.
		 * 
		 * @param cellSizeXY The dimension of the XY edge of each cell.
		 * @param cellSizeZ The dimension of the Z edge of each cell.
		 * @param cellDefinition The cell definitions from the invawayder archetype used to create the invawayder geometry.
		 * @param gridDimensions The 2D dimensions of the grid used for the cell definition.
		 */
		public function InvawayderGeometry( cellSizeXY:Number, cellSizeZ:Number, cellDefinition:Vector.<uint>, gridDimensions:Point )
		{
			super();
			_cellSizeXY = cellSizeXY;
			_cellSizeZ = cellSizeZ;
			_cellDefinition = cellDefinition;
			_gridDimensions = gridDimensions;
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry( target:CompactSubGeometry ):void
		{

			_vertices = new Vector.<Number>();
			_indices = new Vector.<uint>();
			_currentIndex = 0;
			
			var i:uint, j:uint;
			var posX:Number, posY:Number;
			var offX:Number, offY:Number;
			var p0:Vector3D, p1:Vector3D, p2:Vector3D, p3:Vector3D, p4:Vector3D, p5:Vector3D, p6:Vector3D, p7:Vector3D;
			
			var lenX:uint = _gridDimensions.x;
			var lenY:uint = _gridDimensions.y;
			offX = _cellSizeXY / 2 - ( lenX / 2 ) * _cellSizeXY;
			offY = -_cellSizeXY / 2 + ( lenY / 2 ) * _cellSizeXY;
			var halfCellSizeXY:Number = _cellSizeXY / 2;
			var halfCellSizeZ:Number = _cellSizeZ / 2;
			
			for( j = 0; j < lenY; j++ ) {
				for( i = 0; i < lenX; i++ ) {
					if( isCellActiveAtCoordinates( i, j ) == 1 ) {
						var neighbors:Vector3D = areNeighborsActiveAtCoordinates( i, j );
						posX = offX + i * _cellSizeXY;
						posY = offY - j * _cellSizeXY;
						p0 = new Vector3D( posX - halfCellSizeXY, posY + halfCellSizeXY, -halfCellSizeZ );
						p1 = new Vector3D( posX + halfCellSizeXY, posY + halfCellSizeXY, -halfCellSizeZ );
						p2 = new Vector3D( posX - halfCellSizeXY, posY - halfCellSizeXY, -halfCellSizeZ );
						p3 = new Vector3D( posX + halfCellSizeXY, posY - halfCellSizeXY, -halfCellSizeZ );
						p4 = new Vector3D( posX - halfCellSizeXY, posY + halfCellSizeXY,  halfCellSizeZ );
						p5 = new Vector3D( posX + halfCellSizeXY, posY + halfCellSizeXY,  halfCellSizeZ );
						p6 = new Vector3D( posX - halfCellSizeXY, posY - halfCellSizeXY,  halfCellSizeZ );
						p7 = new Vector3D( posX + halfCellSizeXY, posY - halfCellSizeXY,  halfCellSizeZ );
						if( neighbors.x == 0 ) { // LEFT
							addQuad(
								p4, p0, p6, p2,
								new Vector3D( -1, 0, 0 )
							);
						}
						if( neighbors.y == 0 ) { // RIGHT
							addQuad(
								p1, p5, p3, p7,
								new Vector3D( 1, 0, 0 )
							);
						}
						if( neighbors.z == 0 ) { // TOP
							addQuad(
								p1, p0, p5, p4,
								new Vector3D( -1, 0, 0 )
							);
						}
						if( neighbors.w == 0 ) { // BOTTOM
							addQuad(
								p7, p6, p3, p2,
								new Vector3D( -1, 0, 0 )
							);
						}
						// FRONT (always).
						addQuad(
							p0, p1, p2, p3,
							new Vector3D( 0, 0, -1 )
						);
						// BACK (never).
					}
				}
			}
			
			// Report geom data.
			target.updateData(_vertices);
			target.updateIndexData(_indices);
			_vertices = null;
			_indices  = null;
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target : CompactSubGeometry) : void
		{
			var stride:uint = target.UVStride;
			var numUvs : uint = target.vertexData.length;
			var data : Vector.<Number>;
			var skip:uint = stride - 2;

			if (target.UVData && numUvs == target.UVData.length)
				data = target.UVData;
			else {
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}

			var index : int;
			for (index = target.UVOffset; index < numUvs; index += skip) {
				data[index++] = 0;
				data[index++] = 0;
			}
			
			target.updateData(data);
		}
		
		/**
		 * Utility function used to add a single quad denifition to the stream data (a quad is made up of two triangles).
		 * 
		 * @param p0 The first vertex in the quad.
		 * @param p1 The second vertex in the quad.
		 * @param p2 The third vertex in the quad.
		 * @param p3 The fourth vertex in the quad.
		 * @param normal The normal vector of the quad.
		 */
		private function addQuad( p0:Vector3D, p1:Vector3D, p2:Vector3D, p3:Vector3D, normal:Vector3D ):void
		{
			_vertices.push( p0.x, p0.y, p0.z );
			_vertices.push( normal.x, normal.y, normal.z );
			_vertices.push( 0, 0, 0 ); // Ignoring tangents ( ok as long as color materials are used ).
			_vertices.push( 0, 0 ); // Ignoring UVs ( ok as long as color materials are used ).
			_vertices.push( 0, 0 );
			_vertices.push( p1.x, p1.y, p1.z );
			_vertices.push( normal.x, normal.y, normal.z );
			_vertices.push( 0, 0, 0 );
			_vertices.push( 0, 0 );
			_vertices.push( 0, 0 );
			_vertices.push( p2.x, p2.y, p2.z );
			_vertices.push( normal.x, normal.y, normal.z );
			_vertices.push( 0, 0, 0 );
			_vertices.push( 0, 0 );
			_vertices.push( 0, 0 );
			_vertices.push( p3.x, p3.y, p3.z );
			_vertices.push( normal.x, normal.y, normal.z );
			_vertices.push( 0, 0, 0 );
			_vertices.push( 0, 0 );
			_vertices.push( 0, 0 );
			_indices.push( _currentIndex + 0, _currentIndex + 1, _currentIndex + 2 );
			_indices.push( _currentIndex + 1, _currentIndex + 3, _currentIndex + 2 );
			_currentIndex += 4;
		}
		
		/**
		 * Returns a Vector3D represents the following:
		 * 	  z
		 * 	x n y
		 * 	  w
		 * with n being the cell at the current coordinates and each x, y, z, w value being 1 if the neighbor is active or 0 otherwise.
		 * 
		 * @param i The horizontal position to check in the grid.
		 * @param j The vertical position to check in the grid.
		 * 
		 * @return The 3D vector representing the surrounding active cell status.
		 */
		private function areNeighborsActiveAtCoordinates( i:uint, j:uint ):Vector3D
		{
			var reply:Vector3D = new Vector3D();
			reply.x = i == 					   0 ? 0 : isCellActiveAtCoordinates( i - 1, j     );
			reply.y = i == _gridDimensions.x - 1 ? 0 : isCellActiveAtCoordinates( i + 1, j     );
			reply.z = j == 					   0 ? 0 : isCellActiveAtCoordinates( i,     j - 1 );
			reply.w = j == _gridDimensions.y - 1 ? 0 : isCellActiveAtCoordinates( i,     j + 1 );
			return reply;
		}
		
		/**
		 * Checks whether the given cell is active
		 * 
		 * @param i The horizontal of the cell in the grid.
		 * @param j The vertical of the cell in the grid.
		 * 
		 * @return A value of 1 (active) or 0 (inactive).
		 */
		private function isCellActiveAtCoordinates( i:uint, j:uint ):uint
		{
			var cellIndex:uint = j * _gridDimensions.x + i;
			return _cellDefinition[ cellIndex ];
		}
	}
}
