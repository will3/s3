class LaserAmmo
	constructor: () ->
		@geometry = null
		@material = null
		@length = 1
		@dir = new THREE.Vector3 0, 0, 1
		@color = 0xff0000
		@speed = 1
		@rigidBody = null
		@objLaser = null

	start: () ->
		if @rigidBody is null
			throw new Error 'rigidBody cannot be empty'

		# init geometry
		@geometry = new THREE.Geometry()
		@geometry.vertices.push new THREE.Vector3()
		@geometry.vertices.push @dir.clone().setLength -@length
		@material = new THREE.LineBasicMaterial color: @color
		@objLaser = new THREE.Line @geometry, @material
		@object.add @objLaser

		@rigidBody.velocity = @dir.clone().setLength @speed

module.exports = LaserAmmo