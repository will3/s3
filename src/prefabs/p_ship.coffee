chunkUtils = require '../utils/chunkutils.coffee'
BlockLoader = require '../blockloader.coffee'
CollisionGroups = require '../collisiongroups.coffee'
THREE = require 'three'
ShipControl = require '../components/shipcontrol.coffee'

module.exports = (app, options = {}) ->
	control = options.control || ShipControl.Keyboard.Player1
	data = options.data
	filterGroup = options.filterGroup || null
	damageExcludeMask = options.damageExcludeMask || null
	ownerId = options.ownerId || THREE.Math.generateUUID()

	object = new THREE.Object3D()
	object.rotation.order = 'YXZ'
	blockModel = app.attach object, 'blockModel'

	blockMesher = app.attach object, 'blockMesher'

	if !!control
		shipControl = app.attach object, 'shipControl'

	ship = app.attach object, 'ship'
	rigidBody = app.attach object, 'rigidBody'
	blockAttachments = app.attach object, 'blockAttachments'
	cooldown = app.attach object, 'cooldown'

	damagable = app.attach object, 'damagable'
	damagable.filterGroup = filterGroup
	damagable.ownerId = ownerId

	if !!control
		shipControl.cooldown = cooldown
		shipControl.ship = ship
		if control is 'player2'
			shipControl.keyboard = ShipControl.Keyboard.Player2

	blockAttachments.blockModel = blockModel

	ship.rigidBody = rigidBody
	ship.blockAttachments = blockAttachments
	ship.blockModel = blockModel
	ship.damagable = damagable
	ship.damageExcludeMask = damageExcludeMask
	ship.ownerId = ownerId

	blockMesher.blockModel = blockModel

	if data?
		loader = new BlockLoader()
		loader.load app, object, data, center: true

	radius = chunkUtils.radius blockModel.chunk
	radius *= blockModel.gridSize

	# assume density of 1
	mass = chunkUtils.count blockModel.chunk
	rigidBody.body.mass = mass
	rigidBody.body.type = CANNON.Body.DYNAMIC
	rigidBody.body.addShape new CANNON.Sphere radius
	rigidBody.radius = radius
	rigidBody.body.linearDamping = 0.4
	rigidBody.body.collisionResponse = false
	rigidBody.body.collisionFilterGroup = CollisionGroups.Ship
	rigidBody.body.collisionFilterMask = CollisionGroups.Ammo | CollisionGroups.Ship

	return object