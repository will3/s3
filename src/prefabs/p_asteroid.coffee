chunkUtils = require '../utils/chunkutils.coffee'
CollisionGroups = require '../collisiongroups.coffee'

module.exports = (app) ->
	object = new THREE.Object3D()
	blockModel = app.attach object, 'blockModel'
	blockModel.gridSize = 2
	
	asteroid = app.attach object, 'asteroid'

	blockMesher = app.attach object, 'blockMesher'
	blockMesher.blockModel = blockModel

	radius = chunkUtils.radius blockModel.chunk
	radius *= blockModel.gridSize

	rigidBody = app.attach object, 'rigidBody'
	rigidBody.body.mass = 0
	rigidBody.body.type = CANNON.Body.Dynamic
	rigidBody.body.addShape new CANNON.Sphere radius
	rigidBody.radius = radius
	rigidBody.body.collisionResponse = false
	rigidBody.body.collisionFilterGroup = CollisionGroups.Ship
	rigidBody.body.collisionFilterMask = CollisionGroups.Ammo | CollisionGroups.Ship

	asteroid.blockModel = blockModel
	asteroid.rigidBody = rigidBody

	return object