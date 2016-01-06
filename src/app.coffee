THREE = require 'three'
$ = require 'jquery'

app = null
editor = null
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(
	75,
	window.innerWidth / window.innerHeight
	0.1,
	1000
)

document.oncontextmenu = (e) ->
	e.preventDefault()

initApp = () ->
	brock = require './core/index'
	app = brock()

	app.value 'camera', camera
	app.value 'scene', scene
	app.value 'window', window
	app.value 'app', app

	container = $('#container')[0]
	input = brock.input container
	app.use 'input', input
	

	require('./register.coffee')(app)

	root = new THREE.Object3D
	scene.add root

	# objEditor = app.addPrefab scene, 'editor'
	# editor = app.getComponent objEditor, 'editor'

	# objShip = app.addPrefab scene, 'ship',
	# 	control: 'player1',
	# 	data: require './data/ship1.json'

	# blockModel = app.getComponent objShip, 'blockModel'
	# blockAttachments = app.getComponent objShip, 'blockAttachments'
	# editor.blockModel = blockModel
	# editor.blockAttachments = blockAttachments

	app.addPrefab scene, 'asteroid'

	ship1 = app.addPrefab scene, 'ship',
		control: 'player1'
		data: require './data/ship0.json'
	ship1.position.set -50, 0, 0

	ship2 = app.addPrefab scene, 'ship', 
		data: require './data/ship1.json'
	ship2.position.set 50, 0, 0

	# app.addPrefab scene, 'laserAmmo'

	# obj = new THREE.Object3D()
	# scene.add obj
	# lineSprite = app.attach obj, 'lineSprite'
	# lineSprite.texture = require('./textures.coffee').get 'laser'

	cameraController = app.attach camera, 'cameraController'

	$('#container').focus()

	cpr
		palette: [
			'rgb(249, 246, 51)', 
			'rgb(110, 236, 167)', 
			'rgb(39, 151, 251)',
			'rgb(237, 72, 81)',
			'rgb(242, 137, 66)',
			'#f6f6f6'
		],
		click: (color) ->
			rgbString = color.toRgbString()
			threeColor = new THREE.Color rgbString
			hex = threeColor.getHex()
			editor.color = hex
		focus: () ->
			#got focus 
		blur: () ->
			#lost focus 

	addMenu = require './addmenu.coffee'
	addMenu editor

	return

initApp()
initRenderer = require './initrenderer.coffee'
initRenderer(app, scene, camera)