THREE = require 'three'
coordUtils = require '../utils/coordutils.coffee'
chunkUtils = require '../utils/chunkutils.coffee'

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
		@blockAttachments = null
		@commands = []
		@redos = []
		@edit = true

	start: () ->
		if @grid is null
			throw new Error 'grid cannot be empty'
		if @blockPreview is null
			throw new Error 'blockPreview cannot be empty'
		if @blockModel is null
			throw new Error 'blockModel cannot be empty'
		if @blockAttachments is null
			throw new Error 'blockAttachments cannot be empty'

		# if @data?
		# 	try
		# 			blockModelData = @data.blockModel
		# 			@blockModel.deserialize blockModelData if blockModelData?
		# 			blockAttachmentsData = @data.blockAttachments
		# 			@blockAttachments.deserialize blockAttachmentsData if blockAttachmentsData?
		# 	catch ex
		# 		console.log 'failed to parse localStorage'
			
		geometry = new THREE.PlaneGeometry(999, 999)
		geometry.vertices.forEach (v) =>
			v.applyEuler new THREE.Euler -Math.PI / 2, 0, 0
			v.y = 0
		@ground = new THREE.Mesh geometry

		@updateEdit()

		return

	tick: () ->
		@groundIntersect = coordUtils.mouseIntersect @input, @window, @camera, [@ground] 
		@blockIntersect = if @blockModel is null then null else coordUtils.mouseIntersect @input, @window, @camera, [@blockModel.object]
		inputState = @input.state

		@blockPreview.arrow.visible = @component?
		intersect = (@blockIntersect || @groundIntersect)
		if intersect?
			coord = coordUtils.coordAbove intersect.point, @camera, @blockModel
			position = coordUtils.coordToPoint coord, @blockModel
			@blockPreview.object.position.copy position

		if inputState.mouseClick @keyMap.mouseAdd
			if intersect isnt null
				coord = coordUtils.coordAbove intersect.point, @camera, @blockModel
				@blockModel.setAtCoord coord, @color
				if @component?
					@blockAttachments.addAttachment coord, @component	
				@saveInLocalStorage()

		if inputState.mouseClick @keyMap.mouseRemove
			if intersect isnt null
				coord = coordUtils.coordBelow intersect.point, @camera, @blockModel
				@blockModel.setAtCoord coord, undefined
				@blockAttachments.removeAttachments coord
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

	saveInLocalStorage: () ->
		data = 
			blockModel: @blockModel.serialize()
			blockAttachments: @blockAttachments.serialize()

		window.localStorage.setItem 'editor', JSON.stringify data
			
	getData: () ->
		return JSON.parse window.localStorage.getItem 'editor'

	clear: () ->
		window.localStorage.removeItem 'editor'

	undo: () ->

	redo: () ->

	undoall: () ->

	redoall: () ->

	dispose: () ->
		@ground.geometry.dispose()

	updateEdit: () ->
		if @edit
			@grid.object.visible = true
			@blockPreview.object.visible = true
			@blockModel.origin = new THREE.Vector3 0, 0, 0
		else
			@grid.object.visible = false
			@blockPreview.object.visible = false
			ccw = chunkUtils.ccw @blockModel.chunk
			@blockModel.origin = ccw

	startEdit: () ->
		@edit = true
		@updateEdit()

	endEdit: () ->
		@edit = false
		@updateEdit()

	toggleEdit: () ->
		if @edit
			@endEdit()
		else
			@startEdit()

module.exports = Editor