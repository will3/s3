THREE = require 'three'

module.exports = (app) ->
	object = new THREE.Object3D()

	laserAmmo = app.attach object, 'laserAmmo'
	
	rigidBody = app.attach object, 'rigidBody'
	rigidBody.friction = 1
	rigidBody.radius = 1

	selfDestruct = app.attach object, 'selfDestruct'
	selfDestruct.life = 1000

	laserAmmo.rigidBody = rigidBody

	return object