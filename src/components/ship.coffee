mathUtils = require '../utils/mathutils.coffee'

class Ship
	@$inject: ['app']

	constructor: (@app) ->
		@bankSpeed = 0.05
		@thrust = 0
		@rigidBody = null
		@turnSpeed = 0.05
		@accelerateAmount = 0
		@bankAmount = 0
		@maxTurn = Math.PI / 3
		@blockAttachments = null

		@addListener = null
		@removeListener = null

	start: () ->
		if @rigidBody is null
			throw new Error 'rigidBody cannot be empty'
		if @blockAttachments is null
			throw new Error 'blockAttachments cannot be empty'

		@addListener = (event) =>
			@updateAttachments()
		@removeListener = (event) =>
			@updateAttachments()

		@blockAttachments.events.on 'add', @addListener
		@blockAttachments.events.on 'remove', @removeListener

		@updateAttachments()

	dispose: () ->
		@blockAttachments.events.removeListener 'add', @addListener
		@blockAttachments.events.removeListener 'remove', @removeListener

	# updates ship stats with components
	updateAttachments: () ->
		thrust = 0
		for attachment in @blockAttachments.attachments
			type = attachment.type
			object = attachment.object
			if type is 'engine'
				engine = @app.getComponent object, 'engine'
				thrust += engine.thrust
				
		@thrust = thrust
		return @

	tick: () ->
		turnRatio = (Math.sin @object.rotation.z)
		@object.rotation.y -=  turnRatio * @turnSpeed * @accelerateAmount

		@bankAmount = mathUtils.clamp @bankAmount, -1, 1
		@accelerateAmount = mathUtils.clamp @accelerateAmount, 0, 1

		desiredZ = @bankAmount * @maxTurn;
		zDiff = desiredZ - @object.rotation.z
		desiredZSpeed = zDiff * 0.1
		@object.rotation.z += desiredZSpeed

		force = new THREE.Vector3 0, 0, 1
		force.applyEuler @object.rotation
		force.multiplyScalar @thrust * @accelerateAmount

		@rigidBody.applyForce force

	bank: (amount) ->
		@bankAmount += amount

	accelerate: (amount) ->
		@accelerateAmount += amount

	lateTick: () ->
		@accelerateAmount = 0
		@bankAmount = 0

module.exports = Ship