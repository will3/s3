module.exports =
	shouldHitTest: (a, b) ->
		return a.radius > 0 and b.radius > 0

	hitTest: (a, b) ->
		dis = new THREE.Vector3().subVectors b.object.position, a.object.position
		distance = dis.length()
		console.log distance
		return distance < a.radius + b.radius