chunkUtils = require '../utils/chunkutils.coffee'
BlockLoader = require '../blockloader.coffee'

module.exports = (app, options = {}) ->
	control = options.control || false
	data = options.data

	object = new THREE.Object3D()
	blockModel = app.attach object, 'blockModel'

	blockMesher = app.attach object, 'blockMesher'

	if control
		shipControl = app.attach object, 'shipControl'

	ship = app.attach object, 'ship'
	rigidBody = app.attach object, 'rigidBody'
	blockAttachments = app.attach object, 'blockAttachments'
	cooldown = app.attach object, 'cooldown'

	if control
		shipControl.cooldown = cooldown
		shipControl.ship = ship

	blockAttachments.blockModel = blockModel

	ship.rigidBody = rigidBody
	ship.blockAttachments = blockAttachments
	ship.blockModel = blockModel

	blockMesher.blockModel = blockModel

	if data?
		loader = new BlockLoader()
		loader.load app, object, data
		ship.updateRadius()



	return object