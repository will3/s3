class LaserAmmo
	@$inject: ['textures', 'app']

	constructor: (@textures, @app) ->
		@length = 1
		@dir = new THREE.Vector3 0, 0, 1
		@color = 0xffffff
		@speed = 50
		@rigidBody = null
		@objLaser = null
		@laserMaterial = null
		@damage = null

	start: () ->
		if @rigidBody is null
			throw new Error 'rigidBody cannot be empty'
		if @damage is null
			throw new Error 'damage cannot be empty'

		@rigidBody.events.on 'collision', @onCollision = (b) =>
			damagable = @app.getComponent b.object, 'damagable'
			if damagable? and damagable.by @damage
				@app.destroy @object

		@objLaser = new THREE.Object3D()
		@object.add @objLaser

		lineSprite = @app.attach @objLaser, 'lineSprite'
		texture = @textures.get 'laser'
		material = new THREE.MeshBasicMaterial 
			color: @color
			side: THREE.DoubleSide
			alphaMap: texture
			transparent: true

		lineSprite.material = material
		@laserMaterial = material

		lineSprite.dir = @dir
		lineSprite.isDiamond = true
		
		@rigidBody.setVelocity @dir.clone().setLength @speed

	dispose: () ->
		@laserMaterial.dispose()
		@rigidBody.events.removeListener 'collision', @onCollision

module.exports = LaserAmmo