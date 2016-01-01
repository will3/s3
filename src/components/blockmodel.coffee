_ = require 'lodash'
THREE = require 'three'
Chunk = require '../voxel/chunk.coffee'

class BlockModel
	constructor: () ->
		@chunk = new Chunk()
		@gridSize = 1
		@origin = new THREE.Vector3()

	set: (x, y, z, obj) ->
		@chunk.set x, y, z, obj
		return

	setAtCoord: (coord, obj) ->
		@chunk.set coord.x, coord.y, coord.z, obj

	get: (x, y, z) ->
		@chunk.get x, y, z

	serialize: () ->
		body = {}
		body.gridSize = @gridSize;
		body.origin = [@origin.x, @origin.y, @origin.z]
		body.chunk = []
		@chunk.visit (i, j, k, value) ->
			body.chunk.push [i, j, k, value] if !!value

		return body

	deserialize: (body) ->
		@gridSize = body.gridSize
		@origin = new THREE.Vector3 body.origin[0], body.origin[1], body.origin[2]
		# dispose chunk geometries
		for id, chunk of @chunk
			chunk.geometry.dispose() if chunk.geometry?

		@chunk = new Chunk()
		for v in body.chunk
			@chunk.set v[0], v[1], v[2], v[3]

		return @

module.exports = BlockModel
