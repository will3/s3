THREE = require 'three'
coordUtils = require '../utils/coordutils.coffee'

# builds a ship
class Editor
	@$inject: ['input', 'window', 'camera', 'keyMap', 'app']

	constructor: (@input, @window, @camera, @keyMap, @app) ->
		@grid = null
		@blockModel = null
		@color = 0xffffff
		@component = null
		@ground = null
		@blockPreview = null

	start: () ->
		if @grid is null
			throw new Error 'grid cannot be empty'
		if @blockPreview is null
			throw new Error 'blockPreview cannot be empty'

		serialized = window.localStorage.getItem 'blockModel'
		if serialized isnt null
			@initBlockModel() if @blockModel is null
			@blockModel.deserialize JSON.parse serialized

		geometry = new THREE.PlaneGeometry(999, 999)
		geometry.vertices.forEach (v) =>
			v.applyEuler new THREE.Euler -Math.PI / 2, 0, 0
			v.y = 0
		@ground = new THREE.Mesh geometry

		return

	tick: () ->
		@groundIntersect = coordUtils.mouseIntersect @input, @window, @camera, [@ground] 
		@blockIntersect = if @blockModel is null then null else coordUtils.mouseIntersect @input, @window, @camera, [@blockModel.object]
		inputState = @input.state

		@blockPreview.arrow.visible = @component?
		intersect = (@blockIntersect || @groundIntersect)
		if intersect?
			coord = coordUtils.coordAbove intersect, @camera
			position = coordUtils.coordToPoint coord
			@blockPreview.object.position.copy position

		if inputState.mouseClick @keyMap.mouseAdd
			if intersect isnt null
				coord = coordUtils.coordAbove intersect, @camera
				@initBlockModel() if @blockModel is null
				@blockModel.setAtCoord coord, @color
				@saveInLocalStorage()

		if inputState.mouseClick @keyMap.mouseRemove
			if intersect isnt null
				coord = coordUtils.coordBelow intersect, @camera
				@initBlockModel() if @blockModel is null
				@blockModel.setAtCoord coord, undefined
				@saveInLocalStorage()

		if inputState.keyUp @keyMap.rotateLeft
			@blockPreview.direction.y += Math.PI / 2
			@blockPreview.arrowNeedsUpdate = true

		if inputState.keyUp @keyMap.rotateRight
			@blockPreview.direction.y -= Math.PI / 2
			@blockPreview.arrowNeedsUpdate = true

		if inputState.keyUp @keyMap.rotateUp
			@blockPreview.direction.x += Math.PI / 2 if @blockPreview.direction.x < Math.PI / 2
			@blockPreview.arrowNeedsUpdate = true

		if inputState.keyUp @keyMap.rotateDown
			@blockPreview.direction.x -= Math.PI / 2 if @blockPreview.direction.x > -Math.PI / 2
			@blockPreview.arrowNeedsUpdate = true

		
		return

	initBlockModel: () ->
		objBlockModel = new THREE.Object3D()
		@object.add objBlockModel
		@blockModel = @app.attach objBlockModel, 'blockModel'
		blockMesher = @app.attach objBlockModel, 'blockMesher'
		blockMesher.blockModel = @blockModel

	saveInLocalStorage: () ->
		window.localStorage.setItem 'blockModel', JSON.stringify @blockModel.serialize()

	dispose: () ->
		@ground.geometry.dispose()

module.exports = Editor