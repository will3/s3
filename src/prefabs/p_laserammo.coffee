THREE = require 'three'
CollisionGroups = require '../collisiongroups.coffee'

module.exports = (app, options = {}) ->
	excludeMask = options.excludeMask || null
	ownerId = options.ownerId || null
	dir = options.dir || new THREE.Vector3 1, 0, 0	

	object = new THREE.Object3D()

	laserAmmo = app.attach object, 'laserAmmo'
	
	rigidBody = app.attach object, 'rigidBody'
	rigidBody.friction = 1
	rigidBody.radius = 1

	selfDestruct = app.attach object, 'selfDestruct'
	selfDestruct.life = 2000

	damage = app.attach object, 'damage'
	damage.excludeMask = excludeMask
	damage.ownerId = ownerId

	laserAmmo.rigidBody = rigidBody
	laserAmmo.dir = dir
	laserAmmo.damage = damage

	# configure rigid body
	radius = 1
	rigidBody.mass = 1
	rigidBody.radius = radius
	rigidBody.group = CollisionGroups.Ammo

	rigidBody.body.type = CANNON.Body.DYNAMIC
	rigidBody.body.addShape new CANNON.Sphere radius
	rigidBody.body.linearDamping = 0.15
	rigidBody.body.collisionResponse = false
	rigidBody.body.collisionFilterGroup = CollisionGroups.Ammo
	rigidBody.body.collisionFilterMask = CollisionGroups.Ship | CollisionGroups.Structure

	return object