module.exports = (app) ->
	object = new THREE.Object3D()

	laser = app.attach object, 'laser'

	return object