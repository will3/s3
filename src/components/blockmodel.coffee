_ = require 'lodash'
THREE = require 'three'
mesher = require '../voxel/mesher'
Chunk = require '../voxel/chunk.coffee'

class BlockModel
	constructor: () ->
		@chunk = new Chunk()
		@gridSize = 1
		@obj = null
		@material = new THREE.MeshBasicMaterial
			vertexColors: true
		# @material = new THREE.MeshLambertMaterial
		# 	vertexColors: true
		@origin = new THREE.Vector3()

	start: () -> 
		@obj = new THREE.Object3D
		@object.add(@obj)
		return

	tick: () -> 
		for id, chunk of @chunk.chunks when chunk.dirty
			@updateChunk chunk
			chunk.dirty = false
		return

	set: (x, y, z, obj) ->
		@chunk.set x, y, z, obj
		return

	get: (x, y, z) ->
		@chunk.get x, y, z
		
	dispose: () ->
		@material.dispose()
		for id, chunk of @chunks
			chunk.geometry.dispose()
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
				.add @origin
				.sub new THREE.Vector3 0.5, 0.5, 0.5
				.multiplyScalar @gridSize

		geometry.faces = result.faces.map (f) =>
			face = new THREE.Face3 f[0], f[1], f[2]
			face.color = new THREE.Color f[3]
			return face

		geometry.computeFaceNormals()

		mesh = new THREE.Mesh geometry, @material
		chunk.mesh = mesh

		origin = new THREE.Vector3(
			chunk.origin[0] * @gridSize
			chunk.origin[1] * @gridSize
			chunk.origin[2] * @gridSize
			)
		mesh.position.copy origin

		@obj.add mesh
		return

	pointToCoord: (point) ->
		coord = point.clone().multiplyScalar(1 / @gridSize)
		.sub @origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)

	coordToPoint: (coord) ->
		new THREE.Vector3 coord.x, coord.y, coord.z
				.add @origin
				.multiplyScalar @gridSize 

module.exports = BlockModel
