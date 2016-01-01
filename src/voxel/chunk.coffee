ndarray = require 'ndarray'

class FixedSizeChunk 
	constructor: (@chunkSize = 16) ->
		@origin = [0, 0, 0]
		@map = ndarray [], [@chunkSize, @chunkSize, @chunkSize]
		@dirty = false
		@mesh = null

	get: (x, y, z) ->
		return @map.get x - @origin[0], y - @origin[1], z - @origin[2]

	set: (x, y, z, value) ->
		@map.set x - @origin[0], y - @origin[1], z - @origin[2], value
		@dirty = true
		return

	visit: (callback) ->
		shape = @map.shape
		for i in [0...shape[0]]
			for j in [0...shape[1]]
				for k in [0...shape[2]]
					callback i, j, k, @map.get i, j, k

class Chunk
	constructor: (@chunkSize = 16) ->
		@chunks = {}

	get: (x, y, z) ->
		origin = @getOrigin x, y, z
		id = origin.join ','
		chunk = @chunks[id]

		if chunk is undefined
			return undefined
		chunk.get x, y, z

	set: (x, y, z, value) ->
		origin = @getOrigin x, y, z
		id = origin.join ','
		chunk = @chunks[id]

		if chunk is undefined
			chunk = new FixedSizeChunk @chunkSize
			chunk.origin = origin
			@chunks[id] = chunk

		chunk.set x, y, z, value
		return

	hasChunk: (x, y, z) ->
		origin = @getOrigin x, y, z
		id = origin.join ','

		return @chunks[id] isnt undefined

	getOrigin: (x, y, z) ->
		[
			Math.floor(x / @chunkSize) * @chunkSize,
			Math.floor(y / @chunkSize) * @chunkSize,
			Math.floor(z / @chunkSize) * @chunkSize
		]

	visit: (callback) ->
		for id, chunk of @chunks
			origin = chunk.origin
			chunk.visit (x, y, z, v) ->
				callback x + origin[0], y + origin[1], z + origin[2], v

module.exports = Chunk