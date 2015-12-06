THREE = require 'three'

module.exports = 
	hash: (coord) ->
		return [coord.x, coord.y, coord.z].join ','

	parse: (hash) ->
		coord = hash.split ','
		return new THREE.Vector3(
			parseFloat coord[0] 
			parseFloat coord[1]
			parseFloat coord[2]
		)