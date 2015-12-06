THREE = require 'three'
_ = require 'lodash'

class Game
	@$inject: ['scene', 'app', 'input', 'keyMap', 'mouseovers', 'events']

	constructor: (@scene, @app, @input, @keyMap, @mouseovers, @events) ->
		@editMode = false
		@blockType = 'default'	#selected block type
		@attachListener = null
		@dettachListener = null
		@selectables = []
		@selection = null
		@shipControl = null

	start: () ->
		# add asteroid
		object = new THREE.Object3D()
		@scene.add object
		blockModel = @app.attach object, 'blockModel'
		@app.attach object, 'asteroid'

		root = new THREE.Object3D()
		@scene.add root
		@app.attach root, 'editor'
		@shipControl = @app.attach root, 'shipControl'

		@events.on 'attach', @attachListener = (object, component) =>
			if component._type == 'selectable'
				@selectables.push component
			return

		@events.on 'dettach', @dettachListener = (object, component) =>
			_.pull @selectables, component
			return
		
		return

	tick: () ->
		@updateInput()
		return

	dispose: () ->
		@events.removeListener 'attach', @attachListener
		@events.removeListener 'dettach', @dettachListener

	updateInput: () ->
		inputState = @input.state

		if inputState.mouseDown @keyMap.mouseSelect
			objects = _.map @selectables, 'object'
			intersects = @mouseovers.intersectObjects objects

			if intersects.length > 0
				intersect = intersects[0]
				ship = @app.getComponent intersect.object, 'ship', 'search up'
				@shipControl.ship = ship
			return

module.exports = Game