module.exports = 
	ccw: (chunk) ->
		xsum = 0
		ysum = 0
		zsum = 0
		count = 0
		chunk.visit (x, y, z, value) ->
			xsum += x
			ysum += y
			zsum += z
			count++

		return new THREE.Vector3 -xsum / count, -ysum / count, -zsum / count
	