module.exports = (app) ->
	object = new THREE.Object3D()

	app.attach object, 'engine'

	return object