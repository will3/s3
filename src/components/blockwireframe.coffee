class BlockWireframe
	constructor: () ->
		@wireframe = null
		@size = 1
		@color = 0xdddddd
		@meshNeedsUpdate = false

	start: () ->
		@updateMesh()
		return

	tick: () ->
		if @meshNeedsUpdate
			@updateMesh()
			@meshNeedsUpdate = false
		return

	updateMesh: () ->
		if @wireframe?
			@wireframe.geometry.dispose()
			@wireframe.material.dispose()

		geometry = new THREE.BoxGeometry @size, @size, @size
		box = new THREE.Mesh geometry
		@wireframe = new THREE.EdgesHelper box, @color
		@object.add @wireframe
		geometry.dispose()
		return

	dispose: () ->
		if @wireframe?
			@wireframe.geometry.dispose()
			@wireframe.material.dispose()

module.exports = BlockWireframe