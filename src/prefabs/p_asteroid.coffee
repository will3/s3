module.exports = (app) ->
	object = new THREE.Object3D()
	blockModel = app.attach object, 'blockModel'
	app.attach object, 'asteroid'
	blockMesher = app.attach object, 'blockMesher'
	blockMesher.blockModel = blockModel
	return object