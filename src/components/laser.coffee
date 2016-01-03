class Laser
	@$inject: ['app', 'scene']

	constructor: (@app, @scene) ->
		@color = 0xff0000
		@edges = null
		@cooldown = null
		@fireInterval = 1000

	start: () ->
		if @cooldown is null
			throw new Error 'cooldown cannot be empty'

		geometry = new THREE.BoxGeometry 1, 1, 1
		box = new THREE.Mesh geometry
		@edges = new THREE.EdgesHelper box, @color
		@object.add @edges
		geometry.dispose()

		@cooldown.add 'fire', @fireInterval

	tick: () ->
		if @cooldown.ready 'fire'
			@fire()
			@cooldown.refresh 'fire'

	fire: () ->
		objLaser = @app.addPrefab @scene, 'laserAmmo'
		objLaser.position.copy @object.getWorldPosition()

	dispose: () ->
		@edges.geometry.dispose()
		@edges.material.dispose()

module.exports = Laser