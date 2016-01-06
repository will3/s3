THREE = require 'three'

class CameraController
	constructor: (@input, @keyMap) ->
		@lastX = 0
		@lastY = 0
		@rotateSpeed = 0.01
		@target = new THREE.Vector3()
		@rotation = new THREE.Euler Math.PI / 3, Math.PI / 4, 0
		@rotation.order = 'YXZ'
		@distance = 100
		@drag = false
		@maxPitch = Math.PI / 2 - 0.01
		@minPitch = -Math.PI / 2 + 0.01
		@zoomRate = 1.1
		@cameraSpeed = 1
		return

	start: () ->
		@camera = this.object
		if @camera is undefined
			throw new Error "camera is empty"
		return

	tick: () ->
		@updateMouse()
		@updateZoom()
		@updateKeys()
		@updateCamera()

	updateMouse: () ->
		inputState = @input.state

		if inputState.mouseDown @keyMap.mouseDrag
			@drag = true

		if inputState.mouseUp @keyMap.mouseDrag or inputState.mouseEnter or inputState.mouseLeave
			@drag = false

		if @drag
			diffX = inputState.mouseX - @lastX
			diffY = inputState.mouseY - @lastY
			@rotation.x -= diffY * @rotateSpeed
			@rotation.y += diffX * @rotateSpeed
			@rotation.x = @maxPitch if @rotation.x > @maxPitch
			@rotation.x = @minPitch if @rotation.x < @minPitch

		@lastX = inputState.mouseX
		@lastY = inputState.mouseY

	updateKeys: () ->
		inputState = @input.state

		rightAmount = 0
		upAmount = 0
		if inputState.keyHold @keyMap['camera-right']
			rightAmount++
		if inputState.keyHold @keyMap['camera-left']
			rightAmount--
		if inputState.keyHold @keyMap['camera-up']
			upAmount++
		if inputState.keyHold @keyMap['camera-down']
			upAmount--

		up = new THREE.Vector3(0, 0, 1).applyEuler @rotation
		up.y = 0
		up.normalize()

		right = up.clone().applyEuler new THREE.Euler 0, -Math.PI / 2, 0

		d = up.clone().multiplyScalar(@cameraSpeed * upAmount).add(
			right.clone().multiplyScalar(@cameraSpeed * rightAmount))

		@target.add d
		return

	updateZoom: () ->
		inputState = @input.state
		if inputState.keyDown @keyMap.zoomIn
			@distance /= @zoomRate
		if inputState.keyDown @keyMap.zoomOut
			@distance *= @zoomRate
			
	updateCamera: () ->
		unit = new THREE.Vector3 0, 0, 1 
			.applyEuler @rotation
			.multiplyScalar @distance

		@camera.position.copy @target.clone().sub unit
		@camera.lookAt @target

		return


module.exports = CameraController