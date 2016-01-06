class Laser
	@$inject: ['app', 'scene']

	constructor: (@app, @scene) ->
		@color = 0xff0000
		@cooldown = null
		@fireInterval = 200
		@gap = 2
		@dir = new THREE.Vector3 0, 0, 1
		@autofire = false 
		@damageExcludeMask = null
		@ownerId = null

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
		forward = @dir.clone().applyEuler @object.getWorldRotation()

		objAmmo = @app.addPrefab @scene, 'laserAmmo',
			excludeMask: @damageExcludeMask
			ownerId: @ownerId
			dir: forward

		objAmmo.position.copy @object.getWorldPosition().add forward.clone().setLength @gap

module.exports = Laser