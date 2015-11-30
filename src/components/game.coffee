THREE = require 'three'
class Game
	@$inject: ["scene", "app", "input"]

	constructor: (@scene, @app, @input) ->
		@editMode = false
		@editor = null
		@collidables = []

	start: () ->
		# add asteroid
		object = new THREE.Object3D()
		@scene.add object
		@app.attach object, 'blockModel'
		@app.attach object, 'asteroid'
		@collidables.push object

		@editor = @app.attach @object, 'editor'
		@editor.$active = false

		return

	tick: () ->
		@updateInput()
		return

	updateInput: () ->
		inputState = @input.state
		if inputState.keyDown 'b'
			@editMode = !@editMode
			if @editMode
				@startEdit()
			else
				@endEdit()
		return

	startEdit: () ->
		@editor.$active = true

	endEdit: () ->
		@editor.$active = false

module.exports = Game