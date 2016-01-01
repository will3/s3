THREE = require 'three'
module.exports = (app) ->
	object = new THREE.Object3D()
	objGrid = new THREE.Object3D()
	objPreview = new THREE.Object3D()

	editor = app.attach object, 'editor'
	grid = app.attach objGrid, 'grid'
	preview = app.attach objPreview, 'blockPreview'

	object.add objGrid
	object.add objPreview

	editor.grid = grid
	editor.blockPreview = preview

	object