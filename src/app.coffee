THREE = require 'three'
$ = require 'jquery'

scene = null
camera = null
renderer = null
app = null
depthMaterial = null
composer = null
depthTarget = null
editor = null

document.oncontextmenu = (e) ->
	e.preventDefault()

initRenderer = () ->
	renderer = new THREE.WebGLRenderer antialias: true
	renderer.setSize window.innerWidth, window.innerHeight
	$('#container').append renderer.domElement
	renderer.setClearColor 0x111111

	camera = new THREE.PerspectiveCamera(
		75,
		window.innerWidth / window.innerHeight
		0.1,
		1000
	);

	# width = window.innerWidth * 0.1
	# height = window.innerHeight * 0.1
	# camera = new THREE.OrthographicCamera( 
	# 	width / - 2, 
	# 	width / 2, 
	# 	height / 2, 
	# 	height / - 2, 
	# 	1, 
	# 	1000 
	# )

	scene = new THREE.Scene

	window.addEventListener('resize', () ->
		width = window.innerWidth
		height = window.innerHeight
		renderer.setSize(width, window.height)
		camera.aspect = width / height
		camera.updateProjectionMatrix()

		ssaoPass.uniforms['size'].value.set width, height

		pixelRatio = renderer.getPixelRatio()
		newWidth  = Math.floor( width / pixelRatio ) || 1
		newHeight = Math.floor( height / pixelRatio ) || 1
		depthTarget.setSize newWidth, newHeight
		composer.setSize newWidth, newHeight 
	)

	ambientLight = new THREE.AmbientLight 0xcccccc
	scene.add ambientLight

	directionalLight = new THREE.DirectionalLight 0xffffff, 0.4
	directionalLight.position.set 0.5, 1.0, 0.3
	scene.add directionalLight
		
	return

initPostprocessing = () ->
	depthShader = THREE.ShaderLib['depthRGBA']
	depthUniforms = THREE.UniformsUtils.clone depthShader.uniforms
	depthMaterial = new THREE.ShaderMaterial
		fragmentShader: depthShader.fragmentShader
		vertexShader: depthShader.vertexShader
		uniforms: depthUniforms
		blending: THREE.NoBlending

	pars = {
		minFilter: THREE.NearestFilter
		magFilter: THREE.NearestFilter
		format: THREE.RGBAFormat
	}

	depthTarget = new THREE.WebGLRenderTarget window.innerWidth, window.innerHeight, pars

	renderPass = new THREE.RenderPass scene, camera

	ssaoPass = new THREE.ShaderPass THREE.SSAOShader
	ssaoPass.renderToScreen = true
	ssaoPass.uniforms[ 'tDepth' ].value = depthTarget
	ssaoPass.uniforms[ 'size' ].value.set window.innerWidth, window.innerHeight
	ssaoPass.uniforms[ 'cameraNear' ].value = camera.near
	ssaoPass.uniforms[ 'cameraFar' ].value = camera.far
	ssaoPass.uniforms[ 'aoClamp' ].value = 0.5
	ssaoPass.uniforms[ 'lumInfluence' ].value = 0.5
	ssaoPass.uniforms[ 'aoAmount' ].value = 1.0
	
	composer = new THREE.EffectComposer renderer
	composer.addPass renderPass
	composer.addPass ssaoPass
	return

animate = () ->
	requestAnimationFrame(animate)
	render()

render = () ->
	scene.overrideMaterial = depthMaterial
	renderer.render scene, camera, depthTarget

	scene.overrideMaterial = null
	composer.render()

initApp = () ->
	brock = require './core/index'
	app = brock()

	container = $('#container')[0]
	input = brock.input container

	app.use 'input', input
	app.value 'camera', camera
	app.value 'window', window
	app.value 'scene', scene
	app.value 'app', app

	require('./register.coffee')(app)

	root = new THREE.Object3D
	scene.add root

	objEditor = app.addPrefab scene, 'editor'
	editor = app.getComponent objEditor, 'editor'

	objShip = app.addPrefab scene, 'ship'
	blockModel = app.getComponent objShip, 'blockModel'
	blockAttachments = app.getComponent objShip, 'blockAttachments'
	editor.blockModel = blockModel
	editor.blockAttachments = blockAttachments


	# app.addPrefab scene, 'asteroid'

	# app.addPrefab scene, 'laserAmmo'

	app.attach camera, 'cameraController'

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

initRenderer()
initPostprocessing()
animate()
initApp()