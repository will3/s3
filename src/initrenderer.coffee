Stats = require 'stats.js'

module.exports = (app, scene, camera) ->
	renderer = null
	depthMaterial = null
	composer = null
	depthTarget = null
	ssaoPass = null
	rendererStats = null
	stats = null

	initRenderer = () ->
		renderer = new THREE.WebGLRenderer antialias: true
		renderer.setSize window.innerWidth, window.innerHeight
		$('#container').append renderer.domElement
		renderer.setClearColor 0x111111

		window.addEventListener('resize', () ->
			width = window.innerWidth
			height = window.innerHeight
			renderer.setSize(width, height)
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

		rendererStats = new THREEx.RendererStats()
		rendererStats.domElement.style.position = 'absolute'
		rendererStats.domElement.style.left = '20px'
		rendererStats.domElement.style.top   = '20px'
		document.body.appendChild rendererStats.domElement
			
		stats = new Stats()
		stats.domElement.style.position = 'absolute'
		stats.domElement.style.left = '110px'
		stats.domElement.style.top = '20px'
		document.body.appendChild stats.domElement

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

		renderTargetParameters = 
			minFilter: THREE.LinearFilter,
			magFilter: THREE.LinearFilter,
			format: THREE.RGBFormat,
			stencilBuffer: false

		depthTarget = new THREE.WebGLRenderTarget window.innerWidth, window.innerHeight, pars

		# render pass
		renderPass = new THREE.RenderPass scene, camera

		# ssao pass
		ssaoPass = new THREE.ShaderPass THREE.SSAOShader
		# ssaoPass.renderToScreen = true
		ssaoPass.uniforms[ 'tDepth' ].value = depthTarget
		ssaoPass.uniforms[ 'size' ].value.set window.innerWidth, window.innerHeight
		ssaoPass.uniforms[ 'cameraNear' ].value = camera.near
		ssaoPass.uniforms[ 'cameraFar' ].value = camera.far
		ssaoPass.uniforms[ 'aoClamp' ].value = 0.5
		ssaoPass.uniforms[ 'lumInfluence' ].value = 0.5
		ssaoPass.uniforms[ 'aoAmount' ].value = 1.0

		# save pass
		savePass = new THREE.SavePass new THREE.WebGLRenderTarget window.innerWidth, window.innerHeight, renderTargetParameters
		
		# bloom pass
		# bloomPass = new THREE.BloomPass 1, 15, 2, 512

		#blur
		horizBlurPass = new THREE.ShaderPass THREE.HorizontalBlurShader
		vertiBlurPass = new THREE.ShaderPass THREE.VerticalBlurShader
		horizBlurPass.uniforms[ "h" ].value = 2 / window.innerWidth;
		vertiBlurPass.uniforms[ "v" ].value = 2 / window.innerHeight;

		# blend pass
		effectBlend = new THREE.ShaderPass THREE.BlendShader, 'tDiffuse1'
		effectBlend.uniforms[ 'tDiffuse2'].value = savePass.renderTarget

		# copy to screen
		copyPass = new THREE.ShaderPass THREE.CopyShader
		copyPass.renderToScreen = true

		composer = new THREE.EffectComposer renderer
		composer.addPass renderPass
		composer.addPass ssaoPass
		# composer.addPass savePass
		# # composer.addPass bloomPass
		# composer.addPass horizBlurPass
		# composer.addPass vertiBlurPass
		# composer.addPass effectBlend
		composer.addPass copyPass

		return

	animate = () ->
		requestAnimationFrame(animate)
		stats.begin()
		render()
		stats.end()

	render = () ->
		# render depthTarget for ssao pass
		scene.overrideMaterial = depthMaterial
		renderer.render scene, camera, depthTarget

		# render scene
		scene.overrideMaterial = null
		composer.render()

		rendererStats.update(renderer)

	initRenderer()
	initPostprocessing()
	animate()