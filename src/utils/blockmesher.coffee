mesher = require '../voxel/mesher'

module.exports = () ->
# mesher = require '../voxel/mesher'

# class BlockMesher
# 	@$inject: ['app']
# 	constructor: (@app) ->
# 		@dirty = false
# 		@blockModel = null
# 		@obj = null
# 		@material = new THREE.MeshLambertMaterial
# 			vertexColors: true

# 	start: () ->
# 		if @blockModel is null
# 			throw new Error 'blockModel cannot be null'
# 		@obj = new THREE.Object3D
# 		@object.add(@obj)
# 		return

# 	tick: () ->
# 		chunk = @blockModel.chunk
# 		for id, chunk of chunk.chunks when chunk.dirty
# 			@updateChunk chunk
# 			chunk.dirty = false
# 		return

# 	updateChunk: (chunk) ->
# 		origin = @blockModel.origin
# 		gridSize = @blockModel.gridSize

# 		mesh = chunk.mesh
# 		map = chunk.map
# 		if mesh isnt null
# 			@obj.remove mesh
# 			mesh.geometry.dispose()
# 			mesh.material.dispose()

# 		result = mesher map.data, map.shape

# 		geometry = new THREE.Geometry
# 		geometry.vertices = result.vertices.map (v) =>
# 			new THREE.Vector3 v[0], v[1], v[2]
# 				.add origin
# 				.sub new THREE.Vector3 0.5, 0.5, 0.5
# 				.multiplyScalar gridSize

# 		geometry.faces = result.faces.map (f) =>
# 			face = new THREE.Face3 f[0], f[1], f[2]
# 			face.color = new THREE.Color f[3]
# 			return face

# 		geometry.computeFaceNormals()

# 		mesh = new THREE.Mesh geometry, @material
# 		chunk.mesh = mesh

# 		origin = new THREE.Vector3(
# 			chunk.origin[0] * gridSize
# 			chunk.origin[1] * gridSize
# 			chunk.origin[2] * gridSize
# 			)
# 		mesh.position.copy origin

# 		@obj.add mesh
# 		return

# 	dispose: () ->
# 		@material.dispose()
# 		for id, chunk of @chunks
# 			chunk.geometry.dispose()
# 		@object.remove @obj

# module.exports = BlockMesher