chunkUtils = require '../utils/chunkutils.coffee'
module.exports = (app) ->
	object = new THREE.Object3D()
	blockModel = app.attach object, 'blockModel'
	model = require '../data/ship0.json'
	blockModel.deserialize model
	blockModel.origin = chunkUtils.ccw blockModel.chunk

	blockMesher = app.attach object, 'blockMesher'
	shipControl = app.attach object, 'shipControl'
	ship = app.attach object, 'ship'
	rigidBody = app.attach object, 'rigidBody'
	blockAttachments = app.attach object, 'blockAttachments'

	blockAttachments.blockModel = blockModel

	shipControl.ship = ship

	ship.rigidBody = rigidBody
	ship.blockAttachments = blockAttachments

	blockMesher.blockModel = blockModel

	return object