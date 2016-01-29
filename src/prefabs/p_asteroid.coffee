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
	rigidBody.group = CollisionGroups.Structure
	rigidBody.radius = radius

	rigidBody.body.mass = 0
	rigidBody.body.type = CANNON.Body.Dynamic
	rigidBody.body.addShape new CANNON.Sphere radius
	rigidBody.body.collisionResponse = false
	rigidBody.body.collisionFilterGroup = CollisionGroups.Structure
	rigidBody.body.collisionFilterMask = CollisionGroups.Ammo | CollisionGroups.Ship

	asteroid.blockModel = blockModel

	damagable = app.attach object, 'damagable'

	return object