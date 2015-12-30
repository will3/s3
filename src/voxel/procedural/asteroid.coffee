SimplexNoise = require 'simplex-noise'
ndarray = require 'ndarray'
THREE = require 'three'
voxelize = require 'voxelize'
Alea = require 'alea'

module.exports = (params) ->
	params = params || {}
	widthSegments = params.widthSegments || 16
	heightSegments = params.heightSegments || 16
	size = params.size || 10
	dim = params.dim || [1.2, 1, 1]
	seed = params.seed || Math.random()
	random = new Alea seed

	noise = new SimplexNoise(random)

	sphere = new THREE.SphereGeometry(1, widthSegments, heightSegments)

	p = 0.8

	sphere.vertices.forEach (v) ->
		n = noise.noise3D v.x * p, v.y * p, v.z * p
		v.x *= dim[0]
		v.y *= dim[1]
		v.z *= dim[2]
		scale = 1 + n * 0.3
		v.multiplyScalar scale
		v.multiplyScalar size
		return

	result = voxelize(
		sphere.faces.map (f) ->
			return [f.a, f.b, f.c]
		sphere.vertices.map (v) ->
			return [v.x, v.y, v.z]
	)

	sphere.dispose()

	voxels = result.voxels
	shape = voxels.shape
	data = voxels.data

	colors = [
		'rgb(46,46,46)',		
		'rgb(56,56,56)',		
		'rgb(66,66,66)',		
		'rgb(76,76,76)',		
		'rgb(86,86,86)',		
		'rgb(96,96,96)'
	]

	colors = colors.map (c) ->
		new THREE.Color(c).getHex()

	for i in [0..shape[0]]
		for j in [0..shape[1]]
			for k in [0..shape[2]]
				b = voxels.get i, j, k
				if !b
					continue
				p = 0.04
				n = noise.noise3D(i * p, j * p, k * p)
				index = Math.floor((n + 1) / 2 * colors.length)
				voxels.set i, j, k, colors[index]

	return result