THREE = require 'three'

scene = null
camera = null
renderer = null
app = null

document.oncontextmenu = (e) ->
	e.preventDefault()

initRenderer = () ->
	renderer = new THREE.WebGLRenderer antialias: true
	renderer.setSize window.innerWidth, window.innerHeight
	document.body.appendChild renderer.domElement
	renderer.setClearColor 0x111111

	camera = new THREE.PerspectiveCamera(
		75,
		window.innerWidth / window.innerHeight
		0.1,
		1000
	);
	camera.position.z = 50
	scene = new THREE.Scene

	window.addEventListener('resize', () ->
		renderer.setSize(window.innerWidth, window.innerHeight)
		camera.aspect = window.innerWidth / window.innerHeight
		camera.updateProjectionMatrix()
	)

	ambientLight = new THREE.AmbientLight 0xcccccc
	scene.add ambientLight

	directionalLight = new THREE.DirectionalLight 0xffffff, 0.4
	directionalLight.position.set 0.5, 1.0, 0.3
	scene.add directionalLight
		
	return

animate = () ->
	requestAnimationFrame(animate)
	renderer.render scene, camera

initApp = () ->
	brock = require './core/index'
	app = brock()

	input = brock.input(window)

	app.use 'input', input
	app.value 'camera', camera
	app.value 'window', window
	app.value 'scene', scene
	app.value 'app', app

	require('./register.coffee')(app);
	require('./setupgui.coffee')(app, scene);

	return

initScenario = () ->
	app.attach camera, 'cameraController'

	root = new THREE.Object3D
	scene.add root
	game = app.attach root, 'game'
	app.value 'game', game

	return

initRenderer()
animate()
initApp()
initScenario()