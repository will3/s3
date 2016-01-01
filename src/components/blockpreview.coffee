class BlockPreview
	constructor: () ->
		@arrow = null
		@wireframe = null
		@direction = new THREE.Euler 0, 0, 0, 'YXZ'
		@arrowNeedsUpdate = false

	start: () ->
		@updateArrow()

		geometry = new THREE.BoxGeometry 1, 1, 1
		box = new THREE.Mesh geometry
		edges = new THREE.EdgesHelper box, @color
		@wireframe = new THREE.Object3D()
		@wireframe.add edges
		@object.add @wireframe
		geometry.dispose()

		return

	tick: () ->
		if @arrowNeedsUpdate
			@updateArrow()
			@arrowNeedsUpdate = false

	updateArrow: () ->
		@disposeArrow()
		dir = new THREE.Vector3 0, 0, -1
		dir.applyEuler @direction
		origin = new THREE.Vector3 0, 0, 0
		length = 3
		hex = 0xff0000
		@arrow = new THREE.ArrowHelper dir, origin, length, hex, 1, 0.5
		@object.add @arrow

	disposeArrow: () ->
		return if @arrow is null
		@object.remove @arrow

module.exports = BlockPreview