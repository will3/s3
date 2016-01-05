_ = require 'lodash'
Events = require('../core/brock.coffee').Events
RigidBody = require '../components/rigidbody.coffee'

class Collision
	constructor: () ->
		@bodies = {}
		@hitTests = [require './hittests/spheretosphere.coffee']

	initialized: () =>
		@attachListener = (entity, c) =>
			if c instanceof RigidBody
				@addBody c

		@dettachListener = (entity, c) =>
			if c instanceof RigidBody
				@removeBody c

		@app.events.on 'attach', @attachListener
		@app.events.on 'dettach', @dettachListener

	dispose: () ->
		@app.events.removeListener 'attach', @attachListener
		@app.events.removeListener 'dettach', @dettachListener

	addBody: (body) ->
		group = body.group || 'default'
		map = @bodies[group]
		if !map?
			map = @bodies[group] = {}

		map[c._componentId] = c

	removeBody: (body) ->
		group = body.group || 'default'
		map = @bodies[group]
		if !map?
			return

		delete map[c._componentId]

	tick: () ->
		# clear resolved
		@resolved = {}

		@visitBodies (a) ->
			masks = a.masks || ['default']
			for mask in masks
				mapB = @bodies[mask] || {}
				for id, b in mapB
					@resolveCollision a, b
		# bodies = _.values @bodies

		# length = bodies.length
		# if length is 1
		# 	return

		# for i in [0...length]
		# 	for j in [(i + 1)...length]
		# 		a = bodies[i]
		# 		b = bodies[j]
		# 		@resolveCollision a, b		
				
		# return

	visitBodies: (callback) ->
		for group, map of @bodies
			for id, body of map
				callback body

	resolveCollision: (a, b) ->
		for hitTest in @hitTests
			if hitTest.shouldHitTest a, b
				result = hitTest.hitTest a, b
				if !!result
					a.events.emit 'collision', b, result
					b.events.emit 'collision', a, result
		
Collision.SphereToSphere = require './hittests/spheretosphere.coffee'

module.exports = Collision