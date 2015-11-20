THREE = require 'three'

scene = null
camera = null
renderer = null

initRenderer = () ->
	renderer = new THREE.WebGLRenderer antialias: true
	renderer.setSize window.innerWidth, window.innerHeight
	document.body.appendChild renderer.domElement
	renderer.setClearColor 0xffffff

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

	directionalLight = new THREE.DirectionalLight 0xffffff, 0.3
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
	app.use('input', input)
	app.component 'blockModel', require './components/blockmodel.coffee'
	app.component 'cameraController', ['input', require './components/cameracontroller.coffee']

	object = new THREE.Object3D
	scene.add object
	blockModel = app.attach object, 'blockModel'
	blockModel.set 0, 0, 0, 0x333333
	blockModel.set 1, 0, 0, 0x333333
	blockModel.set 2, 0, 0, 0x333333
	blockModel.set 3, 0, 0, 0x333333
	blockModel.set 4, 0, 0, 0x333333
	blockModel.set 5, 0, 0, 0x333333
	blockModel.set 6, 0, 0, 0x333333

	app.attach camera, 'cameraController'
	return

initRenderer()
animate()
initApp()