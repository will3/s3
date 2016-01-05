class Laser
	@$inject: ['app', 'scene']

	constructor: (@app, @scene) ->
		@color = 0xff0000
		@cooldown = null
		@fireInterval = 200
		@gap = 2
		@dir = new THREE.Vector3 0, 0, 1
		@autofire = false

	start: () ->
		if @cooldown is null
			throw new Error 'cooldown cannot be empty'

		@cooldown.add 'fire', @fireInterval

	tick: () ->
		if @autofire
			@fire()

	fire: () ->
		if @cooldown.ready 'fire'
				@_fire()
				@cooldown.refresh 'fire'

	_fire: () ->
		objAmmo = @app.addPrefab @scene, 'laserAmmo'

		forward = @dir.clone().applyEuler @object.getWorldRotation()

		objAmmo.position.copy @object.getWorldPosition().add forward.clone().setLength @gap

		laserAmmo = @app.getComponent objAmmo, 'laserAmmo'
		laserAmmo.dir = forward

module.exports = Laser