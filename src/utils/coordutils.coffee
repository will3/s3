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

	coordAbove: (point, from, blockModel) ->
		gridSize = blockModel.gridSize
		origin = blockModel.origin

		diff = point.clone().sub from.position
		diff.setLength diff.length() - 0.01
		pointAbove = from.position.clone().add diff

		coord = pointAbove.clone().multiplyScalar(1 / gridSize)
			.sub origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)

		coord

	coordBelow: (point, from, blockModel) ->
		gridSize = blockModel.gridSize
		origin = blockModel.origin

		diff = point.clone().sub from.position
		diff.setLength diff.length() + 0.01
		pointAbove = from.position.clone().add diff

		coord = pointAbove.clone().multiplyScalar(1 / gridSize)
			.sub origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)

		coord

	coordToPoint: (coord, blockModel) ->
		gridSize = blockModel.gridSize
		origin = blockModel.origin

		new THREE.Vector3 coord.x, coord.y, coord.z
			.add origin
			.multiplyScalar gridSize

	pointToCoord: (point, blockModel) ->
		gridSize = blockModel.gridSize
		origin = blockModel.origin

		coord = point.clone().multiplyScalar(1 / gridSize)
			.sub origin

		coord = new THREE.Vector3(
			Math.round coord.x
			Math.round coord.y
			Math.round coord.z
		)