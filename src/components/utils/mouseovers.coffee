THREE = require 'three'

module.exports = (objects, ground, input, camera) ->
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

	return intersects[0]