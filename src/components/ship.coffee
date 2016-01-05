mathUtils = require '../utils/mathutils.coffee'
chunkUtils = require '../utils/chunkutils.coffee'

class Ship
	@$inject: ['app']

	constructor: (@app) ->
		@bankSpeed = 0.05
		@thrust = 0
		@rigidBody = null
		@blockModel = null
		@turnSpeed = 0.05
		@accelerateAmount = 0
		@bankAmount = 0
		@maxTurn = Math.PI / 3
		@blockAttachments = null

		@addListener = null
		@removeListener = null

		@engines = []
		@turrents = []

	start: () ->
		if @rigidBody is null
			throw new Error 'rigidBody cannot be empty'
		if @blockAttachments is null
			throw new Error 'blockAttachments cannot be empty'
		if @blockModel is null
			throw new Error 'blockModel cannot be empty'

		@addListener = (event) =>
			@updateAttachments()
		@removeListener = (event) =>
			@updateAttachments()

		@blockAttachments.events.on 'add', @addListener
		@blockAttachments.events.on 'remove', @removeListener

		@updateAttachments()

	updateRadius: () ->
		@rigidBody.radius = chunkUtils.radius(@blockModel.chunk) * @blockModel.gridSize

	dispose: () ->
		@blockAttachments.events.removeListener 'add', @addListener
		@blockAttachments.events.removeListener 'remove', @removeListener

	# updates ship stats with components
	updateAttachments: () ->
		thrust = 0
		turrents = []
		engines = []
		for attachment in @blockAttachments.attachments
			type = attachment.type
			object = attachment.object
			if type is 'engine'
				engine = @app.getComponent object, 'engine'
				thrust += engine.thrust
				engines.push engine

			if type is 'laser'
				laser = @app.getComponent object, 'laser'
				turrents.push laser
				
		@thrust = thrust
		@turrents = turrents
		@engines = engines

		return @

	tick: () ->
		turnRatio = (Math.sin @object.rotation.z)
		@object.rotation.y -=  turnRatio * @turnSpeed * @accelerateAmount

		# clamp bank and accelerate amount
		@bankAmount = mathUtils.clamp @bankAmount, -1, 1
		@accelerateAmount = mathUtils.clamp @accelerateAmount, 0, 1

		# update turn
		desiredZ = @bankAmount * @maxTurn;
		zDiff = desiredZ - @object.rotation.z
		desiredZSpeed = zDiff * 0.1
		@object.rotation.z += desiredZSpeed

		# update thrust
		force = new THREE.Vector3 0, 0, 1
		force.applyEuler @object.rotation
		force.multiplyScalar @thrust * @accelerateAmount
		@rigidBody.applyForce force

		# update engine visual
		@engines.forEach (engine) =>
			engine.amount = @accelerateAmount

	bank: (amount) ->
		@bankAmount += amount

	accelerate: (amount) ->
		@accelerateAmount += amount

	lateTick: () ->
		@accelerateAmount = 0
		@bankAmount = 0

	fireNext: () ->
		for turrent in @turrents
			if turrent.cooldown.ready 'fire'
				turrent.fire()
				return

module.exports = Ship