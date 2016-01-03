THREE = require 'three'
directionUtils = require '../utils/directionutils.coffee'

class Engine
	@$inject: ['app', 'scene', 'particleGroups']

	constructor: (@app, @scene, @particleGroups) ->
		@direction = 'back'
		@gap = 1
		@emitter = null
		@particleGroup = null
		@amount = 0
		@size = 1.8
		@thrust = 0.005

	start: () ->
		# create particle group
		@particleGroup = @particleGroups.get 'engine'
		if @particleGroup is undefined
			@particleGroup = new SPE.Group
				texture:
					value: THREE.ImageUtils.loadTexture '/images/default.png'
				maxParticleCount: 10000
			@particleGroups.add 'engine', @particleGroup

		# add an emitter
		@emitter = new SPE.Emitter(@getEmitterOptions())

		@particleGroup.addEmitter @emitter
		@scene.add @particleGroup.mesh
		return

	tick: () ->
		@emitter.position.value = @getPosition()
		@emitter.velocity.value = @getVelocity()
		# @emitter.size.value = [@size * @amount, 0]
		# if @amount == 0
		# 	@emitter.disable()
		# else
		# 	@emitter.enable()

	getEmitterOptions: () ->
  	options =
			maxAge:
			  value:	0.15
			  spread: 0.5
			position:
			  value:	@getPosition()
			velocity:
			  value:	@getVelocity()
			size:
			  value:	[@size, 0]
			opacity:
				value: 	0.3
			particleCount:	100

	getPosition: () ->
		gap = @getVelocity().setLength @gap
		@object.getWorldPosition().add gap

	getVelocity: () ->
		localQuat = directionUtils.getQuat @direction
		quat = @object.getWorldQuaternion().multiply localQuat
		velocity = directionUtils.quatToVector(quat).setLength 4

	dispose: () ->
		@emitter.disable()	

module.exports = Engine