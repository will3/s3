genAsteroid = require '../voxel/procedural/asteroid.coffee'

class Asteroid
	constructor: (@app) ->
		@blockModel = null

	start: () ->
		if @blockModel is null
			throw new Error 'blockModel cannot be empty'

		result = genAsteroid();

		map = result.voxels
		shape = map.shape
		for i in [0..shape[0]]
			for j in [0..shape[1]]
				for k in [0..shape[2]]
					b = map.get i, j, k
					@blockModel.set i, j, k, b

		origin = result.origin;
		@blockModel.origin = new THREE.Vector3(origin[0], origin[1], origin[2]);

		return

	tick: () ->
		return

module.exports = Asteroid