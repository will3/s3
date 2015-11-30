THREE = require 'three'
getMouseOvers = require './utils/mouseovers.coffee'

class Editor
	@$inject: ['input', 'camera', 'window', 'app', 'keyMap', 'blocks', 'events', 'game', 'scene']

	constructor: (@input, @camera, @window, @app, @keyMap, @blocks, @events, @game, @scene) ->
		@blockModel = null
		@objWireframe = new THREE.Object3D()
		@blockType = 'default'
		@selectedListener = (type) =>
			@blockType = type
		@objBlockModel = new THREE.Object3D()
		@ground = null

	start: () ->
		@object.add @objWireframe
		@app.attach @objWireframe, 'blockWireframe'

		@object.add @objBlockModel
		@blockModel = @app.attach @objBlockModel, 'blockModel'

		@events.on 'block type selected', @selectedListener

		geometry = new THREE.PlaneGeometry(999, 999)
		geometry.vertices.forEach (v) ->
			v.applyEuler new THREE.Euler -Math.PI / 2, 0, 0
		@ground = new THREE.Mesh geometry

		return

	tick: () ->
		collidables = @game.collidables
		blockModels = _.map collidables, (c) =>
			@app.getComponent c, 'blockModel'
		objs = _.map blockModels, 'obj'

		intersect = getMouseOvers objs, @ground, @input, @camera

		mouseCollision = null
		blockModel = null

		if intersect?
			obj = intersect.object
			blockModel = if obj is @ground then @blockModel else @app.getComponent obj, 'blockModel', 'search up'

			diff = intersect.point.clone().sub @camera.position
			distance = intersect.distance

			pointAbove = @camera.position.clone().add diff.clone().setLength distance - 0.01
			pointBelow = @camera.position.clone().add diff.clone().setLength distance + 0.01

			mouseCollision = 
				coordAbove: blockModel.pointToCoord pointAbove
				coordBelow: blockModel.pointToCoord pointBelow		

		@updateWireframe(mouseCollision, blockModel)	
		@updateClick(mouseCollision, blockModel)

		return

	dispose: () ->
		@events.removeListener 'block type selected', @selectedListener
		@ground.geometry.dispose()

		return

	updateWireframe: (mouseCollision, blockModel) ->
		@objWireframe.visible = mouseCollision?
		if mouseCollision?
			coordAbove = mouseCollision.coordAbove
			position = blockModel.coordToPoint coordAbove
			@objWireframe.position.copy position
		return

	updateClick: (mouseCollision, blockModel) -> 
		inputState = @input.state
		if inputState.mouseClick(@keyMap.mouseAdd) and mouseCollision?
			coordAbove = mouseCollision.coordAbove
			block = @blocks[@blockType]
			color = block.color
			qty = block.qty
			if qty <= 0
				return

			@add blockModel, coordAbove, color
			block.qty--
			@events.emit('block quantity changed');

		if inputState.mouseClick(@keyMap.mouseRemove) and mouseCollision?
			coordBelow = mouseCollision.coordBelow
			@remove blockModel, coordBelow
		
		return

	add: (blockModel, coord, value) ->
		blockModel.chunk.set coord.x, coord.y, coord.z, value

	remove: (blockModel, coord) ->
		blockModel.chunk.set coord.x, coord.y, coord.z, undefined

module.exports = Editor