coordUtils = require '../utils/coordutils.coffee'
parse = coordUtils.parse
hash = coordUtils.hash
_ = require 'lodash'

class Drag
	constructor: (@startCoord, @blockModel, @value) ->
		@endCoord = null
		@changed = {}

	run: () ->
		# @resetAll()
		@setAll()

	setAll: () ->
		x = [@startCoord.x, (@endCoord || @startCoord).x]
		y = [@startCoord.y, (@endCoord || @startCoord).y]
		z = [@startCoord.z, (@endCoord || @startCoord).z]
		startx = if x[0] < x[1] then x[0] else x[1]
		starty = if y[0] < y[1] then y[0] else y[1]
		startz = if z[0] < z[1] then z[0] else z[1]
		endx = if x[0] > x[1] then x[0] else x[1]
		endy = if y[0] > y[1] then y[0] else y[1]
		endz = if z[0] > z[1] then z[0] else z[1]

		for i in [startx..endx]
			for j in [starty..endy]
				for k in [startz..endz]
					@set new THREE.Vector3 i, j, k
		return

	resetAll: () ->
		for id, value of @changed
			coord = parse id
			@reset coord
		return

	set: (coord) ->
		id = hash(coord)
		if !@changed[id]?
			ori = @blockModel.get coord.x, coord.y, coord.z
			@changed[id] = ori

		@blockModel.set coord.x, coord.y, coord.z, @value
		return

	reset: (coord) ->
		id = [coord.x, coord.y, coord.z].join ','
		ori = @changed[id]
		if ori?
			@blockModel.set coord.x, coord.y, coord.z, ori
		return

module.exports = Drag