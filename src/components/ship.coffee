mathUtils = require '../utils/mathutils.coffee'
chunkUtils = require '../utils/chunkutils.coffee'
coordUtils = require '../utils/coordutils.coffee'
damageUtils = require '../utils/damageutils.coffee'
hitTests = require '../utils/hittests.coffee'

class Ship
	@$inject: ['app']

	constructor: (@app) ->
		@bankSpeed = 0.05
		@thrust = 0
		
		@engineModifier = 1

		@rigidBody = null
		@blockModel = null
		@turnSpeed = 0.05
		@accelerateAmount = 0
		@bankAmount = 0
		@maxTurn = Math.PI / 3
		@blockAttachments = null
		@damagable = null

		@addListener = null
		@removeListener = null

		@engines = []
		@turrents = []

		@onCollision = null

		@damageExcludeMask = []

		@ownerId = null
		@nextTurrentIndex = 0

	start: () ->
		if @rigidBody is null
			throw new Error 'rigidBody cannot be empty'
		if @blockAttachments is null
			throw new Error 'blockAttachments cannot be empty'
		if @blockModel is null
			throw new Error 'blockModel cannot be empty'
		if @damagable is null
			throw new Error 'damagable cannot be empty'

		@addListener = (event) =>
			@updateAttachments()
		@removeListener = (event) =>
			@updateAttachments()

		@blockAttachments.events.on 'add', @addListener
		@blockAttachments.events.on 'remove', @removeListener

		@updateAttachments()

		@rigidBody.events.on 'collision', @onCollision = (b) =>
			damage = @app.getComponent b.object, 'damage'
			if damage?
				if @damagable.by damage
					point = b.object.position.clone()
					localPoint = @object.worldToLocal point
					coord = coordUtils.pointToCoord localPoint, @blockModel

					if hitTests.blockAndSphere @blockModel, coord, b.radius
						damageUtils.applyDamage @app, @object, coord, damage
						@app.destroy b.object

	dispose: () ->
		@blockAttachments.events.removeListener 'add', @addListener
		@blockAttachments.events.removeListener 'remove', @removeListener
		@rigidBody.events.removeListener 'rigidBody', @onCollision

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
				laser.damageExcludeMask = @damageExcludeMask
				laser.ownerId = @ownerId
				turrents.push laser
				
		@thrust = thrust
		@turrents = turrents
		@engines = engines

		return @

	tick: () ->
		# clamp bank and accelerate amount
		@bankAmount = mathUtils.clamp @bankAmount, -1, 1
		@accelerateAmount = mathUtils.clamp @accelerateAmount, 0, 1

		rotation = @object.rotation

		# update roll
		desiredZ = @bankAmount * @maxTurn;
		zDiff = desiredZ - rotation.z
		desiredZSpeed = zDiff * 0.1
		rotation.z += desiredZSpeed
		rotation.z = mathUtils.clamp rotation.z, -@maxTurn, @maxTurn

		# update yaw
		turnRatio = (Math.sin @object.rotation.z)
		rotation.y -= turnRatio * @turnSpeed * @accelerateAmount

		@rigidBody.setRotation rotation

		# update thrust
		forceMag = @thrust * @accelerateAmount * @engineModifier
		if forceMag > 0
			force = new THREE.Vector3 0, 0, 1
			force.applyEuler @object.rotation
			force.multiplyScalar forceMag
			@rigidBody.applyForce force

		# update engine visual
		@engines.forEach (engine) =>
			engine.amount = @accelerateAmount * @engineModifier

	bank: (amount) ->
		@bankAmount += amount

	accelerate: (amount) ->
		@accelerateAmount += amount

	lateTick: () ->
		@accelerateAmount = 0
		@bankAmount = 0

	fireNext: () ->
		return if @turrents.length is 0
		turrent = @turrents[@nextTurrentIndex]
		if not turrent?
			turrent = @turrents[0]

		if turrent.cooldown.ready 'fire'
			turrent.fire()
			@nextTurrentIndex++
			if @nextTurrentIndex is @turrents.length
				@nextTurrentIndex = 0

module.exports = Ship