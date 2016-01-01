THREE = require 'three'
_ = require 'lodash'

class Game
	@$inject: ['scene', 'app', 'input', 'keyMap', 'mouseovers', 'events', 'camera']

	constructor: (@scene, @app, @input, @keyMap, @mouseovers, @events, @camera) ->
		@editMode = false
		@blockType = 'default'	#selected block type
		@attachListener = null
		@dettachListener = null
		@selectables = []
		@selection = null
		@shipControl = null
		@editor = null

	start: () ->
		# @scene.add prefab_asteroid(@app)
		
		obj = @app.addPrefab @scene, 'editor'
		@editor = @app.getComponent obj, 'editor'

		# root = new THREE.Object3D()
		# @scene.add root
		# @app.attach root, 'editor'
		# @shipControl = @app.attach root, 'shipControl'

		@app.attach @camera, 'cameraController'
		
		return

	colorSelected: (color) ->
		rgbString = color.toRgbString()
		threeColor = new THREE.Color rgbString
		hex = threeColor.getHex()
		@editor.color = hex

module.exports = Game