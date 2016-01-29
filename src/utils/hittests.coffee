coordUtils = require './coordutils.coffee'
chunkUtils = require './chunkutils.coffee'

module.exports = 
	blockAndSphere: (blockModel, rigidBody) ->
		radius = rigidBody.radius / blockModel.gridSize
		radius = Math.ceil radius
		maxRadius = 3
		if radius > maxRadius
			radius = maxRadius
			
		point = rigidBody.object.getWorldPosition()
		localPoint = blockModel.object.worldToLocal point
		coord = coordUtils.pointToCoord localPoint, blockModel

		found = false
		coordFound = null

		callback = (x, y, z, obj, dis) ->
			if obj? and !!obj.color and obj.integrity > 0
				found = true
				coordFound = new THREE.Vector3 x, y, z
				return true

		
		chunkUtils.visitAround blockModel.chunk, coord, radius, callback

		if !found
			return false

		return coord: coordFound