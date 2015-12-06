THREE = require 'three'
DragCommand = require '../commands/dragcommand.coffee'
blockModelUtils = require '../utils/blockmodelutils.coffee'

# builds a ship
class Editor
	@$inject: ['app', 'mouseovers', 'camera', 'input', 'keyMap', 'game', 'blocks', 'scene']

	constructor: (@app, @mouseovers, @camera, @input, @keyMap, @game, @blocks, @scene) ->
		@objWireframe = new THREE.Object3D()

		@baseSelected = false

		@inEdit = false

		# block model in edit
		@blockModel = null

		@hasCollision = false

		@command = null

		@groundY = 0

	start: () ->
		@object.add @objWireframe
		@app.attach @objWireframe, 'blockWireframe'

		geometry = new THREE.PlaneGeometry(999, 999)
		geometry.vertices.forEach (v) =>
			v.applyEuler new THREE.Euler -Math.PI / 2, 0, 0
			v.y = @groundY
		@ground = new THREE.Mesh geometry

		return

	tick: () ->
		@updateKeyboard()
		@updateMouseCollision()
		@updateWireframe()
		@updateClicks()
		return

	dispose: () ->
		@ground.geometry.dispose()

	updateMouseCollision: () ->
		if not @inEdit
			@hasCollision = false
			return

		intersects = []

		if !@baseSelected
			intersects = @mouseovers.intersectObject @ground
		else if @blockModel.obj?
			intersects = @mouseovers.intersectObject @blockModel.obj

		@hasCollision = intersects.length > 0

		if intersects.length == 0
			return

		intersect = intersects[0]

		diff = intersect.point.clone().sub @camera.position
		distance = intersect.distance

		pointAbove = @camera.position.clone().add diff.clone().setLength distance - 0.01
		pointBelow = @camera.position.clone().add diff.clone().setLength distance + 0.01

		@coordAbove = @blockModel.pointToCoord pointAbove
		@coordBelow = @blockModel.pointToCoord pointBelow

	updateWireframe: () ->
		if !@hasCollision
			@objWireframe.visible = false
			return	

		@objWireframe.visible = true

		position = @blockModel.coordToPoint @coordAbove
		@objWireframe.position.copy position

	updateClicks: () ->
		return if not @inEdit

		inputState = @input.state

		block = @blocks[@game.blockType]

		if inputState.mouseClick @keyMap.mouseAdd
			coord = @coordAbove
			@blockModel.set coord.x, coord.y, coord.z, block.color
			if block.component?
				@attachBlockComponent(coord, block.component)

			if !@baseSelected
				@baseSelected = true

		if inputState.mouseClick @keyMap.mouseRemove
			coord = @coordBelow
			@blockModel.set coord.x, coord.y, coord.z, undefined

	updateKeyboard: () ->
		inputState = @input.state
		if inputState.keyDown @keyMap.toggleEdit
			@inEdit = not @inEdit
			if @inEdit
				@startEdit()
			else 
				@endEdit()

	startEdit: () ->
		object = new THREE.Object3D()
		@scene.add object
		@baseSelected = false
		@blockModel = @app.attach object, 'blockModel'

	endEdit: () ->
		@app.attach @blockModel.object, 'ship'
		@app.attach @blockModel.object, 'selectable'
		blockModelUtils.recenter @blockModel

	attachBlockComponent: (coord, componentType) ->
		position = @blockModel.coordToPoint coord
		entity = new THREE.Object3D()
		entity.position.copy position
		@blockModel.object.add entity
		component = @app.attach entity, componentType

module.exports = Editor