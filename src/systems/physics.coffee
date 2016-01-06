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
			rigidBodyi = @bodies[contact.bi.id]
			rigidBodyj = @bodies[contact.bj.id]
			if rigidBodyi? and rigidBodyj?
				rigidBodyi.events.emit 'collision', rigidBodyj
				rigidBodyj.events.emit 'collision', rigidBodyi

module.exports = Physics