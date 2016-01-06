_ = require 'lodash'
THREE = require 'three'
Chunk = require '../voxel/chunk.coffee'

class BlockModel
	@$inject: ['app']
	
	constructor: (@app) ->
		@chunk = new Chunk()
		@render = new Chunk()

		@gridSize = 1
		@origin = new THREE.Vector3()
		@objModel = new THREE.Object3D()

	start: () ->
		@object.add @objModel

	tick: () ->
		offset = @origin.clone().multiplyScalar @gridSize
		@objModel.position.copy offset

	set: (x, y, z, obj) ->
		if obj? and typeof obj is 'number'
			obj = 
				color: obj
				integrity: 1.0
				touchness: 2.0

		@chunk.set x, y, z, obj
		@update x, y, z

		return

	update: (x, y, z) ->
		obj = @chunk.get x, y, z
		if not obj? or obj.integrity <= 0
			@render.set x, y, z, undefined
			return

		if obj.integrity is 1.0
			@render.set x, y, z, obj.color
		else
			color = new THREE.Color obj.color
			shade = 0.4 + 0.6 * obj.integrity
			color.r *= shade
			color.g *= shade
			color.b *= shade
			@render.set x, y, z, color.getHex()

	setAtCoord: (coord, obj) ->
		@set coord.x, coord.y, coord.z, obj

	get: (x, y, z) ->
		@chunk.get x, y, z

	getAtCoord: (coord) ->
		@get coord.x, coord.y, coord.z

	serialize: () ->
		body = {}
		body.gridSize = @gridSize;
		body.origin = [@origin.x, @origin.y, @origin.z]
		body.chunk = []
		@chunk.visit (i, j, k, value) ->
			body.chunk.push [i, j, k, value]

		return body

	deserialize: (body) ->
		@gridSize = body.gridSize
		@origin = new THREE.Vector3 body.origin[0], body.origin[1], body.origin[2]
		# dispose chunk geometries
		for id, chunk of @chunk
			chunk.mesh.geometry.dispose() if chunk.mesh?

		@chunk = new Chunk()
		for v in body.chunk
			@set v[0], v[1], v[2], v[3]

		return @

module.exports = BlockModel
