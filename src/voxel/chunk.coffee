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
		for i in [0..shape[0]]
			for j in [0..shape[1]]
				for k in [0..shape[2]]
					stop = callback i, j, k, @map.get i, j, k
					if stop
						return stop

	serialize: () ->
		origin: @origin
		chunkSize: @chunkSize
		map: {
			shape: @map.shape,
			data: @map.data
		}

	deserialize: (json) ->
		@origin = json.origin
		@chunkSize = json.chunkSize
		@map = ndarray(json.map.data, json.map.shape)

class Chunk
	constructor: (@chunkSize = 16) ->
		@chunks = {}

	get: (x, y, z) ->
		chunk = @getChunk x, y, z
		if chunk is undefined
			return undefined
		chunk.get x, y, z

	set: (x, y, z, value) ->
		chunk = @getChunk x, y, z
		chunk = @addChunk x, y, z if chunk is undefined
		chunk.set x, y, z, value
		return

	getChunk: (x, y, z) ->
		origin = @getOrigin x, y, z
		id = origin.join ','
		return @chunks[id]

	hasChunk: (x, y, z) ->
		return @getChunk(x, y, z) isnt undefined

	addChunk: (x, y, z) ->
		origin = @getOrigin x, y, z
		id = origin.join ','
		if @chunks[id] is undefined
			@chunks[id] = new FixedSizeChunk @chunkSize
			@chunks[id].origin = origin
		@chunks[id]

	getOrigin: (x, y, z) ->
		[
			Math.floor(x / @chunkSize) * @chunkSize,
			Math.floor(y / @chunkSize) * @chunkSize,
			Math.floor(z / @chunkSize) * @chunkSize
		]

	serialize: () ->
		chunks = []
		for id, chunk of @chunks
			chunks.push chunk.serialize()

		chunkSize: @chunkSize,
		chunks: chunks

	deserialize: (json) ->
		@chunkSize = chunkSize
		@chunks = {}
		chunks = json.chunks
		for c in chunks
			chunk = new FixedSizeChunk()
			chunk.deserialize(c)

	visit: (callback) ->
		for id, chunk of @chunks
			stop = chunk.visit callback
			if stop
				return stop

module.exports = Chunk