ndarray = require 'ndarray'

class Block
	constructor: () ->
		@color = 0xff0000

class FixedSizeChunk 
	constructor: (@chunkSize = 16) ->
		@origin = [0, 0, 0]
		@map = ndarray [], [@size, @size, @size]
		@dirty = false
		@mesh = null

	get: (x, y, z) ->
		return @map.get x - @origin[0], y - @origin[1], z - @origin[2]

	set: (x, y, z, value) ->
		@map.set x - @origin[0], y - @origin[1], z - @origin[2], value
		@dirty = true

	dispose: () ->
		if @mesh isnt null
			@mesh.geometry.dispose()
			@mesh.material.dispose()

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

	dispose: () ->
		for id, chunk of @chunks
			chunk.dispose()
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

module.exports = Chunk