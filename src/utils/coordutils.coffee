module.exports = 
	mouseIntersect: (input, window, camera, objects) ->
		objects = objects || []
		inputState = input.state
		mouse = new THREE.Vector2(
			(inputState.mouseX / window.innerWidth) * 2 - 1, 
			- (inputState.mouseY / window.innerHeight) * 2 + 1
		)
		raycaster = new THREE.Raycaster()
		raycaster.setFromCamera mouse, camera

		intersects = raycaster.intersectObjects objects, true

		intersect = intersects[0]

		return intersect || null

	coordAbove: (intersect, camera, options) ->
		options = options || {}
		gridSize = options.gridSize || 1
		origin = options.origin || new THREE.Vector3 0, 0, 0

		point = intersect.point
		diff = point.clone().sub camera.position
		diff.setLength diff.length() - 0.01
		pointAbove = camera.position.clone().add diff

		coord = pointAbove.clone().multiplyScalar(1 / gridSize)
			.sub origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)

		coord

	coordBelow: (intersect, camera, options) ->
		options = options || {}
		gridSize = options.gridSize || 1
		origin = options.origin || new THREE.Vector3 0, 0, 0

		point = intersect.point
		diff = point.clone().sub camera.position
		diff.setLength diff.length() + 0.01
		pointAbove = camera.position.clone().add diff

		coord = pointAbove.clone().multiplyScalar(1 / gridSize)
			.sub origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)

		coord

	coordToPoint: (coord, options) ->
		options = options || {}
		gridSize = options.gridSize || 1
		origin = options.origin || new THREE.Vector3 0, 0, 0

		new THREE.Vector3 coord.x, coord.y, coord.z
			.add origin
			.multiplyScalar gridSize

	pointToCoord: (point, options) ->
		options = options || {}
		gridSize = options.gridSize || 1
		origin = options.origin || new THREE.Vector3 0, 0, 0

		coord = point.clone().multiplyScalar(1 / gridSize)
			.sub @origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)