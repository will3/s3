THREE = require 'three'

module.exports = (objects, groundY, input, camera) ->
	geometry = new THREE.PlaneGeometry(999, 999)
	geometry.vertices.forEach (v) ->
		v.applyEuler new THREE.Euler -Math.PI / 2, 0, 0
		v.y = groundY
	ground = new THREE.Mesh geometry

	inputState = input.state
	mouse = new THREE.Vector2(
		(inputState.mouseX / @window.innerWidth) * 2 - 1, 
		- (inputState.mouseY / @window.innerHeight) * 2 + 1
	)
	raycaster = new THREE.Raycaster()
	raycaster.setFromCamera mouse, camera

	intersects = raycaster.intersectObjects objects, true

	if intersects.length == 0
		intersects = raycaster.intersectObject ground

	geometry.dispose()

	return intersects[0]