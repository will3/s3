module.exports = (app) ->
	object = new THREE.Object3D()

	laser = app.attach object, 'laser'
	cooldown = app.attach object, 'cooldown'
	laser.cooldown = cooldown

	return object