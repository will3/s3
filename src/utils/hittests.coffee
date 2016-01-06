coordUtils = require './coordutils.coffee'
chunkUtils = require './chunkutils.coffee'

module.exports = 
	blockAndSphere: (blockModel, coord, radius) ->
		found = false

		callback = (x, y, z, obj, dis) ->
			if obj? and obj.integrity > 0
				found = true
				return true

		chunkUtils.visitAround blockModel.chunk, coord, radius, callback

		return found