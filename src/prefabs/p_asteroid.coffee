module.exports = (app) ->
	object = new THREE.Object3D()
	blockModel = app.attach object, 'blockModel'
	blockModel.gridSize = 2
	app.attach object, 'asteroid'
	blockMesher = app.attach object, 'blockMesher'
	blockMesher.blockModel = blockModel
	return object