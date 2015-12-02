THREE = require 'three'
getMouseOvers = require './utils/mouseovers.coffee'
DragCommand = require './commands/dragcommand.coffee'

class Editor
	@$inject: ['input', 'camera', 'window', 'app', 'keyMap', 'blocks', 'events', 'game', 'scene']

	constructor: (@input, @camera, @window, @app, @keyMap, @blocks, @events, @game, @scene) ->
		@blockModel = null
		@objWireframe = new THREE.Object3D()
		@blockType = 'default'
		@selectedListener = (type) =>
			@blockType = type
		@objBlockModel = new THREE.Object3D()
		@command = null

	start: () ->
		@object.add @objWireframe
		@app.attach @objWireframe, 'blockWireframe'

		@object.add @objBlockModel
		@blockModel = @app.attach @objBlockModel, 'blockModel'

		@events.on 'block type selected', @selectedListener

		return

	tick: () ->
		collidables = @game.collidables
		blockModels = _.map collidables, (c) =>
			@app.getComponent c, 'blockModel'
		objs = _.map blockModels, 'obj'

		intersect = getMouseOvers objs, 0, @input, @camera

		mouseCollision = null
		blockModel = null

		if intersect?
			obj = intersect.object
			blockModel = @app.getComponent(obj, 'blockModel', 'search up') || @blockModel

			diff = intersect.point.clone().sub @camera.position
			distance = intersect.distance

			pointAbove = @camera.position.clone().add diff.clone().setLength distance - 0.01
			pointBelow = @camera.position.clone().add diff.clone().setLength distance + 0.01

			mouseCollision = 
				coordAbove: blockModel.pointToCoord pointAbove
				coordBelow: blockModel.pointToCoord pointBelow

		# @updateWireframe(mouseCollision, blockModel)	
		# @updateInput(mouseCollision, blockModel)

		return

	dispose: () ->
		@events.removeListener 'block type selected', @selectedListener

		return

	updateWireframe: (mouseCollision, blockModel) ->
		@objWireframe.visible = mouseCollision?
		if mouseCollision?
			coordAbove = mouseCollision.coordAbove
			position = blockModel.coordToPoint coordAbove
			@objWireframe.position.copy position
		return

	updateInput: (mouseCollision, blockModel) -> 
		# inputState = @input.state

		# if inputState.mouseHold(@keyMap.mouseAdd) and mouseCollision?
		# 	if @command == null
		# 		color = 0xff0000
		# 		@command = new DragCommand(mouseCollision.coordAbove, @blockModel, color)
		# 	else
		# 		@command.endCoord = mouseCollision.coordAbove
		# 	@command.run()

		# if inputState.mouseUp(@keyMap.mouseAdd)
		# 	@command = null
		
		return

	add: (blockModel, coord, value) ->
		blockModel.chunk.set coord.x, coord.y, coord.z, value

	remove: (blockModel, coord) ->
		blockModel.chunk.set coord.x, coord.y, coord.z, undefined

module.exports = Editor