_ = require 'lodash'
THREE = require 'three'

class MouseOvers
	@$inject: ['input', 'window', 'camera']

	constructor: (@input, @window, @camera) ->
		@intersects = []
		# @ground = null
		# @groundY = 0

	# start: () ->
	# 	geometry = new THREE.PlaneGeometry(999, 999)
	# 	geometry.vertices.forEach (v) =>
	# 		v.applyEuler new THREE.Euler -Math.PI / 2, 0, 0
	# 		v.y = @groundY
	# 	@ground = new THREE.Mesh geometry

	intersectObject: (object) ->
		@intersectObjects [object]
		
	intersectObjects: (objects) ->
		inputState = @input.state
		mouse = new THREE.Vector2(
			(inputState.mouseX / @window.innerWidth) * 2 - 1, 
			- (inputState.mouseY / @window.innerHeight) * 2 + 1
		)
		raycaster = new THREE.Raycaster()
		raycaster.setFromCamera mouse, @camera

		@intersects = raycaster.intersectObjects objects, true

	# tick: () ->
		# if @collidables.length == 0
		# 	@intersects = []
		# 	return

module.exports = MouseOvers