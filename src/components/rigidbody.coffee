THREE = require 'three'
Events = require('../core/brock.coffee').Events
CANNON = require 'cannon'

class RigidBody
	@$inject: ['physics']

	constructor: (@physics) ->
		@body = new CANNON.Body()
		@events = new Events()
		@radius = 0

	start: () ->
		@copyPosition()
		@physics.world.addBody @body
		@physics.bodies[@body.id] = @

	dispose: () ->
		@physics.world.removeBody @body
		delete @physics.bodies[@body.id]

	applyForce: (force) ->
		worldPoint = @object.getWorldPosition()
		@body.applyForce force, new CANNON.Vec3().copy worldPoint

	setRotation: (rotation) ->
		@body.quaternion.setFromEuler rotation.x, rotation.y, rotation.z, rotation.order

	setVelocity: (velocity) ->
		@body.velocity = new CANNON.Vec3().copy velocity

	getVelocity: () ->
		return new THREE.Vector3().copy @body.velocity

	copyPosition: () ->
		@body.position.copy @object.position

	tick: () ->
		@object.position.copy @body.position
		@object.quaternion.copy @body.quaternion

module.exports = RigidBody