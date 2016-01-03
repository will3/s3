THREE = require 'three'

class RigidBody
	constructor: () ->
		@mass = 1
		@velocity = new THREE.Vector3()
		@acceleration = new THREE.Vector3()
		@friction = 0.98

	tick: () ->
		@velocity.add @acceleration
		@velocity.multiplyScalar @friction
		@object.position.add @velocity

		@acceleration.set 0, 0, 0

	applyForce: (force) ->
		acc = force.clone().multiplyScalar 1 / @mass
		@acceleration.add acc

module.exports = RigidBody