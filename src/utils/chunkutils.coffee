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
	
	boundingBox: (chunk) ->
		min = new THREE.Vector3 Infinity, Infinity, Infinity
		max = new THREE.Vector3 -Infinity, -Infinity, -Infinity

		chunk.visit (x, y, z, value) ->
			min.x = x if x < min.x
			min.y = y if y < min.y
			min.z = z if z < min.z
			max.x = x if x > max.x
			max.y = y if y > max.y
			max.z = z if z > max.z

		return min: min, max: max
				
	radius: (chunk) ->
		box = @boundingBox chunk
		dis = new THREE.Vector3().subVectors box.max, box.min
		return dis.length() / 2