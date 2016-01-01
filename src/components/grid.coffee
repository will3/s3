THREE = require 'three'

class Grid
	constructor: () ->
		@numx = 16
		@numz = 16
		@origin = new THREE.Vector3 -8, 0, -8
		@lineMaterial = new THREE.LineBasicMaterial 
			color: 0xffffff
			transparent: true
			opacity: 0.5
		@geometry = null

	start: () ->
		@geometry = new THREE.Geometry()

		maxx = @numx
		maxz = @numz

		for x in [0..@numx]
			@geometry.vertices.push new THREE.Vector3 x, 0, 0
			@geometry.vertices.push new THREE.Vector3 x, 0, maxz

		for z in [0..@numz]
			@geometry.vertices.push new THREE.Vector3 0, 0, z
			@geometry.vertices.push new THREE.Vector3 maxx, 0, z

		@geometry.vertices.forEach (v) =>
			v.add @origin
			.sub new THREE.Vector3 .5, .5, .5

		@line = new THREE.LineSegments @geometry, @lineMaterial

		@object.add @line

	dispose: () ->
		@lineMaterial.dispose() if @lineMaterial isnt null
		@geometry.dispose if @geometry isnt null

module.exports = Grid