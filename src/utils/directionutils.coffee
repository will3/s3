THREE = require 'three'

module.exports =
	getVector: (direction) ->
		mapping = {}
		mapping['front'] = new THREE.Vector3 0, 0, 1
		mapping['back'] = new THREE.Vector3 0, 0, -1
		mapping['left'] = new THREE.Vector3 -1, 0, 0
		mapping['right'] = new THREE.Vector3 1, 0, 0
		mapping['top'] = new THREE.Vector3 0, 1, 0
		mapping['bottom'] = new THREE.Vector3 0, -1, 0

		mapping[direction]

	getQuat: (direction, from = 'front') ->
		new THREE.Quaternion().setFromUnitVectors(
			@getVector from
			@getVector direction
		)

	quatToVector: (quat, from = 'front') ->
		front = @getVector Directions.Front
		front.applyQuaternion quat