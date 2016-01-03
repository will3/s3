mesher = require '../voxel/mesher'

class BlockMesher
	@$inject: ['app']
	constructor: (@app) ->
		@blockModel = null
		@material = new THREE.MeshLambertMaterial
			vertexColors: true
		@obj = null

	start: () ->
		if @blockModel is null
			throw new Error 'blockModel cannot be null'
		@obj = @blockModel.objModel
		return

	tick: () ->
		chunk = @blockModel.chunk
		for id, chunk of chunk.chunks when chunk.dirty
			@updateChunk chunk
			chunk.dirty = false

		return

	updateChunk: (chunk) ->
		gridSize = @blockModel.gridSize

		mesh = chunk.mesh
		map = chunk.map
		if mesh?
			@obj.remove mesh
			mesh.geometry.dispose()
			mesh.material.dispose()

		result = mesher map.data, map.shape

		geometry = new THREE.Geometry
		geometry.vertices = result.vertices.map (v) =>
			new THREE.Vector3 v[0], v[1], v[2]
				.sub new THREE.Vector3 0.5, 0.5, 0.5
				.multiplyScalar gridSize

		geometry.faces = result.faces.map (f) =>
			face = new THREE.Face3 f[0], f[1], f[2]
			face.color = new THREE.Color f[3]
			return face

		geometry.computeFaceNormals()

		mesh = new THREE.Mesh geometry, @material
		chunk.mesh = mesh

		offset = new THREE.Vector3(
			chunk.origin[0] * gridSize
			chunk.origin[1] * gridSize
			chunk.origin[2] * gridSize
			)
		mesh.position.copy offset

		@obj.add mesh
		return

	dispose: () ->
		@material.dispose()
		for id, chunk of @chunk
			chunk.geometry.dispose() if chunk.geometry?
		@object.remove @obj

module.exports = BlockMesher