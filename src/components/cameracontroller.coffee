THREE = require 'three'

class CameraController
	constructor: (@input) ->
		@lastX = 0
		@lastY = 0
		@rotateSpeed = 0.01
		@target = new THREE.Vector3()
		@rotation = new THREE.Euler()
		@rotation.order = 'YXZ'
		@distance = 50
		@drag = false
		@maxPitch = Math.PI / 2 - 0.01
		@minPitch = -Math.PI / 2 + 0.01
		return

	start: () ->
		@camera = this.object
		if @camera is undefined
			throw new Error "camera is empty"
		return

	tick: () ->
		inputState = @input.state

		if inputState.mouseDown 0
			@drag = true

		if inputState.mouseUp 0 or inputState.mouseEnter or inputState.mouseLeave
			@drag = false

		if @drag
			diffX = inputState.mouseX - @lastX
			diffY = inputState.mouseY - @lastY
			@rotation.x += diffY * @rotateSpeed
			@rotation.y += diffX * @rotateSpeed
			@rotation.x = @maxPitch if @rotation.x > @maxPitch
			@rotation.x = @minPitch if @rotation.x < @minPitch

		@lastX = inputState.mouseX
		@lastY = inputState.mouseY

		@updateCamera()

		return

	updateCamera: () ->
		unit = new THREE.Vector3 0, 0, 1 
			.applyEuler @rotation
			.multiplyScalar @distance

		@camera.position.copy @target.clone().sub unit
		@camera.lookAt @target

		return


module.exports = CameraController