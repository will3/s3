Directions = require '../directions.coffee'
THREE = require 'three'

module.exports =

	getVector: (direction) ->
		mapping = {}
		mapping[Directions.Front] = new THREE.Vector3 0, 0, 1
		mapping[Directions.Back] = new THREE.Vector3 0, 0, -1
		mapping[Directions.Left] = new THREE.Vector3 -1, 0, 0
		mapping[Directions.Right] = new THREE.Vector3 1, 0, 0
		mapping[Directions.Top] = new THREE.Vector3 0, 1, 0
		mapping[Directions.Bottom] = new THREE.Vector3 0, -1, 0

		mapping[direction]

	getQuat: (direction, from = Directions.Front) ->
		new THREE.Quaternion().setFromUnitVectors(
			@getVector from
			@getVector direction
		)

	quatToVector: (quat, from = Directions.Front) ->
		front = @getVector Directions.Front
		front.applyQuaternion quat