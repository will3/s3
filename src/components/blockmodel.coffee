_ = require 'lodash'
THREE = require 'three'
mesher = require '../voxel/mesher'
Chunk = require '../voxel/chunk.coffee'

class BlockModel
	constructor: () ->
		@chunk = new Chunk()
		@gridSize = 2
		@obj = null

	start: () -> 
		@obj = new THREE.Object3D
		@object.add(@obj)
		return

	tick: () ->
		for id, chunk of @chunk.chunks when chunk.dirty
			@updateChunk chunk
			chunk.dirty = false
		return

	dispose: () ->
		@chunk.dispose()
		@object.remove @obj

	updateChunk: (chunk) ->
		mesh = chunk.mesh
		map = chunk.map
		if mesh isnt null
			@obj.remove mesh
			mesh.geometry.dispose()
			mesh.material.dispose()

		result = mesher map.data, map.shape

		geometry = new THREE.Geometry
		geometry.vertices = result.vertices.map (v) =>
			new THREE.Vector3 v[0], v[1], v[2]
				.multiplyScalar @gridSize

		geometry.faces = result.faces.map (f) =>
			face = new THREE.Face3 f[0], f[1], f[2]
			face.color = new THREE.Color @palette[f[3] - 1]
			return face

		geometry.computeFaceNormals()

		material = new THREE.MeshLambertMaterial 
			vertexColors: true

		mesh = new THREE.Mesh geometry, material
		chunk.mesh = mesh

		origin = chunk.origin.clone()
		  .multiplyScalar @gridSize
		mesh.position.copy origin

		@obj.add mesh

		return

module.exports = BlockModel
