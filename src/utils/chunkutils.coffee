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

	count: (chunk) ->
		count = 0
		chunk.visit (x, y, z, value) ->
			count++

		return count

	visitAround: (chunk, coord, radius, callback) ->
		for x in [-radius..radius]
			xDis = Math.abs x
			for y in [-radius + xDis .. radius - xDis]
				yDis = Math.abs y
				for z in [-radius + xDis + yDis .. radius - xDis - yDis]
					zDis = Math.abs z
					dis = xDis + yDis + zDis

					obj = chunk.get coord.x + x, coord.y + y, coord.z + z
					stop = callback coord.x + x, coord.y + y, coord.z + z, obj, dis

					if stop
						return