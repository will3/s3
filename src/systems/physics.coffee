_ = require 'lodash'
Events = require('../core/brock.coffee').Events
RigidBody = require '../components/rigidbody.coffee'
CANNON = require 'cannon'

class Physics
	constructor: () ->
		@world = new CANNON.World()
		@fixedTimeStep = 1.0 / 60.0
		@maxSubSteps = 3

		# CANNON.Body id to rigidBody mapping
		@bodies = {}

	tick: (dt) ->
		@world.step @fixedTimeStep, dt, @maxSubSteps

		for contact in @world.contacts
			a = @bodies[contact.bi.id]
			b = @bodies[contact.bj.id]
			if a? and b?
				@onContact a, b

	onContact: (a, b) ->
		a.events.emit 'collision', b
		b.events.emit 'collision', a	

module.exports = Physics