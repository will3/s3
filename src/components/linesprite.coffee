class LineSprite
	@$inject: ['camera', 'scene', 'app']

	constructor: (@camera, @scene, @app) ->
		@plane = null
		@dir = new THREE.Vector3 1, 0, 0 
		@right = new THREE.Vector3 1, 0, 0
		@length = 3
		@width = 3

		@isDiamond = false

		@material = null

	start: () ->
		if @material is null
			throw new Error 'material cannot be empty'

		geometry = new THREE.Geometry()
		geometry.vertices.push new THREE.Vector3()
		geometry.vertices.push new THREE.Vector3()
		geometry.vertices.push new THREE.Vector3()
		geometry.vertices.push new THREE.Vector3()

		geometry.faces.push new THREE.Face3 0, 1, 2
		geometry.faces.push new THREE.Face3 2, 3, 0

		geometry.faceVertexUvs[0] = [
			[
				new THREE.Vector2 0, 0
				new THREE.Vector2 0, 1
				new THREE.Vector2 1, 1
			],
			[
				new THREE.Vector2 1, 1
				new THREE.Vector2 1, 0
				new THREE.Vector2 0, 0
			]
		]

		@plane = new THREE.Mesh geometry, @material
		@object.add @plane

		@geometry = geometry

	tick: () ->
		quat1 = new THREE.Quaternion().setFromUnitVectors @right, @dir

		look = new THREE.Vector3().subVectors @object.position, @camera.position
		look.normalize()
		offset = look.cross @dir
		offset.setLength @width / 2

		start = @dir.clone().setLength -@length / 2
		end = @dir.clone().setLength @length / 2
		mid = start.clone().add(end).multiplyScalar 0.5

		if @isDiamond
			a = start
			b = mid.clone().sub offset
			c = end
			d = mid.clone().add offset
		else
			a = start.clone().sub offset
			b = start.clone().add offset
			c = end.clone().add offset
			d = end.clone().sub offset

		@geometry.vertices[0].copy a
		@geometry.vertices[1].copy b
		@geometry.vertices[2].copy c
		@geometry.vertices[3].copy d
		@geometry.verticesNeedUpdate = true

	dispose: () ->
		@geometry.dispose()

module.exports = LineSprite